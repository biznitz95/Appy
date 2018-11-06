//
//  RegisterViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/17/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordConfirmText: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet var viewToShake: UIView!
    
    var database = Database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change background color
        viewToShake.backgroundColor = UIColor.flatNavyBlueColorDark()
        
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
        
        database.createTableUser()
        
        if database.insertUser(user_name: usernameText.text!, user_email: emailText.text!, user_password: passwordText.text!) {
            database.foo(name: usernameText.text!)
            performSegue(withIdentifier: "goToHomePageFromRegister", sender: self)
        }
        
    }
    
    @IBAction func pressedLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLoginFromRegister", sender: self)
    }
    
    @IBAction func pressedForgot(_ sender: UIButton) {
        // Possible future implementation
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

