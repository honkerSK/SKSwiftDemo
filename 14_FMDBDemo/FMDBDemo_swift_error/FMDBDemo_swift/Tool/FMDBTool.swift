//
//  FMDBTool.swift
//  FMDBDemo_swift
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
import FMDB

class FMDBTool: NSObject {
    
    static let shared: FMDBTool = {
        $0.initialize()
        return $0
    }(FMDBTool())
    
    
    static var db: FMDatabase = {
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "") + "/demo.sqlite"
        return FMDatabase(path: filePath)
    }()
    
    static var databaseQueue: FMDatabaseQueue = {
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "") + "/demo.sqlite"
        return FMDatabaseQueue(path: filePath)!
    }()
    
    func initialize(){
        // 打开数据库
        if FMDBTool.db.open() {
            print("数据库打开成功")
        }

        FMDBTool.databaseQueue.inDatabase { (db) in
            db.open()
        }
    }
    

    
    
    /// 执行单个SQL语句
    static func executeUpdate(sql: String)  {
        if db.executeUpdate(sql, withArgumentsIn: []) {
            print("执行SQL语句成功")
        }
        
    }
    
    /// 执行单个SQL语句DatabaseQueue
    static func executeUpdateDatabase(sql: String)  {
        databaseQueue.inDatabase {
            $0.executeUpdate(sql, withArgumentsIn: [])
        }

    }
    
    /// 执行多个SQL语句
    static func executeStatements(sqls: [String]) {
        var sqlStr = ""
        for sql in sqls {
               sqlStr += sql + ";"
        }
        
        if db.executeStatements(sqlStr) {
            print("执行多个SQL语句成功")
        }
    }
    
    /// 执行多个SQL语句
    static func executeStatementsQueue(sqls: [String]) {
        var sqlStr = ""
        for sql in sqls {
            sqlStr += sql + ";"
        }
        databaseQueue.inDatabase {
            $0.executeStatements(sqlStr)
        }
    }
    
    
    /// 查询数据
    ///
    /// - Parameters:
    ///   - sql: sql语句
    ///   - columnNames: 需要查询的属性数组
    /// - Returns: 查询结果
    static func query(sql: String, columnNames: [String]) -> [[String : Any]]? {
        guard let result = db.executeQuery(sql, withArgumentsIn: []) else {
            return nil
        }
        
        var valueDict: [String : Any] = [:]
        var dictArray = [[String : Any]]()
        while result.next() {
            for columnName in columnNames {
                let value = result.object(forColumnName: columnName)
                valueDict[columnName] = value
            }
            dictArray.append(valueDict)
        }
        return dictArray
    }
    
    /// 查询数据
    ///
    /// - Parameters:
    ///   - sql: sql语句
    ///   - columnNames: 需要查询的属性数组
    /// - Returns: 查询结果
    static func queryDatabase(sql: String, columnNames: [String], resultArray: @escaping ([[String : Any]]) -> () )  {
        
       
        databaseQueue.inDatabase {
            guard let result = $0.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            var valueDict: [String : Any] = [:]
            var dictArray = [[String : Any]]()
            while result.next() {
                for columnName in columnNames {
                    let value = result.object(forColumnName: columnName)
                    valueDict[columnName] = value
                }
                dictArray.append(valueDict)
            }
            resultArray(dictArray)
        }
    }
}
