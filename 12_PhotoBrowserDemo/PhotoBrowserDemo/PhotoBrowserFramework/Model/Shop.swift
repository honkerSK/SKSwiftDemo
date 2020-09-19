//
//  Shop.swift
//  PhotoBrowserDemo
//
//  Created by sunke on 2020/9/17.
//  Copyright © 2020 KentSun. All rights reserved.
//

import Foundation

class Shop: NSObject {
    
//    var picURL : URL?
//    @objc var download_url : String? {
//        didSet {
//            if let urlStr = download_url {
//                picURL = URL(string: urlStr)
//            }
//        }
//    }
    
    @objc var download_url : String?
    
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
