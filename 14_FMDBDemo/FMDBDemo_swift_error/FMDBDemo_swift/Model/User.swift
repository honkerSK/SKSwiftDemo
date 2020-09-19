//
//  User.swift
//  FMDBDemo_swift
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class User: Models {
    var name: String = ""
    var detail: Detail?

    static let shared: User = {
          $0.initialize()
          return $0
    }(User(dict: ["" : AnyObject.self]))
    
    func initialize() {
        User.createTable()
    }
    
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        super.setValuesForKeys(keyedValues)
        detail = Detail(dict: keyedValues)
    }
    
}


// MARK: - 对数据库的操作
extension User {
    fileprivate static func createTable()  {
        let sqls = ["CREATE TABLE IF NOT EXISTS t_user(id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL)", "CREATE TABLE IF NOT EXISTS t_detail(id integer PRIMARY KEY AUTOINCREMENT, text text, created_at text, user_id integer, CONSTRAINT fk_detail_ref_user FOREIGN KEY (user_id) REFERENCES t_user (id))"]
        FMDBTool.executeStatements(sqls: sqls)
    }
    
    func insert() {
        
        // 先从数据库中获取用户对应的id
        let sql = "SELECT id FROM t_user WHERE name = '\(name)'"
        let reslutArray = FMDBTool.query(sql: sql, columnNames: ["id"])
        let resultDict = reslutArray?.first
        if let resultValue = resultDict?["id"] as? Int {
            // 如果id存在,作为detail的user_id,在插入detail数据
            detail?.insert(userId: resultValue)
        } else {
            // 如果id不存在,插入用户数据
            
            FMDBTool.executeUpdate(sql: "INSERT INTO t_user(name) VALUES ('\(name)')")
            insert()
        }
    }
    
    static func dataSource(dataResult: ([User]) -> ()) {
        let sql = "SELECT * FROM t_user tu, t_detail WHERE tu.id == user_id"
        let columnNames = ["name", "text", "created_at"]
        guard let resultArray = FMDBTool.query(sql: sql, columnNames:  columnNames) else {
            dataResult([User]())
            return
        }
        dataResult(resultArray.map {
            User(dict: $0)
        })
    }
}

