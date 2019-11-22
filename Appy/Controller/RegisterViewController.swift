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
    // MARK: - Private Variables
    private var database = Database()
    private var registerView: RegisterView {
        guard isViewLoaded,
            let newView = view as? RegisterView else { fatalError() }
        return newView
    }
    private var textFields: [CustomTextField] {
        return [registerView.emailText,
                registerView.usernameText,
                registerView.passwordText,
                registerView.passwordConfirmText]
    }
    // Store user defaults here like name, id, etc...
    private let defaults = UserDefaults.standard
    private let segueToLoginIdentifier = "goToLoginFromRegister"
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        database.createAllTables()
    }
    // MARK: - Actions
    @IBAction func pressedRegister(_ sender: UIButton) {
        guard !areTextFieldsEmpty(),            // Validate fields are not empty.
            doPasswordsMatch() else { return }  // Validate passwords match.
        // TODO: Create User Insertion Function
    }
    
    @IBAction func pressedLogin(_ sender: UIButton) {
        performSegue(withIdentifier: segueToLoginIdentifier, sender: self)
    }
    @IBAction func pressedForgot(_ sender: UIButton) { }
    // MARK: - Private Methods
    func areTextFieldsEmpty() -> Bool {
        for textField in textFields {
            guard let text = textField.text,
                !text.isEmpty else { return true }
        }
        return false
    }
    func doPasswordsMatch() -> Bool {
        guard let password = registerView.passwordText.text,
            let confirmPassword = registerView.passwordConfirmText.text,
            password == confirmPassword else { return false }
        return true
    }
}

