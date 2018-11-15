//
//  NSMutableAttributedString+Style.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/7/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    private enum Constants {
        static let fontName = "Courier"
        static let fontSize: CGFloat = 18.0
    }
    
    convenience init(textStyled text: String) {
        self.init(string: text,
                  attributes: [.font: UIFont(name: Constants.fontName,
                                             size: Constants.fontSize)!,
                               .foregroundColor: UIColor.white])
    }
}
