//
//  ViewController.swift
//  FMDBTool_swift
//
//  Created by sunke on 2020/9/20.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit
/*
 3，FMDB 三个主要的类
 （1）FMDatabase：一个 FMDatabase 表示一个 sqlite 数据库，所有对数据库的操作都是通过这个类（线程不安全）。它有如下几个方法：
 executeStatements：执行多条 sql。
 executeQuery：执行查询语句。
 executeUpdate：执行除查询以外的语句，如 create、drop、insert、delete、update。
 
 （2）FMDatabaseQueue：内部封装 FMDatabase 和串行 queue，用于多线程操作数据库，并且提供事务（线程安全）。
 inDatabase: 参数是一个闭包,在闭包里面可以获得 FMDatabase 对象。
 inTransaction: 使用事务。
 
 （3）FMResultSet：查询的结果集。可以通过字段名称获取字段值
 
 */
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 创建表
//        createTable()
        
        //插入数据
//        insetData()
//        insetData2()
//        insetData()
//        insetData2()
//        insetData()
//        insetData2()
        
        //更新数据（修改数据）
//        changeDate()
//        changeDate2()
        
        //删除数据
//        deleteData()
//        deleteData2()
        
        //查询数据
//        selectData()
//        selectData2()
        
        //事务操作
//        insertAffairData()
//        insertAffairData2()
        
        
        
        //1.新增数据样例
//        addUserData()
        
        //2.修改数据样例
//        changeUserData()
        
        //3.删除数据
//        deleteUserData()
//        deleteMoreUserData()
        
        //4.获取记录数
//        getCount()
//        getCoun2()
        
        //5.查询数据
        selectUserData()
        print("----------")
        selectUserDataTwo()
        print("----------")
        selectUserDataThree()
        
        
    }
        
}


extension ViewController{
    
    //MARK:- 创建表
    func createTable() {
        // 编写SQL语句（id: 主键  name和age是字段名）
        let sql = "CREATE TABLE IF NOT EXISTS User( \n" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT, \n" +
            "name TEXT, \n" +
            "age INTEGER \n" +
        "); \n"
        
        // 执行SQL语句（注意点: 在FMDB中除了查询意外, 都称之为更新）
        let db = SQLiteManager.shareManger().db
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: []){
                print("创建表成功")
            }else{
                print("创建表失败")
            }
        }
        db.close()
    }
    
    
    //MARK:- 插入数据（新增数据）
    //（1）使用正常方式的插入一条数据
    func insetData() {
        // 编写SQL语句
        let sql = "INSERT INTO User (name, age) VALUES ('codeTao', 18);"
         
        // 执行SQL语句
        let db = SQLiteManager.shareManger().db
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: []){
                print("插入成功")
            }else{
                print("插入失败")
            }
        }
        db.close()
    }
    
    //（2）使用预编译方式插入一条数据
    func insetData2() {
        // 编写SQL语句
        let sql = "INSERT INTO User (name, age) VALUES (?,?);"
         
        // 执行SQL语句
        let db = SQLiteManager.shareManger().db
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: ["kent", 22]){
                print("插入成功")
            }else{
                print("插入失败")
            }
        }
        db.close()
    }
    
    
    //MARK:- 更新数据（修改数据）
    //（1）使用正常方式的修改数据
    func changeDate() {
        // 编写SQL语句
        let sql = "UPDATE User set name = '@kent' WHERE id = 1;"
         
        // 执行SQL语句
        let db = SQLiteManager.shareManger().db
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: []){
                print("更新成功")
            }else{
                print("更新失败")
            }
        }
        db.close()
    }
    
    
    //（2）使用预编译方式修改数据
    func changeDate2() {
        // 编写SQL语句
        let sql = "UPDATE User set name = ? WHERE id = ?;"
         
        // 执行SQL语句
        let db = SQLiteManager.shareManger().db
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: ["@codeTao", 2]){
                print("更新成功")
            }else{
                print("更新失败")
            }
        }
        db.close()
    }
    
    //MARK:- 删除数据
    //（1）使用正常方式的删除数据
    func deleteData() {
        // 编写SQL语句
        let sql = "DELETE FROM User WHERE id = 2;"
         
        // 执行SQL语句
        let db = SQLiteManager.shareManger().db
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: []){
                print("删除成功")
            }else{
                print("删除失败")
            }
        }
        db.close()
    }
    
    //（2）使用预编译方式删除数据
    func deleteData2() {
        // 编写SQL语句
        let sql = "DELETE FROM User WHERE id = ?;"
         
        // 执行SQL语句
        let db = SQLiteManager.shareManger().db
        if db.open() {
            if db.executeUpdate(sql, withArgumentsIn: [3]){
                print("删除成功")
            }else{
                print("删除失败")
            }
        }
        db.close()
        
    }
    
    //MARK:- 查询数据
    //（1）使用正常方式的查询数据
    func selectData() {
        // 编写SQL语句
        let sql = "SELECT * FROM User WHERE id < 3"
         
        // 执行SQL语句
        let db = SQLiteManager.shareManger().db
        if db.open() {
            if let res = db.executeQuery(sql, withArgumentsIn: []){
                // 遍历输出结果
                while res.next() {
                    let id = res.int(forColumn: "id")
                    let name = res.string(forColumn: "name")!
                    let age = res.int(forColumn: "age")
                    print(id, name, age)
                }
            }else{
                print("查询失败")
            }
        }
        db.close()
    }
    
    
    //（2）使用预编译方式查询数据
    func selectData2() {
        // 编写SQL语句
        let sql = "SELECT * FROM User WHERE id > ?"
         
        // 执行SQL语句
        let db = SQLiteManager.shareManger().db
        if db.open() {
            if let res = db.executeQuery(sql, withArgumentsIn: [3]){
                // 遍历输出结果
                while res.next() {
                    let id = res.int(forColumn: "id")
                    let name = res.string(forColumn: "name")!
                    let age = res.int(forColumn: "age")
                    print(id, name, age)
                }
            }else{
                print("查询失败")
            }
        }
        db.close()
    }
    
    
    
}



extension ViewController{
    //MARK:- 事务操作
    // 插入数据
    func insertAffairData() {
        // 使用事务插入10条数据
        if let queue = SQLiteManager.shareManger().dbQueue {
            queue.inTransaction { db, rollback in
                do {
                    for i in 0..<10 {
                        try db.executeUpdate("INSERT INTO User (name, age) VALUES (?,?);",
                                             values: ["codeTao", i])
                    }
                    print("插入成功!")
                } catch {
                    print("插入失败，进行回滚!")
                    rollback.pointee = true
                }
            }
        }
    }
    
    
    //MARK:- 事务回滚
    // 插入数据
    func insertAffairData2() {
        // 使用事务插入10条数据
        if let queue = SQLiteManager.shareManger().dbQueue {
            queue.inTransaction { db, rollback in
                do {
                    for i in 0..<10 {
                        if i == 4 {
                            try db.executeUpdate("INSERT INTO UserXXX (name, age) VALUES (?,?);",
                                                 values: ["kent", i])
                        } else {
                            try db.executeUpdate("INSERT INTO User (name, age) VALUES (?,?);",
                                                 values: ["sun", i])
                        }
                    }
                    print("插入成功!")
                } catch {
                    print("插入失败，进行回滚!")
                    rollback.pointee = true
                }
            }
        }
    }
    

}

//MARK:- 实体类与数据库表的关联映射
extension ViewController{
    //1.新增数据样例
    func addUserData() {
        //下面创建 10 个模型对象，并调用 save() 方法保存到库中。
        //注意：数据库以及数据表我们事先不需要手动创建，模型初始化时会自动判断是否存在对应的表，没有的话会自动创建。
        // 创建10条数据
        for i in 1..<11 {
            let user = User()
            user.name = "测试用户\(i)"
            user.age = 100 + i
            user.save()
        }
    }
    
    
    //2.修改数据样例
    func changeUserData() {
        let user = User()
        user.id = 2
        user.name = "codeTao"
        user.age = 0
        user.save()
    }
    
    //3.删除数据
    //（1）调用模型对象的 delete() 方法即可将该对象对应的数据删除（内部根据主键来判断）
    func deleteUserData() {
        let user = User()
        user.id = 2
        user.delete()
    }
    //（2）也可以通过类方法 remove() 来批量删除数据：
    func deleteMoreUserData() {
        // 删除User表所有的数据
//        User.remove()
        // 根据指定条件删除User表的数据
        User.remove(filter: "id > 5 and age < 107")
    }
    
    //4.获取记录数
    //（1）通过类方法 count() 可以获取数据表中的所有记录数：
    func getCount() {
        let count = User.count()
        print("记录数：\(count)")
    }
    
    //（2）我们也可根据指定条件来获取记录数：
    func getCoun2() {
        let count = User.count(filter: "id > 3 and age < 107")
        print("记录数：\(count)")
    }
    
    
    //5.查询数据
    //（1）通过类方法 rows() 可以获取数据表中的所有数据（会自动转换成对应的模型数组）：
    func selectUserData() {
        // 获取所有数据
        let users = User.rows()
                 
        // 遍历输出结果
        for user in users {
            print(user.id, user.name, user.age)
        }
    }
    
    
    //（2）rows() 方法还可指定查询条件、排序、以及限制数量。
    func selectUserDataTwo() {
        // 根据条件获取数据
        let users = User.rows(filter: "id > 3 and age < 107", order: "age desc", limit: 3)
                 
        // 遍历输出结果
        for user in users {
            print(user.id, user.name, user.age)
        }
    }
    
    
    //（3）我们还可以使用 rowsFor() 方法来通过完整的 sql 查询数据（同样也会自动转换成对应的模型数组）：
    func selectUserDataThree() {
        let users = User.rowsFor(sql: "select * from User limit 3")
                 
        // 遍历输出结果
        for user in users {
            print(user.id, user.name, user.age)
        }
    }
    

}
