//
//  ViewController.swift
//  ToDoList
//
//  Created by Henry Jiang on 2/22/19.
//  Copyright © 2019 Henry Jiang. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var itemArray = ["To Do 1", "To Do 2", "To Do 3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    ////////////////////////////////////////////////////////////////////////
    // Table view setting
    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count;
    }
    
    // Item in the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row];
        
        return cell;
    }
    

    ////////////////////////////////////////////////////////////////////////
    // Table View Delegate Methods   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Appears checkmark when selected, disappear when deselected
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
        // Deselect row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    // Add Button action when pressed
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // Init a UIAlertController
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        // Add a Text Field to the Alert Controller
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // Action when pressed the "Add Item" button
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // Happen after "Add Item button is clicked by the user"
            
            // Add new task to the item array and reload tableview
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
        }
        
        // Add the action to the alert
        alert.addAction(action)
        
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    
}
