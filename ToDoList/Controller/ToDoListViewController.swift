//
//  ViewController.swift
//  ToDoList
//
//  Created by Henry Jiang on 2/22/19.
//  Copyright © 2019 Henry Jiang. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var itemArray = [item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init itemArray
        let newItem1 = item()
        newItem1.title = "To Do 1"
        itemArray.append(newItem1)
        
        let newItem2 = item()
        newItem2.title = "To Do 2"
        itemArray.append(newItem2)
        
        let newItem3 = item()
        newItem3.title = "To Do 3"
        itemArray.append(newItem3)
        
        
        // Reset to defaults saved last time
        if let items = defaults.array(forKey: "ToDoListArray") as? [item] {
            itemArray = items
        }
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
        
        // Set default text for textLabel
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        // Set default accessory type for each row
        cell.accessoryType = (itemArray[indexPath.row].ifDone) ? .checkmark : .none
        
        return cell;
    }
    

    ////////////////////////////////////////////////////////////////////////
    // Table View Delegate Methods   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].ifDone = !itemArray[indexPath.row].ifDone
        
        
        // Appears checkmark when itemArray[currentRow].ifDone == true,
        // disappear when ifDone == false
        
        tableView.cellForRow(at: indexPath)?.accessoryType = (itemArray[indexPath.row].ifDone) ? .checkmark : .none
        
        
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
            let newItem = item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            
            // Store arrays to user defaults for later use
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
        
        // Add the action to the alert
        alert.addAction(action)
        
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    
}
