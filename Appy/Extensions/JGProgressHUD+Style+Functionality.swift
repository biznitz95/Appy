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

func showError(view: UIView, textLabel: String = "") {
    let errorView = LOTAnimationView(name: "error")
    let HUD = JGProgressHUD(style: .dark)
    HUD.textLabel.text = textLabel
    HUD.indicatorView = JGProgressHUDImageIndicatorView(contentView: errorView)
    errorView.playAnimation(image: "error", loop: false)
    HUD.show(in: view)
    let time = Double(errorView.animationDuration)
    HUD.dismiss(afterDelay: time, animated: true)
}

func showCheck(view: UIView, textLabel: String = "") {
    let checkView = LOTAnimationView(name: "check")
    let HUD = JGProgressHUD(style: .dark)
    HUD.textLabel.text = textLabel
    HUD.indicatorView = JGProgressHUDImageIndicatorView(contentView: checkView)
    checkView.playAnimation(image: "check", loop: false)
    HUD.show(in: view)
    let time = Double(checkView.animationDuration)
    HUD.dismiss(afterDelay: time, animated: true)
}

func showProgress(view: UIView, textLabel: String = "") {
    let loadingView = LOTAnimationView(name: "loading")
    let HUD = JGProgressHUD(style: .dark)
    HUD.textLabel.text = textLabel
    HUD.indicatorView = JGProgressHUDImageIndicatorView(contentView: loadingView)
    loadingView.playAnimation(image: "check", loop: false)
    HUD.show(in: view)
}
