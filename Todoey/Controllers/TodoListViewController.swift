//
//  ViewController.swift
//  Todoey
//
//  Created by Timotej Kos on 20/03/2018.
//  Copyright © 2018 Timotej Kos. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        // Gets triggered when selectedCategory is set with value
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Navigation controller does not exist in viewDidLoad yet
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        guard let colorHex = selectedCategory?.cellBackgroundColor else {fatalError()}
        
        updateNavBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("NavigationController does not exist")}
        
        guard let navbarColor = UIColor(hexString: colourHexCode) else {fatalError()}
        
        let contrastColor = ContrastColorOf(navbarColor, returnFlat: true)
    
        navBar.barTintColor = navbarColor
        navBar.tintColor = contrastColor
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: contrastColor]
        searchBar.barTintColor = navbarColor
    }
    
    //MARK - UITableViewController datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // Show checkmark if property done is true
            cell.accessoryType = item.done ? .checkmark : .none
            
            // selectedCategory and todoItems cannot be nil that's why we can unwrap it
            // because we have if let item check on top means we have items and selectedCategory
            if let colour = UIColor(hexString: selectedCategory!.cellBackgroundColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                
            }
            
            
        } else {
            
            cell.textLabel?.text = "No items"
            
        }
        
        return cell
    }
    
    //MARK - UITableViewController delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        // Toggle done property in item
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add new items to todo list
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Variable to hold textField text
        var textField = UITextField()
        
        // Create alert controller
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        // Create "button" with action for alert controller
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What happens when user clicks Add Item button in alert popup
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()

        }
        
        // Closure gets triggered when textField is initialized in alert
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Insert text"
            // Local alertTextField exist only in this closure,
            // that is why we create reference to local variable at initialization
            textField = alertTextField
        }
        
        // Add button to controller
        alert.addAction(action)
        
        // Show controller
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK - Model manipulation methods
    
    // Default parameter is Item.fetchRequest()
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        // Re-render view with new data
        tableView.reloadData()

    }
    
    
    //MARK - Delete Item When Swiped
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item \(error)")
            }
            
        }
        
    }

}

//MARK - Search bar methods
// Extension allows us to split our controller (extend class) to avoid spaghetti code
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
    
    // Listener for search bar typing changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            // Get all items
            loadItems()
            
            // Hide cursor and keyboard (resign to initial state)
            // Ask DispatchQueue for main queue to run our function on
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        
    }
}

