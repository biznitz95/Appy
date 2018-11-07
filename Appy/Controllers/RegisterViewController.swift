//
//  RegisterViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/17/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework

final class RegisterViewController: UIViewController {

    private enum Constants {
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 1
    }
    
    // MARK: - Private Outlets
    
    @IBOutlet private weak var emailText: UITextField!
    @IBOutlet private weak var usernameText: UITextField!
    @IBOutlet private weak var passwordText: UITextField!
    @IBOutlet private weak var passwordConfirmText: UITextField!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var forgotButton: UIButton!
    @IBOutlet private var viewToShake: UIView!
    
    // MARK: - Private Variables
    
    private var database = Database()
    
    // Computed properties are dope, just references as specified.
    private var textFields: [UITextField] {
        return [emailText, usernameText, passwordText, passwordConfirmText]
    }
    
    // Store user defaults here like name, id, etc...
    private let defaults = UserDefaults.standard
    
    private var skyBlueColor: CGColor { return UIColor.flatSkyBlue()!.cgColor }
    private var skyBlueDarkColor: UIColor { return UIColor.flatSkyBlueColorDark() }
    private var powderBlueColor: UIColor { return UIColor.flatPowderBlue() }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color
        viewToShake.backgroundColor = UIColor.flatNavyBlueColorDark()
        
        database.createAllTables()
        
        configureButtons()
        
        configureTextFields()
        
        viewToShake.keyboardDismiss()
    }
    
    // MARK: - Actions
    
    @IBAction func pressedRegister(_ sender: UIButton) {
        // Validate fields are not empty.
        for field in textFields {
            guard !field.text!.isEmpty else {
                field.layer.borderColor = UIColor.red.cgColor
                field.shake()
                return
            }
            field.layer.borderColor = skyBlueColor
        }
        
        // Validate passwords match.
        let userPassword = passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let userConfirmPassword = passwordConfirmText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard userPassword == userConfirmPassword else {
            passwordText.layer.borderColor = UIColor.red.cgColor
            passwordText.shake()
            passwordConfirmText.layer.borderColor = UIColor.red.cgColor
            passwordConfirmText.shake()
            return
        }
        
        // Restores border colors.
        passwordText.layer.borderColor = skyBlueColor
        passwordConfirmText.layer.borderColor = skyBlueColor
        
        // Database should have a method that takes the same parameters and acts
        // as a proxy to the insertUser combined with createTableUser.
        if database.insertUser(user_name: usernameText.text!, user_email: emailText.text!, user_password: passwordText.text!) {
            
            let user_id = database.queryUserID(user_name: usernameText.text!)
            
            defaults.set(usernameText.text!, forKey: "user_name")
            defaults.set(user_id, forKey: "user_id")
            
            performSegue(withIdentifier: "goToHomePageFromRegister", sender: self)
        }
        
    }
    
    @IBAction func pressedLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLoginFromRegister", sender: self)
    }
    
    @IBAction func pressedForgot(_ sender: UIButton) { }
    
    // MARK: - Private Methods
    
    private func configureButtons() {
        loginButton.modifyButton(radius: Constants.cornerRadius, color: skyBlueDarkColor)
        
        registerButton.modifyButton(radius: Constants.cornerRadius, color: skyBlueDarkColor)

        forgotButton.modifyButtonTint(radius: Constants.cornerRadius, color: powderBlueColor)
    }
    
    // Textfields modifications
    private func configureTextFields() {
        
        for textField in textFields {
            textField.modifyTextField(
                radius: Constants.cornerRadius,
                width: Constants.borderWidth,
                color: skyBlueColor
            )
        }
        
    }

}

