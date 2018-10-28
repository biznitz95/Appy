//
//  Item.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/27/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import Foundation

class Item {
    var name: String
    var color: String
    var done: Bool
    
    init(name: String, color: String, done: Bool = false) {
        self.name = name
        self.color = color
        self.done = done
    }
}
