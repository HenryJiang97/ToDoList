//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Henry Jiang on 3/29/19.
//  Copyright © 2019 Henry Jiang. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load categories from database
        loadCategories()
        
        tableView.rowHeight = 80.0
    }
    
    
    
    ///////////////////////////////////////////
    //MARK: - TableView DataSource Methods
    
    // Set the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories?.count ?? 1
    }

    
    // Items in cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added Yet"
        
        return cell
    }

    
    
    ///////////////////////////////////////////
    //MARK: - Add button pressed method
    
    // Add button pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Create new textfield for alert
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        // Get category name from textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
    
        
        // Add new category to the category array
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            
            // Save the updated category array to database
            self.save(category: newCategory)
        }
        
        // Add action to the alert
        alert.addAction(action)
        
        // Present the alert to the screen
        present(alert, animated: true, completion: nil)

    }
    
    
    
    ///////////////////////////////////////////
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    
    ///////////////////////////////////////////
    //MARK: - Data Manipulation Methods
    
    // Save method
    func save(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving Context \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from swipe
    override func updateModel(at indexPath: IndexPath) {

        if let categoryToDelete = self.categories?[indexPath.row] {

            do {
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
                }
            } catch {
                print("Error Deleting Context \(error)")
            }
        }
    }
    
    // Load method
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}
