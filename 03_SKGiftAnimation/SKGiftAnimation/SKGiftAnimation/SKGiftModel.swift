//
//  SKGiftModel.swift
//  SKGiftAnimation
//
//  Created by sunke on 2020/8/29.
//  Copyright © 2020 KentSun. All rights reserved.
//
// 礼物模型
import UIKit

class SKGiftModel: NSObject {
    var senderName : String = ""
    var senderIcon : String = ""
    var giftIcon : String = ""
    var giftName : String = ""
    
    init(senderName : String, senderIcon : String, giftIcon : String, giftName : String) {
        self.senderName = senderName
        self.senderIcon = senderIcon
        self.giftIcon = giftIcon
        self.giftName = giftName
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        // 1.判断传入的内容是否有值
        guard let object = object as? SKGiftModel else {
            return false
        }
        
        // 2.判断赠送者和赠送的礼物名称是否相同
        return object.senderName == senderName && object.giftName == giftName
    }
    
    
}

