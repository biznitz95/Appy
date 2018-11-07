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
        
        // Load groups if provided a user_id
        let user_id = Int32(defaults.integer(forKey: "user_id"))
        
        groups = database.queryGroupGivenUserID(user_id: user_id)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font :UIFont(name: "Courier", size: 24.0)!]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.flatSkyBlue()]

        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.backgroundColor = UIColor.flatNavyBlueColorDark()
        myTableView.separatorStyle = .none
        //        myTableView.layer.opacity = 0.5
        myTableView.rowHeight = 80
        myTableView.dataSource = self
        myTableView.delegate = self
        
        self.view.addSubview(myTableView)
        
        
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
}

// MARK: - UITableViewDataSource

extension HomePageController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = groups[indexPath.row].name
        let color = UIColor.init(hexString: groups[indexPath.row].color)
        cell.backgroundColor = color
        cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        cell.selectionStyle = .none
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
        
        let user_id = Int32(defaults.integer(forKey: "user_id"))
        let group_name = groups[indexPath.row].name
        guard let group_id = database.queryGroupID(group_name: group_name, user_id: user_id) else {fatalError("No group_id found")}
        
        defaults.set(groups[indexPath.row].name, forKey: "group_name")
        defaults.set(groups[indexPath.row].color, forKey: "group_color")
        defaults.set(group_id, forKey: "group_id")
        
        performSegue(withIdentifier: "goToCategoryFromGroup", sender: self)
    }
    
}

