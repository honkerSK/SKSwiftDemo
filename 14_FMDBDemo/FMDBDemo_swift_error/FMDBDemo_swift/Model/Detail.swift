//
//  Detail.swift
//  FMDBDemo_swift
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class Detail: Models {
    var text: String = ""
    var created_at: String = ""
}


// MARK: - 数据库操作
extension Detail {
    
    /// 插入数据
    ///
    /// - Parameter userId: 外键
    func insert(userId: Int) {
        FMDBTool.executeUpdate(sql: "INSERT INTO t_detail (text, created_at, user_Id) VALUES ('\(text)', '\(created_at)', \(userId))")
    }
    
    /// 删除数据
    func delete() {
        FMDBTool.executeUpdate(sql: "DELETE FROM t_detail WHERE created_at = '\(created_at)'")
    }
}
