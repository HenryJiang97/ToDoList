//
//  ViewController.swift
//  ToDoList
//
//  Created by Henry Jiang on 2/22/19.
//  Copyright © 2019 Henry Jiang. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ViewController: SwipeTableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            // Load items from Datafile Path
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
        
        if let colorHex = selectedCategory?.color {
            
            title = selectedCategory!.name
            
            if let navBarColor = UIColor(hexString: colorHex) {
                navBar.barTintColor = navBarColor
                
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                
                // Set navigation bar title color
                let textAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                navBar.titleTextAttributes = textAttributes
                
                searchBar.barTintColor = navBarColor
            }
        }
    }
    
    // Change the color back to original when the page is about to disappear
    override func viewWillDisappear(_ animated: Bool) {
        
        guard let originalColor = UIColor(hexString: "1D9BF6") else {fatalError()}
        
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
    }
    

    
    ////////////////////////////////////////////////////////////////////////
    //MARK: - TableView DataSource Methods
    
    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1;
    }
    
    // Item in the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell;
    }
    

    ////////////////////////////////////////////////////////////////////////
    //MARK: - Table View Delegate Methods
    
    // When click on TableView Row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
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
        
        // Add the action to the alert
        alert.addAction(action)
        
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    ////////////////////////////////////////////////////////////////////////
    //MARK: - Data Manipulation Methods
    
    // Load data method
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from swipe
    override func updateModel(at indexPath: IndexPath) {

        if let todoItemsToDelete = self.todoItems?[indexPath.row] {

            do {
                try self.realm.write {
                    self.realm.delete(todoItemsToDelete)
                }
            } catch {
                print("Error Deleting Context \(error)")
            }
        }
    }
}


//MARK: - Search bar methods
//////////////////////////////////////////////////////////////////////
extension ViewController : UISearchBarDelegate {

    // Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
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
