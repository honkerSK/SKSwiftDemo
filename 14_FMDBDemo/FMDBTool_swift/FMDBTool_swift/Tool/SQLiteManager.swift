//
//  SQLiteManager.swift
//  FMDBTool_swift
//
//  Created by sunke on 2020/9/20.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

// 数据库管理类
class SQLiteManager: NSObject {
     
    // 创建单例
    private static var manger: SQLiteManager = SQLiteManager()
    class func shareManger() -> SQLiteManager {
        return manger
    }
    private override init() {} // 私有化init方法
     
    //销毁单例对象
//    class func destroy() {
//        manger = nil
//    }
    
    // 数据库名称
    private let dbName = "test.db"
     
    // 数据库地址
    lazy var dbURL: URL = {
        // 根据传入的数据库名称拼接数据库的路径
        let fileURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask,
                 appropriateFor: nil, create: true)
            .appendingPathComponent(dbName)
        print("数据库地址：", fileURL)
        return fileURL
    }()
     
    // FMDatabase对象（用于对数据库进行操作）
    lazy var db: FMDatabase = {
        let database = FMDatabase(url: dbURL)
        return database
    }()
     
    // FMDatabaseQueue对象（用于多线程事务处理）
    lazy var dbQueue: FMDatabaseQueue? = {
        // 根据路径返回数据库
        let databaseQueue = FMDatabaseQueue(url: dbURL)
        return databaseQueue
    }()
}
