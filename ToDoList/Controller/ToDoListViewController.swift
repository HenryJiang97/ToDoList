//
//  ViewController.swift
//  ToDoList
//
//  Created by Henry Jiang on 2/22/19.
//  Copyright © 2019 Henry Jiang. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            // Load items from Datafile Path
            
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
    }

    
    ////////////////////////////////////////////////////////////////////////
    //MARK: - TableView DataSource Methods
    
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
    //MARK: - Table View Delegate Methods
    
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
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.ifDone = false;
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            
            // Store arrays to datafile path
            self.saveItems()
            
        }
        
        // Add the action to the alert
        alert.addAction(action)
        
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    ////////////////////////////////////////////////////////////////////////
    //MARK: - Data Manipulation Methods
    // Save data method
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error Saving Context \(error)")
        }
        
        tableView.reloadData()
    }
    
    // Load data method
    func loadItems(with additionalPredicate : NSPredicate? = nil) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // Predicat to get items matchs the category name
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // Combine additional predicate with category predicate
        if (additionalPredicate != nil) {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate!])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        // Sort the results
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
    
}


//MARK: - Search bar methods
//////////////////////////////////////////////////////////////////////
extension ViewController : UISearchBarDelegate {
    
    // Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Get results
        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        
        loadItems(with: predicate)

    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // Get the main Thread and Restore to the original state
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
