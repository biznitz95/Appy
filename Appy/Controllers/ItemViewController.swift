//
//  ItemViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/27/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework
import SQLite
import Lottie

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var myView: UIView!
    @IBOutlet var myTableView: UITableView!
    @IBOutlet var animationView: LOTAnimationView!
    
    var navBarTitle: String?
    var navBarColor: String?
    
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
        
        items = database.queryItem()
        
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row])
//        navBarTitle = items[indexPath.row].name
//        navBarColor = items[indexPath.row].color
//        performSegue(withIdentifier: "goToItemFromCategory", sender: self)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField  = UITextField()
        
        let alert = UIAlertController(title: "Add New Appy Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text! != "" {
                
                self.database.createTableItem()
                
                let color: String = (UIColor.randomFlat()?.hexValue())!
//                self.database.insertCategory(category_name: textField.text!, category_color: color, group_id: 0)
                self.database.insertItem(item_name: textField.text!, item_color: color, item_done: 0, category_id: 0)
//                self.categories.append(Category(name: textField.text!, color: color))
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

