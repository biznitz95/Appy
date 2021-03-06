//
//  ChatViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/4/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework
import Lottie
import JGProgressHUD

class ChatViewController: UIViewController {

    // MARK: - Internal Variables
    
    private var messages = [Message]()
    private var chat: Chat?
    private var database = Database()
    private let defaults = UserDefaults.standard
    private var keyboardHeight = CGFloat(0)
    private var timer = Timer()
    
    // MARK: - Outlets
    
    @IBOutlet private var myView: UIView!
    @IBOutlet private var myTableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var bottomHeight: NSLayoutConstraint!
    @IBOutlet var messageView: UIView!
    
    
    
    // MARK: - App Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color
        myView.backgroundColor = UIColor.flatNavyBlueColorDark()
        
        // Get color for each message
        guard let color = UIColor.flatSkyBlue()?.cgColor else {fatalError("Failed to get color")}
        messageTextField.modifyTextField(radius: 5, width: 1, color: color)
        
        // Modify sendButton
        sendButton.modifyButton(radius: 5, color: UIColor.flatSkyBlueColorDark())
        
        // Modify TableView
        myTableView.modifyTableViewStyle(forCell: "MessageCell", rowHeight: 60)
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
        
        // Get chat_id and find messages with that chat_id to load onto tableView
        update()
        
        // Set the title for the chat based off the category name
        setTitle()
        
        // Allow keyboard to go away when user taps outside keyboard
        myView.keyboardDismiss()
        
        messageTextField.delegate = self
        
        scheduledTimerWithTimeInterval()
        
        }
    
    // MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField  = UITextField()
        
        let alert = UIAlertController(title: "Add New Member to the chat and category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text! != "" {
                let user_name = self.defaults.string(forKey: "user_name")
                let main_user_id = Int32(self.defaults.integer(forKey: "user_id"))
                guard let user_id = self.database.queryUserID(user_name: textField.text!) else {
                    showError(view: self.view, textLabel: "Could not find user: \(textField.text!)")
                    return
                }
                let category_id = Int32(self.defaults.integer(forKey: "category_id"))
                let chat_id = Int32(self.defaults.integer(forKey: "chat_id"))
                
                if user_name! == textField.text! {
                    showError(view: self.view, textLabel: "Can't add yourself.")
                }
                else if !self.database.checkForAlreadyExistingUserInPermission(main_user_id: main_user_id, user_id: user_id, category_id: category_id, chat_id: chat_id) {
                    self.database.insertIntoPermission(main_user_id: main_user_id, user_id: user_id, category_id: category_id, chat_id: chat_id)
                    showCheck(view: self.view, textLabel: "Sent request to: \(textField.text!)")
                }
                else {
                    showError(view: self.view, textLabel: "User request already sent.")
                }
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
            field.placeholder = "Add New Member"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        let context = messageTextField.text!
        let user_id = Int32(defaults.integer(forKey: "user_id"))
        let chat_id = Int32(defaults.integer(forKey: "chat_id"))
        let message_time = NSDate().timeIntervalSince1970
        
        messages.append(Message(name: context, user_id: user_id, chat_id: chat_id, message_time: Date(timeIntervalSince1970: message_time)))
        database.insertMessage(message_name: context, user_id: user_id, chat_id: chat_id, message_time: message_time)
        
        messageTextField.text = ""
        
        myTableView.reloadData()
    }
    
    // MARK: - Private Functions
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update(){
        // Get chat_id and find messages with that chat_id
        let user_id = Int32(defaults.integer(forKey: "user_id"))
        let group_id = Int32(defaults.integer(forKey: "group_id"))
        let category_id = Int32(defaults.integer(forKey: "category_id"))
        let chat_id = Int32(defaults.integer(forKey: "chat_id"))
        messages = database.queryMessagesGivenIDS(chat_id: chat_id, user_id: user_id, group_id: group_id, category_id: category_id)
        myTableView.reloadData()
        
    }
    
    func setTitle() {
        if let title = defaults.string(forKey: "chat_name") {
            self.navigationItem.title = title + " Chat"
        }
        else {
            showError(view: view)
        }
    }
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let user_id = Int32(defaults.integer(forKey: "user_id"))
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        
        cell.textLabel?.text = message.name
        cell.layer.cornerRadius = 20

        if message.user_id == user_id {
            cell.textLabel?.textAlignment = .right
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
            cell.backgroundColor = UIColor.flatBlueColorDark()
            cell.textLabel?.textColor = .white
        }
        else {
            cell.textLabel?.textAlignment = .left
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
            cell.backgroundColor = UIColor.flatPowderBlue()
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let message_name = messages[indexPath.row].name else {fatalError("Could not delete the message")}
            let user_id = Int32(defaults.integer(forKey: "user_id"))
            let chat_id = Int32(defaults.integer(forKey: "chat_id"))
            
            guard let message_id = database.queryMessageID(message_name: message_name, user_id: user_id, chat_id: chat_id) else {fatalError("Could not get message_id")}
            
            database.deleteMessage(message_id: Int32(message_id))
            
            self.messages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {

}

// MARK: - UITextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.messageView.translatesAutoresizingMaskIntoConstraints = false
            self.messageView.centerYAnchor.constraint(equalToSystemSpacingBelow: self.view.centerYAnchor, multiplier: 0)
            print(self.keyboardHeight)
        
            self.self.messageTextField.becomeFirstResponder()
        
            self.keyboardHeight = CGFloat(self.defaults.float(forKey: "keyboardHeight"))
        
            UIView.animate(withDuration: 0.2) {
                self.bottomHeight.constant = self.keyboardHeight
            }
        
        
            print("Editing had begun!")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        UIView.animate(withDuration: 0.2) {
            self.bottomHeight.constant = 0.0
        }
        
    }
}
