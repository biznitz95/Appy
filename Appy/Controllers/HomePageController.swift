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
    
    @IBOutlet var myView: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!

    // MVC pattern: Model View Controller. Put the properties in the model and
    // have the model interact with functions. Might also be helpful to lookup
    // LCOM4 (Cohesion Theory)
//    struct Model {
//        var groups: [Group] = []
//        var navBarTitle: String?
//        var navBarColor: String?
//    }
    
    // MARK: - Internal Variables
    
    var groups: [Group] = []
    var navBarTitle: String?
    var navBarColor: String?
    var CATEGORY_NAME: String?
    
    var database = Database()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color
        myView.backgroundColor = UIColor.flatNavyBlueColorDark()
        
        // Load groups if provided a user_id

        let user_name = database.foo(name: nil)
        guard let user_id = database.queryUserID(user_name: user_name) else {fatalError("No user_id provided")}
        
        groups = database.queryGroupGivenUserID(user_id: user_id)
        
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
    
    // Pass name of group to category
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = navBarTitle {
            let destinationVC = segue.destination as! CategoryViewController
            destinationVC.navBarTitle = navBarTitle
            destinationVC.navBarColor = navBarColor
            destinationVC.GROUP_NAME = navBarTitle
            destinationVC.CATEGORY_NAME = CATEGORY_NAME
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

                let user_name = self.database.foo(name: nil)
                guard let user_id = self.database.queryUserID(user_name: user_name) else {fatalError("No user_id found")}
                
                self.database.insertGroup(group_name: textField.text!, user_id: Int32(user_id), user_name: user_name, group_color: color)
                
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
    
}

// MARK: - UITableViewDataSource

extension HomePageController: UITableViewDataSource {
    
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

}

// MARK: - UITableViewDelegate

extension HomePageController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(groups[indexPath.row])
        navBarTitle = groups[indexPath.row].name
        navBarColor = groups[indexPath.row].color
        CATEGORY_NAME = navBarTitle
        
        performSegue(withIdentifier: "goToCategoryFromGroup", sender: self)
    }
    
}
