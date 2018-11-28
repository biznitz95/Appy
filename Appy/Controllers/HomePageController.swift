//
//  HomePageController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/17/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework

class HomePageController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var myView: UIView!
    @IBOutlet private weak var myTableView: UITableView!
    @IBOutlet private var logoutButton: UIBarButtonItem!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    
    // MARK: - Internal Variables
    
    var groups: [Group] = []
    let defaults = UserDefaults.standard
    var database = Database()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color
        myView.backgroundColor = UIColor.flatNavyBlueColorDark()
        
        myView.keyboardDismiss()
        
        // Load groups if provided a user_id
        let user_id = Int32(defaults.integer(forKey: "user_id"))
        groups = database.queryGroupGivenUserID(user_id: user_id)
        
        self.navigationController?.navigationBar.modifyBar()

        myTableView.modifyTableViewStyle(forCell: "Cell")
        myTableView.dataSource = self
        myTableView.delegate = self
        
        self.view.addSubview(myTableView)
        
        let permissions = database.queryPermission(user_id: user_id)
        
        if !permissions.isEmpty {
            for permission in permissions {
                guard let main_user_id = permission.main_user_id else { fatalError("Did not provide main_user_id")}
                guard let category_id = permission.category_id else {fatalError()}
                guard let chat_id = permission.chat_id else {fatalError()}
                
                addNewCategory(main_user_id: main_user_id, user_id: user_id, category_id: category_id, chat_id: chat_id)
                
                permission.setGroupId(group_id: 0)
            }
        }
        else {
            print("Permission in empty")
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField  = UITextField()
        
        let alert = UIAlertController(title: "Add New Appy Group", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text! != "" {
                
                guard let color: String = (UIColor.randomFlat()?.hexValue()) else {fatalError("No color provided")}

                guard let user_name = self.defaults.string(forKey: "user_name") else {fatalError("Could not retreive user_name from defaults")}
                let user_id = Int32(self.defaults.integer(forKey: "user_id"))
                
                self.database.insertGroup(group_name: textField.text!, user_id: user_id, user_name: user_name, group_color: color)
                
                self.groups.append(Group(groupName: textField.text!, groupColor: color))
                
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
            field.placeholder = "Create New Group"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func addNewCategory(main_user_id: Int32, user_id: Int32, category_id: Int32, chat_id: Int32) {
        var textField  = UITextField()
        var group_chosen: String = ""
        
        let alert = UIAlertController(title: "Choose Group To Add Cateogory You Were Invited To", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text! != "" {
                
                group_chosen = textField.text!
                
                guard let newGroupID = self.database.queryGroupID(group_name: group_chosen, user_id: user_id) else { fatalError("Could not retrieve group_id")}
                
                self.database.updatePermission(main_user_id: main_user_id, user_id: user_id, group_id: newGroupID, category_id: category_id, chat_id: chat_id)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
            self.myTableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Create New Group"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
}

// MARK: - UITableViewDataSource

extension HomePageController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let name = groups[indexPath.row].name
        let color = groups[indexPath.row].color
        
        cell.modifyTableViewCellStyle(name: name, color: color)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let user_id = Int32(defaults.integer(forKey: "user_id"))
            let group_name = groups[indexPath.row].name
            guard let group_id = database.queryGroupID(group_name: group_name, user_id: user_id) else {fatalError("Error getting group_id from database")}
            
            database.deleteGroup(group_id: group_id)
            
            let categories = database.queryCategoryGiveGroupID(group_id: group_id)
            
            for category in categories {
                let category_name = category.name
                guard let category_id = database.queryCategoryID(category_name: category_name, group_id: group_id) else {fatalError("Failed to get category_id")}
                
                database.deleteCategory(category_id: category_id)
                
                let items = database.queryItemGivenCategoryID(category_id: category_id)
                
                // Delete items inside the category being deleted
                for item in items {
                    guard let item_id = database.queryItemID(item_name: item.name, category_id: category_id) else {fatalError("Failed to get item_id in category delete section")}
    
                    database.deleteItem(item_id: item_id)
                }
            }


            self.groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDelegate

extension HomePageController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user_id = Int32(defaults.integer(forKey: "user_id"))
        let group_name = groups[indexPath.row].name
        guard let group_id = database.queryGroupID(group_name: group_name, user_id: user_id) else {fatalError("No group_id found")}
        
        defaults.set(groups[indexPath.row].name, forKey: "group_name")
        defaults.set(groups[indexPath.row].color, forKey: "group_color")
        defaults.set(group_id, forKey: "group_id")
        
        performSegue(withIdentifier: "goToCategoryFromGroup", sender: self)
    }
    
}

