//
//  UITableViewCell+Style.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/13/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework

extension UITableViewCell {
    
    func modifyTableViewCellStyle(name: String, color: String) {
        self.textLabel?.text = name
        let color = UIColor.init(hexString: color)
        self.backgroundColor = color
        self.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        self.selectionStyle = .none
    }
}
