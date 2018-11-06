//
//  User.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/5/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import Foundation

class User {
    var id: Int32?
    var name: String?
    var email: String?
    var password: String?
    
    init(id: Int32, name: String, email: String, password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
    
    
}
