//
//  CALayer+Style.swift
//  Appy
//
//  Created by Ohayo on 11/6/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit

extension CALayer {
    
    /// Updates the layer's border according to the specified parameters.
    func styleBorder(cornerRadius: CGFloat, width: CGFloat, color: CGColor) {
        self.cornerRadius = cornerRadius
        borderWidth = width
        borderColor = color
    }
    
}
