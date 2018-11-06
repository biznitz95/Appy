//
//  HomePageController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/17/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework

class HomePageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var myView: UIView!
    @IBOutlet weak var myTableView: UITableView!
    
    var groups: [Group] = []
    var navBarTitle: String?
    var navBarColor: String?
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var database = Database()

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = groups[indexPath.row].name
        let color = UIColor.init(hexString: groups[indexPath.row].color)
        cell.backgroundColor = color
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(groups[indexPath.row])
        navBarTitle = groups[indexPath.row].name
        navBarColor = groups[indexPath.row].color
        
        performSegue(withIdentifier: "goToCategoryFromGroup", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color
        myView.backgroundColor = UIColor.flatNavyBlueColorDark()
        
        // Load groups if provided a user_id

        let user_name = database.foo(name: nil)
        let user_id = database.queryUserID(user_name: user_name)
        
        groups = database.queryGroupGivenUserID(user_id: user_id!)
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.backgroundColor = UIColor.flatNavyBlueColorDark()
        myTableView.separatorStyle = .none
//        myTableView.layer.opacity = 0.5
        myTableView.rowHeight = 80
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField  = UITextField()
        
        let alert = UIAlertController(title: "Add New Appy Group", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text! != "" {
                
                let color: String = (UIColor.randomFlat()?.hexValue())!

                let user_name = self.database.foo(name: nil)
                let user_id = self.database.queryUserID(user_name: user_name)
                
                self.database.createTableGroup()
                self.database.insertGroup(group_name: textField.text!, user_id: Int32(user_id!), user_name: user_name, group_color: color)
                
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
    
    // Pass name of group to category
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = navBarTitle {
            let destinationVC = segue.destination as! CategoryViewController
            destinationVC.navBarTitle = navBarTitle
            destinationVC.navBarColor = navBarColor
        }
    }
    
}

