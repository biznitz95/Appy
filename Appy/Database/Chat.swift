//
//  Chat.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/3/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import Foundation

class Chat {
    
    var chat_name: String
    var user_id: Int32
    var category_id: Int32
    var group_id: Int32
    
    init(chat_name: String, user_id: Int32, category_id: Int32, group_id: Int32) {
        self.chat_name = chat_name
        self.user_id = user_id
        self.category_id = category_id
        self.group_id = group_id
    }
}
