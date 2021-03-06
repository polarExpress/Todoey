//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Timotej Kos on 22/03/2018.
//  Copyright © 2018 Timotej Kos. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

// We inherit from our Superclass which has all the swipe functionality
class CategoryViewController: SwipeTableViewController  {
    
    let realm = try! Realm()

    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve categories
        loadCategories()
        
    }

    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // We create initial cell with swipe functionality in our superclass (SwipeTableViewController) and then just override it here to add text label to it
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            guard let categoryColor = UIColor(hexString: category.cellBackgroundColor) else {fatalError()}
            
            cell.textLabel?.text = category.name
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
        } else {
            
            cell.textLabel?.text = "No categories"
            
        }
        
        return cell
    }
    
    //MARK - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Variable to hold textField text
        var textField = UITextField()
        
        // Create alert controller
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // Create "button" with action for alert controller
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //What happens when user clicks Add Item button in alert popup
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.saveCategories(newCategory)
            
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
    
    //MARK - Data Manipulation Mehtods
    func saveCategories(_ category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        // Re-render view with new data
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        // Re-render view with new data
        tableView.reloadData()
        
    }
    
    //MARK - Delete Category When Swiped
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category \(error)")
            }

        }
        
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
}

