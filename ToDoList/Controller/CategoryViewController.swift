//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Henry Jiang on 3/29/19.
//  Copyright © 2019 Henry Jiang. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load categories from database
        loadCategories()
    }
    
    
    
    ///////////////////////////////////////////
    //MARK: - TableView DataSource Methods
    
    // Set the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categoryArray.count
    }
    
    // Items in cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
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
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            print(self.categoryArray.count)
            
            // Save the updated category array to database
            self.saveCategories()
        }
        
        // Add action to the alert
        alert.addAction(action)
        
        // Present the alert to the screen
        present(alert, animated: true, completion: nil)
        
        print(self.categoryArray.count)

    }
    
    
    
    ///////////////////////////////////////////
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    
    
    ///////////////////////////////////////////
    //MARK: - Data Manipulation Methods
    
    // Save method
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error Saving Context \(error)")
        }
        
        tableView.reloadData()
    }
    
    // Load method
    func loadCategories() {
        
        do {
            categoryArray = try context.fetch(Category.fetchRequest())
            
        } catch {
            print("Error Fetching Context \(error)")
        }
        
        tableView.reloadData()
    }
}
