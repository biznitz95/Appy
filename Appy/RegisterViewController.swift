//
//  RegisterViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/17/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework
import VideoSplashKit
import SQLite

class RegisterViewController: VideoSplashViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordConfirmText: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet var viewToShake: UIView!
    
    var db: OpaquePointer? = nil
    
    let createTableString = """
        CREATE TABLE User(
        user_id                 INTEGER             PRIMARY KEY         AUTOINCREMENT,
        user_name               VARCHAR(255)        NOT NULL,
        user_email              VARCHAR(255)        NOT NULL,
        user_password           VARCHAR(255)        NOT NULL
    );
    """
    
    let insertStatementString = "INSERT INTO User (user_name, user_email, user_password) VALUES (?,?,?);"
    
//    let queryStatementString = "SELECT * FROM User;"
    
//    let updateStatementString = "UPDATE User SET user_name = 'Chris' WHERE user_id = 1;"
    
//    let deleteStatementStirng = "DELETE FROM User WHERE user_id = 1;"
    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        
        guard let part1DbPath = Bundle.main.path(forResource: "Appy", ofType: "sqlite") else {fatalError("Could not find video!")}
        
        if sqlite3_open(String(part1DbPath), &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(String(part1DbPath))")
            return db
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
            return nil
        }
    }
    
    func createTable() {
        // 1
        var createTableStatement: OpaquePointer? = nil
        // 2
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("User table created.")
            } else {
                print("User table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(user_name: String, user_email: String, user_password: String) -> Bool {
        var insertStatement: OpaquePointer? = nil
        var pass = false
        // 1
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
//            let id: Int32 = 1
            let name = user_name as NSString
            let email: NSString = user_email as NSString
            let password: NSString = user_password as NSString
            // 2
//            sqlite3_bind_int(insertStatement, 1, id)
            // 3
            sqlite3_bind_text(insertStatement, 1, name.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, email.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, password.utf8String, -1, nil)
            
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
                pass = true
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
        
        return pass
    }
    
//    func query() {
//        var queryStatement: OpaquePointer? = nil
//        // 1
//        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
//            // 2
//            if sqlite3_step(queryStatement) == SQLITE_ROW {
//                // 3
//                let id = sqlite3_column_int(queryStatement, 0)
//
//                // 4
////                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
////                let name = String(cString: queryResultCol1!)
//                let name = String(cString: sqlite3_column_text(queryStatement, 1)!)
//
//                // 5
//                print("Query Result:")
//                print("\(id) | \(name)")
//
//            } else {
//                print("Query returned no results")
//            }
//        } else {
//            print("SELECT statement could not be prepared")
//        }
//
//        // 6
//        sqlite3_finalize(queryStatement)
//    }
    
//    func update() {
//        var updateStatement: OpaquePointer? = nil
//        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
//            if sqlite3_step(updateStatement) == SQLITE_DONE {
//                print("Successfully updated row.")
//            } else {
//                print("Could not update row.")
//            }
//        } else {
//            print("UPDATE statement could not be prepared")
//        }
//        sqlite3_finalize(updateStatement)
//    }
    
//    func delete() {
//        var deleteStatement: OpaquePointer? = nil
//        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
//            if sqlite3_step(deleteStatement) == SQLITE_DONE {
//                print("Successfully deleted row.")
//            } else {
//                print("Could not delete row.")
//            }
//        } else {
//            print("DELETE statement could not be prepared")
//        }
//
//        sqlite3_finalize(deleteStatement)
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addVideo(videoName: "test2", videoType: "mp4")
        
        modifyCreateButton()
        modifyLoginButton()
        modifyForgotButton()
        
        modifyTextFields()
        
        keyboardDismiss()
    }
    
    @IBAction func pressedRegister(_ sender: UIButton) {
        
        /* Start */
        
        //getting values from textfields
        let userName = usernameText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let userEmail = emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let userPassword = passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let userConfirmPassword = passwordConfirmText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //validating that values are not empty
        if(userEmail?.isEmpty)!{
            emailText.layer.borderColor = UIColor.red.cgColor
            shake()
            return
        }
        else {
            emailText.layer.borderColor = UIColor.flatSkyBlue()?.cgColor
        }
        
        if(userName?.isEmpty)!{
            usernameText.layer.borderColor = UIColor.red.cgColor
            shake()
            return
        }
        else {
            usernameText.layer.borderColor = UIColor.flatSkyBlue()?.cgColor
        }
        
        if(userPassword?.isEmpty)!{
            passwordText.layer.borderColor = UIColor.red.cgColor
            shake()
            return
        }
        else {
            passwordText.layer.borderColor = UIColor.flatSkyBlue()?.cgColor
        }
        
        if(userConfirmPassword?.isEmpty)!{
            passwordConfirmText.layer.borderColor = UIColor.red.cgColor
            shake()
            return
        }
        else {
            passwordConfirmText.layer.borderColor = UIColor.flatSkyBlue()?.cgColor
        }
        
        if(userPassword != userConfirmPassword) {
            passwordText.layer.borderColor = UIColor.red.cgColor
            passwordConfirmText.layer.borderColor = UIColor.red.cgColor
            shake()
            return
        }
        else {
            passwordText.layer.borderColor = UIColor.flatSkyBlue()?.cgColor
            passwordConfirmText.layer.borderColor = UIColor.flatSkyBlue()?.cgColor
        }
        
        db = openDatabase()
        createTable()
        
        if insert(user_name: usernameText.text!, user_email: emailText.text!, user_password: passwordText.text!) {
            performSegue(withIdentifier: "goToHomePageFromRegister", sender: self)
        }
        
    }
    
    @IBAction func pressedLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLoginFromRegister", sender: self)
    }
    
    @IBAction func pressedForgot(_ sender: UIButton) {
        // Possible future implementation
    }
    
    // Add Video Function
    func addVideo(videoName name: String, videoType type: String) -> Void {
        guard let myBundle = Bundle.main.path(forResource: name, ofType: type) else {fatalError("Could not find video!")}
        let url = NSURL.fileURL(withPath: myBundle)
        self.videoFrame = view.frame
        self.fillMode = .resizeAspectFill
        self.alwaysRepeat = true
        self.sound = false
        //        self.startTime = 12.0
        //        self.duration = 4.0
        self.alpha = 0.7
        self.backgroundColor = UIColor.black
        self.contentURL = url
        self.restartForeground = true
    }
    
    // Dismiss Keyboard Function
    func keyboardDismiss() -> Void {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    // Login button modifications
    func modifyLoginButton() -> Void {
        loginButton.layer.cornerRadius = 5
        loginButton.backgroundColor = UIColor.flatSkyBlueColorDark()
    }
    
    func modifyCreateButton() -> Void {
        registerButton.layer.cornerRadius = 5
        registerButton.backgroundColor = UIColor.flatSkyBlueColorDark()
    }
    
    func modifyForgotButton() -> Void {
        forgotButton.layer.cornerRadius = 5
        forgotButton.tintColor = UIColor.flatPowderBlue()
    }
    
    // Textfields modifications
    func modifyTextFields() -> Void {
        var stringTitle = NSMutableAttributedString()
        let emailString = "Email"
        let usernameString  = "Username" // PlaceHolderText
        let passwordString = "Password"
        let passwordConfirmString = "Confirm Password"
        
        stringTitle = NSMutableAttributedString(string:emailString, attributes: [NSAttributedString.Key.font:UIFont(name: "Courier", size: 18.0)!]) // Font
        stringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:emailString.count))    // Color
        emailText.attributedPlaceholder = stringTitle
        
        stringTitle = NSMutableAttributedString(string:usernameString, attributes: [NSAttributedString.Key.font:UIFont(name: "Courier", size: 18.0)!]) // Font
        stringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:usernameString.count))    // Color
        usernameText.attributedPlaceholder = stringTitle
        
        stringTitle = NSMutableAttributedString(string:passwordString, attributes: [NSAttributedString.Key.font:UIFont(name: "Courier", size: 18.0)!]) // Font
        stringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:passwordString.count))    // Color
        passwordText.attributedPlaceholder = stringTitle
        
        stringTitle = NSMutableAttributedString(string:passwordConfirmString, attributes: [NSAttributedString.Key.font:UIFont(name: "Courier", size: 18.0)!]) // Font
        stringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:passwordConfirmString.count))    // Color
        passwordConfirmText.attributedPlaceholder = stringTitle
        
        //
        emailText.layer.cornerRadius = 5
        emailText.backgroundColor = .clear
        emailText.layer.borderWidth = 1
        emailText.layer.borderColor = UIColor.flatSkyBlue()?.cgColor
        
        usernameText.layer.cornerRadius = 5
        usernameText.backgroundColor = .clear
        usernameText.layer.borderWidth = 1
        usernameText.layer.borderColor = UIColor.flatSkyBlue()?.cgColor
        
        passwordText.layer.cornerRadius = 5
        passwordText.backgroundColor = .clear
        passwordText.layer.borderWidth = 1
        passwordText.layer.borderColor = UIColor.flatSkyBlue()?.cgColor
        
        passwordConfirmText.layer.cornerRadius = 5
        passwordConfirmText.backgroundColor = .clear
        passwordConfirmText.layer.borderWidth = 1
        passwordConfirmText.layer.borderColor = UIColor.flatSkyBlue()?.cgColor
        
    }
    
    func shake() -> Void {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 10, y: viewToShake.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 10, y: viewToShake.center.y))
        
        viewToShake.layer.add(animation, forKey: "position")
    }
}

