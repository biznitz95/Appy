//
//  UIButton+Style.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/7/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework

extension UIButton {
    func modifyButton(radius: CGFloat, color: UIColor) {
        self.layer.cornerRadius = radius
        self.backgroundColor = color
    }
    
    func modifyButtonTint(radius: CGFloat, color: UIColor) {
        self.layer.cornerRadius = radius
        self.tintColor = color
    }
}
