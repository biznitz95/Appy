//
//  ViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/17/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework

class ViewController: UIViewController {
    
    // Connections to controller
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet var viewToShake: UIView!
    
    // Databse for Appy
    var database = Database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color
        viewToShake.backgroundColor = UIColor.flatNavyBlueColorDark()
        
        
        // Modify button for Login
        modifyLoginButton()
        
        // Modify button for Register
        modifyCreateButton()
        
        // Modify forgot button
        modifyForgotButton()
        
        // Modify textfields
        modifyTextFields()
        
        // Make keyboard go away if tapped anywhere
        keyboardDismiss(view: viewToShake)
        
    }

    // User pressed Login
    @IBAction func pressedLogin(_ sender: UIButton) {
        
        if (usernameText.text) == "" || (passwordText.text) == "" {
            usernameText.layer.borderColor = UIColor.flatRed()?.cgColor
            passwordText.layer.borderColor = UIColor.flatRed()?.cgColor
            
            shake(viewToShake: viewToShake)
            
            return
        }
        
        // Validate info to login
        if database.queryUser(user_name: usernameText.text!, user_password: passwordText.text!) {
            database.foo(name: usernameText.text!)
            performSegue(withIdentifier: "goToHomePageFromLogin", sender: self)
        }
        else {
            usernameText.layer.borderColor = UIColor.flatRed()?.cgColor
            passwordText.layer.borderColor = UIColor.flatRed()?.cgColor
            shake(viewToShake: viewToShake)
        }
    }
    
    // User pressed Register
    @IBAction func pressedRegister(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    @IBAction func pressedForgot(_ sender: UIButton) {
        // Possible future feature
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

}

