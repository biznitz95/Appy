//
//  Permission.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/23/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import Foundation

class Permission {
    var main_user_id: Int32?
    var user_id: Int32?
    var group_id: Int32?
    var category_id: Int32?
    var chat_id: Int32?
    
    init (main_user_id: Int32, user_id: Int32, group_id: Int32, category_id: Int32, chat_id: Int32) {
        self.main_user_id = main_user_id
        self.user_id = user_id
        self.group_id = group_id
        self.category_id = category_id
        self.chat_id = chat_id
    }
    
    func setGroupId(group_id: Int32) {
        self.group_id = group_id
    }
}
