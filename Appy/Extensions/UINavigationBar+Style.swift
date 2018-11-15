//
//  UINavigationController+Style.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/9/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework

extension UINavigationBar {
    
    func modifyBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        
        self.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.flatSkyBlue()]
    }
}
