//
//  RegisterView.swift
//  Appy
//
//  Created by Bizet Rodriguez-Velez on 11/21/19.
//  Copyright © 2019 Bizet Rodriguez. All rights reserved.
//

import UIKit

class RegisterView: UIView {
    @IBOutlet weak var emailText: CustomTextField!
    @IBOutlet weak var usernameText: CustomTextField!
    @IBOutlet weak var passwordText: CustomTextField!
    @IBOutlet weak var passwordConfirmText: CustomTextField!
    @IBOutlet weak var registerButton: RoundCornersButton!
    @IBOutlet weak var loginButton: RoundCornersButton!
    @IBOutlet weak var forgotButton: UIButton!
}
