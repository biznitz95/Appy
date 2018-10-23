//
//  ViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/17/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework
import VideoSplashKit
import SQLite3

class ViewController: VideoSplashViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    
    // Databse for Appy
    var db: OpaquePointer?
    let queryStatementString = "SELECT * FROM User;"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Modify button for Login
        modifyLoginButton()
        
        // Modify button for Register
        modifyCreateButton()
        
        // Modify forgot button
        modifyForgotButton()
        
        // Modify textfields
        modifyTextFields()
        
        // Add backgroudn video
        addVideo(videoName: "test", videoType: "mp4")
        
        // Make keyboard go away if tapped anywhere
        keyboardDismiss()
        
    }

    // User pressed Login
    @IBAction func pressedLogin(_ sender: UIButton) {
        db = openDatabase()
        
        if (usernameText.text) == "" || (passwordText.text) == "" {
            usernameText.layer.borderColor = UIColor.flatRed()?.cgColor
            passwordText.layer.borderColor = UIColor.flatRed()?.cgColor
            return
        }
        
        if query(user_name: usernameText.text!, user_password: passwordText.text!) {
            performSegue(withIdentifier: "goToHomePageFromLogin", sender: self)
        }
        else {
            usernameText.layer.borderColor = UIColor.flatRed()?.cgColor
            passwordText.layer.borderColor = UIColor.flatRed()?.cgColor
        }
    }
    
    // User pressed Register
    @IBAction func pressedRegister(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    @IBAction func pressedForgot(_ sender: UIButton) {
        // Possible future feature
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
        let usernameString  = "Username" // PlaceHolderText
        let passwordString = "Password"
        
        stringTitle = NSMutableAttributedString(string:usernameString, attributes: [NSAttributedString.Key.font:UIFont(name: "Courier", size: 18.0)!]) // Font
        stringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:usernameString.count))    // Color
        usernameText.attributedPlaceholder = stringTitle
        
        stringTitle = NSMutableAttributedString(string:passwordString, attributes: [NSAttributedString.Key.font:UIFont(name: "Courier", size: 18.0)!]) // Font
        stringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:NSRange(location:0,length:usernameString.count))    // Color
        passwordText.attributedPlaceholder = stringTitle
        //
        
        passwordText.layer.cornerRadius = 5
        passwordText.backgroundColor = .clear
        passwordText.layer.borderWidth = 1
        passwordText.layer.borderColor = UIColor.flatSkyBlue()?.cgColor
        
        usernameText.layer.cornerRadius = 5
        usernameText.backgroundColor = .clear
        usernameText.layer.borderWidth = 1
        usernameText.layer.borderColor = UIColor.flatSkyBlue()?.cgColor
    }
    
    // Dismiss Keyboard Function
    func keyboardDismiss() -> Void {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    // Sqlite3 Functions
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        #warning("Must modify line below for computer to find your own path")
        let part1DbPath = "/Users/bizetrodriguez/Desktop/Appy/Databases/Appy.sqlite"
        
        if sqlite3_open(part1DbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(part1DbPath)")
            return db
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
            return nil
        }
    }

    func query(user_name: String, user_password: String) -> Bool {
        var pass = false
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol1!)
                let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
                let password = String(cString: queryResultCol3!)
                print("Query Result:")
                if (user_name == name) && (user_password == password) {
                    pass = true
                }
            }
            
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return pass
    }
}

