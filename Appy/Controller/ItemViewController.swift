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

class ItemViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var myView: UIView!
    @IBOutlet private var myTableView: UITableView!
    @IBOutlet private var animationView: LOTAnimationView!
    
    // MARK: - Private Intern Variables
    
    var items = [Item]()
    var database = Database()
    var timer = Timer()
    
    let defaults = UserDefaults.standard
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color
        myView.backgroundColor = UIColor.flatNavyBlueColorDark()
        
        myView.keyboardDismiss()
        
        // Animation set
        animationView.playAnimation(image: "message")
        
        // Change nav bar title
        if let title = defaults.string(forKey: "category_name") {
            self.navigationItem.title = title + " Items"
        }
        
        let user_id = Int32(defaults.integer(forKey: "user_id"))
        let category_id = Int32(defaults.integer(forKey: "category_id"))
        let group_id = Int32(defaults.integer(forKey: "group_id"))
        
        items = database.queryItemGivenCategoryID(category_id: category_id, user_id: user_id, group_id: group_id)
        
        myTableView.modifyTableViewStyle(forCell: "ItemCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
        
        scheduledTimerWithTimeInterval()
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update(){
        // Get chat_id and find messages with that chat_id
        let user_id = Int32(defaults.integer(forKey: "user_id"))
        let group_id = Int32(defaults.integer(forKey: "group_id"))
        let category_id = Int32(defaults.integer(forKey: "category_id"))
        items = database.queryItemGivenCategoryID(category_id: category_id, user_id: user_id, group_id: group_id)
        myTableView.reloadData()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField  = UITextField()
        
        let alert = UIAlertController(title: "Add New Appy Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text! != "" {
                
                self.database.createTableItem()
                
                let category_id = Int32(self.defaults.integer(forKey: "category_id"))
                
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
        guard let chat_name = defaults.string(forKey: "category_name") else {fatalError("Failed to get category_name for chat_name")}
        
        let user_id = Int32(defaults.integer(forKey: "user_id"))
        let category_id = Int32(defaults.integer(forKey: "category_id"))
        let group_id = Int32(defaults.integer(forKey: "group_id"))
        
        if let chat_id = database.queryCheckForChat(user_id: user_id, group_id: group_id, category_id: category_id) {
            defaults.set(chat_name, forKey: "chat_name")
            defaults.set(chat_id, forKey: "chat_id")
        }
        else {
            database.insertChat(chat_name: chat_name, user_id: user_id, category_id: category_id, group_id: group_id)
            let chat_id = database.queryChatID(chat_name: chat_name, user_id: user_id, group_id: group_id, category_id: category_id)
            defaults.set(chat_name, forKey: "chat_name")
            defaults.set(chat_id, forKey: "chat_id")
        }
          
        performSegue(withIdentifier: "goToChatFromItem", sender: self)
    }
}

// MARK: - UITableViewDelegate

extension ItemViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let category_id = Int32(self.defaults.integer(forKey: "category_id"))
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let item_name = items[indexPath.row].name
            let category_id = Int32(defaults.integer(forKey: "category_id"))
            guard let item_id = database.queryItemID(item_name: item_name, category_id: category_id) else {fatalError("Failed to get item_id")}
            
            database.deleteItem(item_id: item_id)
            
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDataSource

extension ItemViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].name
        let color = UIColor.init(hexString: items[indexPath.row].color)
        cell.backgroundColor = color
        cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        cell.selectionStyle = .none
        if items[indexPath.row].done == 1 {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
}
