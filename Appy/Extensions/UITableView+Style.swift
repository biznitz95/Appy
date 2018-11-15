//
//  UITableView+Style.swift
//  Appy
//
//  Created by Bizet Rodriguez on 11/9/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework

extension UITableView {
    
    func modifyTableViewStyle(forCell cellIdentifier: String, rowHeight: CGFloat = 80) {
        self.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.backgroundColor = UIColor.flatNavyBlueColorDark()
        self.separatorStyle = .none
        self.rowHeight = rowHeight
    }
}

