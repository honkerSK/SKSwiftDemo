//
//  Student.swift
//  SQLiteDemo_swift
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import SQLite3

func callback(param: UnsafeMutableRawPointer?, columnCount: Int32, values: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?, columnNames: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>?) -> Int32 {
    let columnCount = Int(columnCount)
    for i in 0..<columnCount {
        if let value = values?[i] , let columnName = columnNames?[i] {
            let value = String(cString: value)
            let columnName = String(cString: columnName)
            print(value, columnName)
        }
    }
    return 0
}


class Student: NSObject {
    var name: String = ""
    var age: Int = 0
    var score: Double = 0
    
    init(name: String, age: Int, score: Double) {
        self.name = name
        self.age = age
        self.score = score
    }
}

// MARK: - 对数据库的操作
extension Student {
    
    /// 使用绑定参数来插入数据
    func insertBind() {
        // 1.创建准备语句
        // 参数1: 数据库对象
        // 参数2: SQL语句
        // 参数3: 参数2的长度,如果是一条SQL语句,填-1,代表自动计算
        // 参数3: 准备语句对象
        // 参数5: 剩余的参数2的SQL语句
        
        let db = SQLiteTool.shareInstance.db
        let sql = "INSERT INTO t_student(name, age, score) VALUES (?, ?, ?)"
        var stmt: OpaquePointer? = nil
        
        
        if sqlite3_prepare_v2(db, sql, -1,  &stmt, nil) == SQLITE_OK {
//            print("创建准备语句成功")
        } else {
//            print("创建准备语句")
            return
        }
        SQLiteTool.shareInstance.beginTransaction()
        let startTime = CFAbsoluteTimeGetCurrent()
        for _ in 0..<10000 {
            // 2.绑定参数
            // 参数1: 准备语句对象
            // 参数2: 绑定参数的索引,从1开始
            // 参数3: 绑定的参数的内容
            // 参数4: 绑定的参数的值的长度 -1为自动计算
            // 参数5: 系统对参数的处理方式
            
            // 2.1.绑定字符串
            //SQLITE_STATIC      ((sqlite3_destructor_type)0) : 该指针是一个静态的,告诉SQLlite,在执行完毕前承诺指针指向的内容不会改变.如果改变了,则会造成数据混乱
            //SQLITE_TRANSIENT   ((sqlite3_destructor_type)-1): 会对指针指向的对象进行拷贝一份,在执行结束后销毁,比较安全
            // 不安全的按位转换
            // 将参数1转为参数2的类型
            // 注意:如果转换不成功则会出错,要能保证一定可以转换成功
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT)
            
            // 2.2.绑定年龄
            // 参数1: 准备语句对象
            // 参数2: 绑定参数的索引
            // 惨呼3: 绑定参数的内容
            sqlite3_bind_int(stmt, 2, Int32(age))
            
            // 2.3.绑定分数
            sqlite3_bind_double(stmt, 3, score)
            
            // 3.执行准备语句
            // 参数: 准备语句对象
            if sqlite3_step(stmt) == SQLITE_DONE {
                //            print("准备语句执行成功")
            }
            
            // 4.重置准备语句:会将对应的值情况
            // 参数: 准备语句对象
            sqlite3_reset(stmt)

        }
        let endTime = CFAbsoluteTimeGetCurrent()
        SQLiteTool.shareInstance.commitTransaction()
        // 5.销毁准备语句
        // 参数: 准备语句对象
        sqlite3_finalize(stmt)
        
        print("执行时间: \(endTime - startTime)")
        
    }
    
    /// 添加数据
    func insert()  {
        let sql = "INSERT INTO t_student (name, age, score) VALUES ('\(name)', \(age), \(score))"
        if SQLiteTool.shareInstance.execute(sql: sql) {
//            print("添加数据成功")
        } else {
//            print("添加数据失败")
        }
    }
    
    /// 删除数据
    ///
    /// - Parameter name: 匹配参数
    static func delete(name: String) {
        let sql = "DELETE FROM t_student WHERE name = '\(name)'"
        if SQLiteTool.shareInstance.execute(sql: sql) {
            print("删除数据成功")
        } else {
            print("删除数据失败")
        }
    }
    
    
    /// 修改某条数据
    ///
    /// - Parameter newStu: 修改后的对象
    func update(newStu: Student) {
        let sql = "UPDATE t_student set name = '\(newStu.name)', age = \(newStu.age), score = \(newStu.age) WHERE name = '\(name)'"
        if SQLiteTool.shareInstance.execute(sql: sql) {
            print("修改数据成功")
        } else {
            print("修改数据失败")
        }
    }
    
    
    /// 查询
    static func queryAllExecute()  {
        let sql = "SELECT * FROM t_student"
        // 参数1: 数据库对象
        // 参数2: sql语句
        // 参数3: 回调函数,每查询到结果一次就回调一次
            // 参数1: 参数4
            // 参数2: 总列数
            // 参数3: 所有值的数组
            // 参数4: 所有列的名称数组
            // 返回值: 0: 查询所有 非0: 查询多次
        // 参数4: 参数3的参数1
//        // 参数5: 错误信息
        let db = SQLiteTool.shareInstance.db
//        sqlite3_exec(db, sql, {(param, columnCount, values, columnNames) -> Int32 in
//            let columnCount = Int(columnCount)
//            for i in 0..<columnCount {
//                if let value = values?[i] , let columnName = columnNames?[i] {
//                    let value = String(cString: value)
//                    let columnName = String(cString: columnName)
//                    print(value, columnName)
//                }
//            }
//            return 0
//            }, nil, nil)
        sqlite3_exec(db, sql, callback, nil, nil)
    }
    
    
    /// 查询
    static func quaryAllPrepare() {
        // 1.创建准备语句
        // 参数1: 数据库对象
        // 参数2: sql语句
        // 参数3: 参数2的长度, -1为自动计算
        // 参数4: 准备语句对象
        // 参数5: 参数2剩余的字符串
        let db = SQLiteTool.shareInstance.db
        let sql = "SELECT * FROM t_student"
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
            print("准备语句创建成功")
        }
        
        // 2.绑定参数
        
        // 3.执行准备语句
        // 执行结果为SQLITE_ROW,就代表从中获取了数据
        while sqlite3_step(stmt) == SQLITE_ROW {
            // 获取列的个数
            let count = sqlite3_column_count(stmt)
            for i in 0..<count {
                // 取出每列的列名
                if let columnName = sqlite3_column_name(stmt, i) {
                    print(String(cString: columnName))
                }
                
                // 取出每列的值
                let type = sqlite3_column_type(stmt, i)
                if type == SQLITE_TEXT {
                    if let value = sqlite3_column_text(stmt, i) {
                        print(String(cString: value))
                    }
                }
                if type == SQLITE_INTEGER {
                   let value = sqlite3_column_int(stmt, i)
                   print(value)
                }
                
                if type == SQLITE_FLOAT {
                    let value = sqlite3_column_double(stmt, i)
                    print(value)
                }
            
            
                
            }
        }
        
        // 4.重置准备语句
        sqlite3_reset(stmt)
        
        // 5.释放准备语句
        sqlite3_finalize(stmt)
    }
}


