//
//  UIAnimation+PlayAnimation.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/14/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import Lottie

extension LOTAnimationView {
    
    func playAnimation(image: String, loop: Bool = true) {
        self.setAnimation(named: image)
        self.loopAnimation = loop
        self.contentMode = .scaleAspectFit
        self.play()
    }
    
}
