//
//  CustomTextField.swift
//  Appy
//
//  Created by Bizet Rodriguez-Velez on 11/20/19.
//  Copyright © 2019 Bizet Rodriguez. All rights reserved.
//

import UIKit

@IBDesignable class CustomTextField: UITextField {
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        sharedInit()
    }
    func sharedInit() {
        refreshCornerRadius(value: cornerRadius)
        refreshBorderColor(value: borderColor)
        refreshBorderWidth(value: borderWidth)
    }
    // MARK: - Inspectables
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            refreshCornerRadius(value: cornerRadius)
        }
    }
    @IBInspectable var borderColor: UIColor = .red {
        didSet {
            refreshBorderColor(value: borderColor)
        }
    }
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            refreshBorderWidth(value: borderWidth)
        }
    }
    // MARK: - Refreshers
    func refreshCornerRadius(value: CGFloat) {
        self.layer.cornerRadius = value
    }
    func refreshBorderColor(value: UIColor) {
        self.layer.borderColor = value.cgColor
    }
    func refreshBorderWidth(value: CGFloat) {
        self.layer.borderWidth = value
    }
}
