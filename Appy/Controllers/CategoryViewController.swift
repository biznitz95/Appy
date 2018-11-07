//
//  CategoryViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/27/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var myView: UIView!
    @IBOutlet weak var myTableView: UITableView!
    
    var categories: [Category] = []
    
    var navBarTitle: String?
    var navBarColor: String?
    var GROUP_NAME: String?
    var CATEGORY_NAME: String?
    
    // Create instance of Appy database
    var database = Database()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        let color = UIColor.init(hexString: categories[indexPath.row].color)
        cell.backgroundColor = color
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(categories[indexPath.row])
        navBarColor = categories[indexPath.row].color
        CATEGORY_NAME = categories[indexPath.row].name
        performSegue(withIdentifier: "goToItemFromCategory", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color
        myView.backgroundColor = UIColor.flatNavyBlueColorDark()

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
        guard let barTitle = navBarTitle else {fatalError("Empty navBarTitle.")}
        guard let group_id = database.queryGroupID(group_name: barTitle, user_id: user_id) else {fatalError("No group_id found")}
        
        categories = database.queryCategoryGiveGroupID(group_id: group_id)
        
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        myTableView.backgroundColor = UIColor.flatNavyBlueColorDark()
        myTableView.separatorStyle = .none
        //        myTableView.layer.opacity = 0.5
        myTableView.rowHeight = 80
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
                
                let user_name = self.database.foo(name: nil)
                guard let user_id = self.database.queryUserID(user_name: user_name) else {fatalError("No user_id provided.")}
                guard let barTitle = self.navBarTitle else {fatalError("Empty navBarTitle.")}
                guard let group_id = self.database.queryGroupID(group_name: barTitle, user_id: Int32(user_id)) else {fatalError("No group_id provided")}
                
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
    
    
    // Pass name of group to items
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = navBarTitle {
            let destinationVC = segue.destination as! ItemViewController
            destinationVC.navBarTitle = navBarTitle
            destinationVC.navBarColor = navBarColor
            destinationVC.CATEGORY_NAME = CATEGORY_NAME
            destinationVC.GROUP_NAME = GROUP_NAME
        }
    }
    
}

