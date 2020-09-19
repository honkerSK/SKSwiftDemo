//
//  SQLiteTool.swift
//  SQLiteDemo_swift
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import SQLite3

/*
 SQLite执行语句原理: 当使用SQLite执行一条SQL语句时,内部会开启一个事务,执行完毕之后再提交事务,执行10000条数据,就会开启和提交10000次,开启和提交非常的浪费时间
 解决方案:在执行SQL语句之前手动开启事务,在执行之后手动提交事务,这样再调用SQL语句的时候,就不会自动开启和提交事务
 */

class SQLiteTool {
    
    /// 单例
    static let shareInstance = SQLiteTool()
    
    /// 数据库单例对象
    var db :OpaquePointer?
    
    init() {
        // 1.创建并打开数据库
        // 参数1: 数据库文件地址
        // 参数2: 数据库对象,后期对数据库的操作都会用到这个对象
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "") + "/demo.sqlite"
        print(filePath)
        
        if sqlite3_open(filePath, &db) == SQLITE_OK {
            print("数据库打开成功")
            createTable()
        } else {
            print("数据库打开失败")
        }
    }
    
    
    /// 创建表
    private func createTable() {
        // 参数1: 数据库对象
        // 参数2: SQL语句
        // 参数3: 回调函数,可以获取执行后的数据
        // 参数4: 参数3中回调函数的参数1
        // 参数5: 错误信息
        let sql = "CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer, score real DEFAULT 60)"
        var errmsg: UnsafeMutablePointer<Int8>? = nil
        if sqlite3_exec(db, sql, nil, nil, &errmsg) == SQLITE_OK {
            print("创表成功")
        } else {
            
            print("创表失败:\(String(cString: errmsg!))")
        }
    }
    
    /// 删除表
    func drop() {
        let sql = "DROP TABLE IF EXISTS t_student"
        if execute(sql: sql) {
            print("删除表成功")
        } else {
            print("删除表失败")
        }
    }
    
    func execute(sql: String) -> Bool  {
        return sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK
    }
    
    
    /// 开启事务
    func beginTransaction()  {
        execute(sql: "begin transaction")
    }
    
    
    /// 提交事务
    func commitTransaction() {
        execute(sql: "commit transaction")
    }
    
    /// 回滚事务
    func rollbackTransaction() {
        execute(sql: "rollback transaction")
    }
    
}
