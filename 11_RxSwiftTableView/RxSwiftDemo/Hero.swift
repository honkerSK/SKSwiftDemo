//
//  Hero.swift
//  RxSwiftDemo
//
//  Created by sunke on 2020/9/16.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class Hero: NSObject {
    var name : String = ""
    var icon : String = ""
    var intro : String = ""
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
