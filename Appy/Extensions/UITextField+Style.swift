//
//  UITextField+Style.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/7/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework

extension UITextField {
    func modifyTextField(radius: CGFloat, width: CGFloat, color: CGColor) {
        self.backgroundColor = .clear
        self.layer.styleBorder(cornerRadius: radius, width: width, color: color)
        guard let string = self.placeholder else {fatalError("No placeholder text found")}
        self.attributedPlaceholder = NSMutableAttributedString(textStyled: string)
    }
}
