//
//  JGProgressHUD+Style+Functionality.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/27/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import JGProgressHUD
import Lottie

extension JGProgressHUD {

    func createErrorHUD() -> JGProgressHUD {
        let errorView = LOTAnimationView(name: "error")
        let HUD = JGProgressHUD(style: .dark)
        HUD.indicatorView = JGProgressHUDImageIndicatorView(contentView: errorView)
        
        return HUD
    }

}
