//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Timotej Kos on 22/03/2018.
//  Copyright © 2018 Timotej Kos. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
    
    // We need to access context which is created in AppDelegate through variable persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve categories
        loadCategories()
    }

    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
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
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            self.saveCategories()
            
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
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // Re-render view with new data
        tableView.reloadData()
    }
    
    // Default parameter is Category.fetchRequest()
    func loadCategories(_ request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        
        // Re-render view with new data
        tableView.reloadData()
        
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
}
