//
//  CategoryViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/27/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework

class CategoryViewController: UIViewController {
    
    @IBOutlet private var myView: UIView!
    @IBOutlet private weak var myTableView: UITableView!
    
    var categories: [Category] = []
    
    // Create instance of Appy database
    var database = Database()
    
    let defaults = UserDefaults.standard
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color
        myView.backgroundColor = UIColor.flatNavyBlueColorDark()

        myView.keyboardDismiss()
        
        // Change nav bar title
        guard let title = defaults.string(forKey: "group_name") else {fatalError("Failed to retrieve group_name")}
        navigationItem.title = title        
        
        let group_id = Int32(defaults.integer(forKey: "group_id"))
        let user_id = Int32(defaults.integer(forKey: "user_id"))
        categories = database.queryCategoryGiveGroupID(group_id: group_id, user_id: user_id)
        
        // Add categoies
        categories += database.queryCategoryGivenPermission(user_id: user_id, group_id: group_id)
        
        
        myTableView.modifyTableViewStyle(forCell: "categoryCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
    
    override func didReceiveMemoryWarning() {
        print("Recevied memory warning in CategoryViewController")
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField  = UITextField()
        
        let alert = UIAlertController(title: "Add New Appy Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text! != "" {
                
                guard let color: String = (UIColor.randomFlat()?.hexValue()) else {fatalError("No hex color created.")}
                
                
                let group_id = Int32(self.defaults.integer(forKey: "group_id"))
                
                self.database.insertCategory(category_name: textField.text!, category_color: color, group_id: Int32(group_id))
                
                self.categories.append(Category(name: textField.text!, color: color))
                
                self.myTableView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
            self.myTableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Create New Category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let name = categories[indexPath.row].name
        let color = categories[indexPath.row].color
        
        cell.modifyTableViewCellStyle(name: name, color: color)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let category_name = categories[indexPath.row].name
            let group_id = Int32(defaults.integer(forKey: "group_id"))
            let user_id = Int32(defaults.integer(forKey: "user_id"))
            if let category_id = database.queryCategoryID(category_name: category_name, group_id: group_id) {
                database.deleteCategory(category_id: category_id)
                
                let items = database.queryItemGivenCategoryID(category_id: category_id)
                
                // Delete items inside the category being deleted
                for item in items {
                    guard let item_id = database.queryItemID(item_name: item.name, category_id: category_id) else {fatalError("Failed to get item_id in category delete section")}
                    
                    database.deleteItem(item_id: item_id)
                }
                
                self.categories.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else if let category_id = database.queryCategoryIDUsingPermission(category_name: category_name, group_id: group_id, user_id: user_id) {
                database.deleteCategory(category_id: category_id)
                
                let items = database.queryItemGivenCategoryID(category_id: category_id)
                
                // Delete items inside the category being deleted
                for item in items {
                    guard let item_id = database.queryItemID(item_name: item.name, category_id: category_id) else {fatalError("Failed to get item_id in category delete section")}
                    
                    database.deleteItem(item_id: item_id)
                }
                
                self.categories.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else {
                showError(view: self.view, textLabel: "Could not delete category due to id error")
                return
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // get category name, color and id
        let user_id = Int32(defaults.integer(forKey: "user_id"))
        let group_id = Int32(defaults.integer(forKey: "group_id"))
        let category_name = categories[indexPath.row].name
        let category_color = categories[indexPath.row].color
        
        
        if let category_id = database.queryCategoryID(category_name: category_name, group_id: group_id, user_id: user_id) {
            defaults.set(category_id, forKey: "category_id")
        }
        else if let category_id = database.queryCategoryIDUsingPermission(category_name: category_name, group_id: group_id, user_id: user_id) {
            defaults.set(category_id, forKey: "category_id")
        }
        else {
            fatalError("Could not get category_id from database")
        }
        
        // get category name, color and id to defaults
        defaults.set(category_name, forKey: "category_name")
        defaults.set(category_color, forKey: "category_color")
        
        performSegue(withIdentifier: "goToItemFromCategory", sender: self)
    }
}
