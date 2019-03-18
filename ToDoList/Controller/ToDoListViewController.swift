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
    
    // Define the Datafile Path to store the data to device
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load items from Datafile Path
        loadItems()
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
    
    // When click on TableView Row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].ifDone = !itemArray[indexPath.row].ifDone
        
        // Store arrays to datafile path
        self.saveItems()
        
        
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
//            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            // Store arrays to datafile path
            self.saveItems()
            
        }
        
        // Add the action to the alert
        alert.addAction(action)
        
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    // Save data method
    func saveItems() {
        // Store arrays using Datafile Path
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Encoding itemArray Error, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // Load data method
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([item].self, from: data)
            } catch {
                print("Decoding itemArray Error, \(error)")
            }
        }
    }
    
}
