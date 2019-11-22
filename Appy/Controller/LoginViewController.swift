//
//  ViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/17/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
//import Foundation

final class LoginViewController: UIViewController {
    // MARK: - Private Variables
    var loginView: LoginView {
        guard isViewLoaded,
            let newView = view as? LoginView else { fatalError() }
        return newView
    }
    private var database = Database()
    var textFields: [CustomTextField] {
        return [loginView.usernameText, loginView.passwordText]
    }
    // MARK: Private Constants
    let defaults = UserDefaults.standard
    let segueToRegisterIdentifier = "goToRegister"
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        database.createAllTables()
    }
    // MARK: - IBActions
    @IBAction func pressedLogin(_ sender: UIButton) {
        // Validate fields are not empty
        guard !areTextFieldsEmpty() else { return }
        // TODO: Check if user is valid
    }
    @IBAction func pressedRegister(_ sender: UIButton) {
        performSegue(withIdentifier: segueToRegisterIdentifier, sender: self)
    }
    @IBAction func pressedForgot(_ sender: UIButton) { }
    // MARK: - Text Field Checks
    func areTextFieldsEmpty() -> Bool {
        for textField in textFields {
            guard let text = textField.text,
                !text.isEmpty else { return true }
        }
        return false
    }
}

