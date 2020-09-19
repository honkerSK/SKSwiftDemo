//
//  UIButtonExtension.swift.swift
//  PhotoBrowserDemo
//
//  Created by sunke on 2020/9/17.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title : String, bgColor : UIColor, fontSize : CGFloat) {
        self.init()
        
        backgroundColor = bgColor
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
}
