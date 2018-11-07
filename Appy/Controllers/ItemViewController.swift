//
//  ItemViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/27/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework
import Lottie

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var myView: UIView!
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var animationView: LOTAnimationView!
    
    var navBarTitle: String?
    var navBarColor: String?
    var CATEGORY_NAME: String?
    var GROUP_NAME: String?
    
    var items = [Item]()
    var database = Database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color
        myView.backgroundColor = UIColor.flatNavyBlueColorDark()
        
        // Animation set
        animationView.setAnimation(named: "message")
        animationView.loopAnimation = true
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        // Change nav bar title
        if let _ = navBarTitle {
            self.navigationItem.title = navBarTitle
        }
        if let _ = navBarColor {
            _ = UIColor.init(hexString: navBarColor)
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
        }
        
        let user_name = database.foo(name: nil)
        guard let user_id = database.queryUserID(user_name: user_name) else {fatalError("No user_id provided.")}
        guard let category_name = CATEGORY_NAME else {fatalError("Empty navBarTitle.")}
        guard let group_name = GROUP_NAME else {fatalError("No group_name")}
        guard let group_id = database.queryGroupID(group_name: group_name, user_id: user_id) else {fatalError("No group_id found")}
        guard let category_id = database.queryCategoryID(category_name: category_name, group_id: group_id) else {fatalError("No category id found")}
        
        items = database.queryItemGivenCategoryID(category_id: category_id)
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
        myTableView.backgroundColor = UIColor.flatNavyBlueColorDark()
        myTableView.separatorStyle = .none
        //        myTableView.layer.opacity = 0.5
        myTableView.rowHeight = 80
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].name
        let color = UIColor.init(hexString: items[indexPath.row].color)
        cell.backgroundColor = color
        if items[indexPath.row].done == 1 {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row].name)
        let user_name = self.database.foo(name: nil)
        guard let user_id = self.database.queryUserID(user_name: user_name) else {fatalError("No user_id provided.")}
        guard let category_name = self.CATEGORY_NAME else {fatalError("Empty navBarTitle.")}
        guard let group_name = self.GROUP_NAME else {fatalError("No group_name")}
        guard let group_id = self.database.queryGroupID(group_name: group_name, user_id: user_id) else {fatalError("No group_id found")}
        guard let category_id = self.database.queryCategoryID(category_name: category_name, group_id: group_id) else {fatalError("No category id found")}
        
        guard let item_id = database.queryItemID(item_name: items[indexPath.row].name, category_id: category_id) else {fatalError("Could not find item id")}
        if items[indexPath.row].done == 1 {
            items[indexPath.row].done = 0
            database.updateItemDone(item_id: item_id, item_done: 0)
        }
        else {
            items[indexPath.row].done = 1
            database.updateItemDone(item_id: item_id, item_done: 1)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField  = UITextField()
        
        let alert = UIAlertController(title: "Add New Appy Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text! != "" {
                
                self.database.createTableItem()
                
                let user_name = self.database.foo(name: nil)
                guard let user_id = self.database.queryUserID(user_name: user_name) else {fatalError("No user_id provided.")}
                guard let category_name = self.CATEGORY_NAME else {fatalError("Empty navBarTitle.")}
                guard let group_name = self.GROUP_NAME else {fatalError("No group_name")}
                guard let group_id = self.database.queryGroupID(group_name: group_name, user_id: user_id) else {fatalError("No group_id found")}
                guard let category_id = self.database.queryCategoryID(category_name: category_name, group_id: group_id) else {fatalError("No category id found")}
                
                let color: String = (UIColor.randomFlat()?.hexValue())!
                self.database.insertItem(item_name: textField.text!, item_color: color, item_done: 0, category_id: category_id)
                self.items.append(Item(name: textField.text!, color: color, done: 0))
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
    
    @IBAction func messagePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToChatFromItem", sender: self)
    }
}

