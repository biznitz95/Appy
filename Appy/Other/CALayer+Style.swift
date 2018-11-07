//
//  CALayer+Style.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/7/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//


import UIKit

extension CALayer {
    // Use a double // for comments to devs or /// for official documentation.
    
    /// Updates the layer's border according to the specified parameters.
    func styleBorder(cornerRadius: CGFloat, width: CGFloat, color: CGColor) {
        self.cornerRadius = cornerRadius
        borderWidth = width
        borderColor = color
    }
    
}
