//
//  ViewController.swift
//  Todoey
//
//  Created by Timotej Kos on 20/03/2018.
//  Copyright © 2018 Timotej Kos. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Todo Item 1", "Todo Item 2", "Todo Item 3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //MARK - UITableViewController datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK - UITableViewController delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            self.itemArray.append(textField.text!)
            
            // Re-render view with new data
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
    
}

