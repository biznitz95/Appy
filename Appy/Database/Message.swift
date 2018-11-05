//
//  Message.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/3/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import Foundation

class Message {
    var name: String?
    var user_id: Int32?
    var chat_id: Int32?
    var message_time: Date?
    
    init(name: String, user_id: Int32, chat_id: Int32, message_time: Date) {
        self.name = name
        self.user_id = user_id
        self.chat_id = chat_id
        self.message_time = message_time
    }
}
