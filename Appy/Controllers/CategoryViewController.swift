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
    
    // Create instance of Appy database
    var database = Database()
    
    let defaults = UserDefaults.standard
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        let color = UIColor.init(hexString: categories[indexPath.row].color)
        cell.backgroundColor = color
        cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(categories[indexPath.row])
        
        // get category name, color and id
        let group_id = Int32(defaults.integer(forKey: "group_id"))
        let category_name = categories[indexPath.row].name
        let category_color = categories[indexPath.row].color
        guard let category_id = database.queryCategoryID(category_name: category_name, group_id: group_id) else {fatalError("Could not get category_id from database")}
        
        // get category name, color and id to defaults
        defaults.set(category_name, forKey: "category_name")
        defaults.set(category_color, forKey: "category_color")
        defaults.set(category_id, forKey: "category_id")
        
        performSegue(withIdentifier: "goToItemFromCategory", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color
        myView.backgroundColor = UIColor.flatNavyBlueColorDark()

        // Change nav bar title
        guard let title = defaults.string(forKey: "group_name") else {fatalError("Failed to retrieve group_name")}
        navigationItem.title = title
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        let group_id = Int32(defaults.integer(forKey: "group_id"))
        
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

