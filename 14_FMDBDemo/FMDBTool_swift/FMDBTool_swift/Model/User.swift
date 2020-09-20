//
//  User.swift
//  FMDBTool_swift
//
//  Created by sunke on 2020/9/20.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class User: SQLModel {
    var id:Int = -1
    var name:String = ""
    var age:Int = -1
    
    //默认情况下，模型里的 id 属性则作为数据库表里的主键。如果想要其它属性作为主键，则需要重写覆盖 primaryKey() 方法：
    
    // 返回主键名
//    override func primaryKey() -> String {
//        return "uid"
//    }
    
    
    //默认情况下，模型里面所有属性都会创建对应的数据库表字段，如果想要某些属性不与数据库表进行映射，则需要重写覆盖 ignoredKeys() 方法：
    // 返回忽略的键值
//    override func ignoredKeys() -> [String] {
//        return ["age"]
//    }
}
