//
//  ChatViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/4/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework
import SQLite
import Lottie

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var messages = [Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        
        cell.textLabel?.text = messages[indexPath.row].name
        
        return cell
    }
    
}
