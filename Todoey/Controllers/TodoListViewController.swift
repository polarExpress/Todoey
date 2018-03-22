//
//  ViewController.swift
//  Todoey
//
//  Created by Timotej Kos on 20/03/2018.
//  Copyright © 2018 Timotej Kos. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        // Gets triggered when selectedCategory is set with value
        didSet {
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // We need to access context which is created in AppDelegate through variable persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Retrieve items
        loadItems()
        
    }
    
    //MARK - UITableViewController datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Show checkmark if property done is true
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - UITableViewController delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        // Toggle done property in item
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
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
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
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
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // Re-render view with new data
        tableView.reloadData()
    }
    
    // Default parameter is Item.fetchRequest()
    func loadItems(_ request: NSFetchRequest<Item> = Item.fetchRequest(), _ predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        
        // Re-render view with new data
        tableView.reloadData()

    }

}

//MARK - Search bar methods
// Extension allows us to split our controller (extend class) to avoid spaghetti code
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // We need to specify data type for this method
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(request, predicate)
        
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

