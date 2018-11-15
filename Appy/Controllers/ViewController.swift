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
    
    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var usernameText: UITextField!
    @IBOutlet private weak var passwordText: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var forgotButton: UIButton!
    @IBOutlet private var viewToShake: UIView!
    
    // MARK: - Private Variables
    
    private enum Constants {
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 1
        static let backgroundColor = UIColor.clear
    }
    
    private var database = Database()
    
    let defaults = UserDefaults.standard
    
    private var textFields: [UITextField] {
        return [usernameText, passwordText]
    }
    
    private var buttons: [UIButton] {
        return [loginButton, registerButton, forgotButton]
    }
    
    // Colors
    private var skyBlueColor: CGColor { return UIColor.flatSkyBlue()!.cgColor }
    private var skyBlueDarkColor: UIColor { return UIColor.flatSkyBlueColorDark() }
    private var powderBlueColor: UIColor { return UIColor.flatPowderBlue() }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create all tables needed 
        database.createAllTables()
        
        // Change background color
        viewToShake.backgroundColor = UIColor.flatNavyBlueColorDark()
        
        // Modify buttons
        modifyButtons()
        
        // Modify textfields
        modifyTextFields()
        
        // Make keyboard go away if tapped anywhere
        viewToShake.keyboardDismiss()
    }

    // MARK: - Actions
    
    @IBAction func pressedLogin(_ sender: UIButton) {
        
        // Validate fields are not empty
        for field in textFields {
            guard !field.text!.isEmpty else {
                field.layer.borderColor = UIColor.red.cgColor
                field.shake()
                return
            }
            field.layer.borderColor = skyBlueColor
        }
        
        // Validate info to login
        if database.queryUser(user_name: usernameText.text!, user_password: passwordText.text!) {
            
            let user_id = database.queryUserID(user_name: usernameText.text!)
            let user_password = passwordText.text!
            
            defaults.set(usernameText.text!, forKey: "user_name")
            defaults.set(user_id, forKey: "user_id")
            defaults.set(user_password, forKey: "user_password")
            
            performSegue(withIdentifier: "goToHomePageFromLogin", sender: self)
        }
        else {
            usernameText.layer.borderColor = UIColor.flatRed()?.cgColor
            usernameText.shake()
            passwordText.layer.borderColor = UIColor.flatRed()?.cgColor
            passwordText.shake()
        }
    }
    
    @IBAction func pressedRegister(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    @IBAction func pressedForgot(_ sender: UIButton) { }
    
    // MARK: - Private Methods
    
    // Modify textfields style
    private func modifyTextFields() -> Void {
        usernameText.modifyTextField(
            radius: Constants.cornerRadius,
            width: Constants.borderWidth,
            color: skyBlueColor
        )
        
        passwordText.modifyTextField(
            radius: Constants.cornerRadius,
            width: Constants.borderWidth,
            color: skyBlueColor
        )
    }

    // Button Modifications
    private func modifyButtons() {
        // Modify button for Login
        loginButton.modifyButton(radius: Constants.cornerRadius, color: skyBlueDarkColor)
        
        // Modify button for Register
        registerButton.modifyButton(radius: Constants.cornerRadius, color: skyBlueDarkColor)
        
        // Modify forgot button
        forgotButton.modifyButtonTint(radius: Constants.cornerRadius, color: powderBlueColor)
    }
    
}

