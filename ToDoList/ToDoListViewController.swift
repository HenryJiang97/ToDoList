//
//  ViewController.swift
//  ToDoList
//
//  Created by Henry Jiang on 2/22/19.
//  Copyright © 2019 Henry Jiang. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let itemArray = ["To Do 1", "To Do 2", "To Do 3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

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
}

