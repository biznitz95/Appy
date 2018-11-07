//
//  RegisterViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/17/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework

// final declaration: tells the compiler that this won't be subclassed and helps
// because it doesn't need to look further when methods are called.
final class RegisterViewController: UIViewController {
    
    private enum Constants {
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 1
    }
    
    // Use mark to create markers in code that can be quickly referenced in the
    // method menu.
    
    // MARK: - Private Outlets
    
    // Access control: usually best to make things private and then open them
    // up to internal or public as needed. Helps prevent granting access outside
    // of the scope.
    
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
    
    // Force casting is good here because it is a developer error that can be
    // caught if it ever fails.
    private var skyBlueColor: CGColor { return UIColor.flatSkyBlue()!.cgColor }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color
        viewToShake.backgroundColor = UIColor.flatNavyBlueColorDark()
        
        configureButtons()
        configureTextFields()
        dismissKeyboard()
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
        database.createTableUser()
        if database.insertUser(user_name: usernameText.text!, user_email: emailText.text!, user_password: passwordText.text!) {
            database.foo(name: usernameText.text!)
            performSegue(withIdentifier: "goToHomePageFromRegister", sender: self)
        }
        
    }
    
    @IBAction func pressedLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLoginFromRegister", sender: self)
    }
    
    // TODO: Add connection to forgot page.
    @IBAction func pressedForgot(_ sender: UIButton) { }
    
    // MARK: - Private Methods
    
    private func configureButtons() {
        loginButton.layer.cornerRadius = 5
        // Inference: The login button's attribute is taking a UIColor, so it
        // can infer that it will only accept UIColor types.
        loginButton.backgroundColor = .flatSkyBlueColorDark()
        
        registerButton.layer.cornerRadius = 5
        registerButton.backgroundColor = .flatSkyBlueColorDark()
        
        forgotButton.layer.cornerRadius = 5
        forgotButton.tintColor = .flatPowderBlue()
    }
    
    // Textfields modifications
    private func configureTextFields() {
        // Looks like a lot of repeated code: perhaps we can do something about
        // that...
        emailText.attributedPlaceholder = NSMutableAttributedString(textStyled: "Email")
        usernameText.attributedPlaceholder = NSMutableAttributedString(textStyled: "Username")
        passwordText.attributedPlaceholder = NSMutableAttributedString(textStyled: "Password")
        passwordConfirmText.attributedPlaceholder = NSMutableAttributedString(textStyled: "Confirm Password")
        
        for textField in textFields {
            textField.backgroundColor = .clear
            textField.layer.styleBorder(cornerRadius: Constants.cornerRadius,
                                        width: Constants.borderWidth,
                                        color: skyBlueColor)
        }
    }
    
    private func dismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
}
