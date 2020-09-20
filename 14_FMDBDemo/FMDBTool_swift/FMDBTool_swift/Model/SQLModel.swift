//
//  SQLModel.swift
//  FMDBTool_swift
//
//  Created by sunke on 2020/9/20.
//  Copyright © 2020 KentSun. All rights reserved.
//

/*
 （1）只要我们让实体类继承 SQLModel，那么它就会自行将实体类跟数据库表作关联映射。之后只要操作实体类对象就可以直接进行数据的读取，修改，新增操作。
 （2）SQLModel 其内部实现使用到了 Swift 的反射，通过遍历对象内的所有属性，从而自动拼接成相应的 SQL 语句来执行。 
 
 */

import UIKit

protocol SQLModelProtocol {}
 
// 数据库模型（一张表对应一个模型）
@objcMembers
class SQLModel: NSObject, SQLModelProtocol {
     
    // 模型对应的表名（直接使用对应模型类名字）
    internal var table = ""
     
    // 记录每个模式对应的数据表是否已经创建完毕了
    private static var verified = [String:Bool]()
     
    // 初始化方法
    required override init() {
        super.init()
        // 自动初始化表名
        self.table = type(of: self).table
        // 自动建对应的数据库表
        let verified = SQLModel.verified[self.table]
        if verified == nil || !verified! {
            let db = SQLiteManager.shareManger().db
            var sql = "CREATE TABLE IF NOT EXISTS \(table) ("
            // Columns
            let cols = values()
            var first = true
            for col in cols {
                if first {
                    first = false
                    sql += getColumnSQL(column:col)
                } else {
                    sql += ", " + getColumnSQL(column: col)
                }
            }
            // Close query
            sql += ")"
            if db.open() {
                if db.executeUpdate(sql, withArgumentsIn:[]) {
                    SQLModel.verified[table] = true
                    print("\(table) 表自动创建成功")
                }
            }
        }
    }
     
    // 返回主键字段名（如果模型主键不是id，则需要覆盖这个方法）
    func primaryKey() -> String {
        return "id"
    }
     
    // 忽略的属性（模型中不需要与数据库表进行映射的字段可以在这里发返回）
    func ignoredKeys() -> [String] {
        return []
    }
     
    // 静态方法返回表名
    static var table:String {
        // 直接返回类名字
        return "\(classForCoder())"
    }
     
    // 删除指定数据（可附带条件）
    @discardableResult
    class func remove(filter: String = "") -> Bool {
        let db = SQLiteManager.shareManger().db
        var sql = "DELETE FROM \(table)"
        if !filter.isEmpty {
            // 添加删除条件
            sql += " WHERE \(filter)"
        }
        if db.open() {
            return db.executeUpdate(sql, withArgumentsIn:[])
        } else {
            return false
        }
    }
     
    // 获取数量（可附带条件）
    class func count(filter: String = "") -> Int {
        let db = SQLiteManager.shareManger().db
        var sql = "SELECT COUNT(*) AS count FROM \(table)"
        if !filter.isEmpty {
            // 添加查询条件
            sql += " WHERE \(filter)"
        }
        
        if db.open(){
            if let res = db.executeQuery(sql, withArgumentsIn: []) {
                if res.next() {
                    return Int(res.int(forColumn: "count"))
                } else {
                    return 0
                }
            }
        }        
        return 0
    }
     
    // 保存当前对象数据
    // * 如果模型主键为空或者使用该主键查不到数据则新增
    // * 否则的话则更新
    @discardableResult
    func save() -> Bool{
        let key = primaryKey()
        let data = values()
        var insert = true
        let db = SQLiteManager.shareManger().db
         
        if let rid = data[key] {
            var val = "\(rid)"
            if rid is String {
                val = "'\(rid)'"
            }
            let sql = "SELECT COUNT(*) AS count FROM \(table) "
                + "WHERE \(primaryKey())=\(val)"
            if db.open() {
                if let res = db.executeQuery(sql, withArgumentsIn: []) {
                    if res.next() {
                        insert = res.int(forColumn: "count") == 0
                    }
                }
            }
             
        }
         
        let (sql, params) = getSQL(data:data, forInsert:insert)
        // 执行SQL语句
         
        if db.open() {
            return db.executeUpdate(sql, withArgumentsIn: params ?? [])
        } else {
            return false
        }
    }
     
    // 删除当天对象数据
    @discardableResult
    func delete() -> Bool{
        let key = primaryKey()
        let data = values()
        let db = SQLiteManager.shareManger().db
        if let rid = data[key] {
            if db.open() {
                let sql = "DELETE FROM \(table) WHERE \(primaryKey())=\(rid)"
                return db.executeUpdate(sql, withArgumentsIn: [])
            }
        }
        return false
    }
     
    // 通过反射获取对象所有有的属性和属性值
    internal func values() -> [String:Any] {
        var res = [String:Any]()
        let obj = Mirror(reflecting:self)
        processMirror(obj: obj, results: &res)
        getValues(obj: obj.superclassMirror, results: &res)
        return res
    }
     
    // 供上方方法（获取对象所有有的属性和属性值）调用
    private func getValues(obj: Mirror?, results: inout [String:Any]) {
        guard let obj = obj else { return }
        processMirror(obj: obj, results: &results)
        getValues(obj: obj.superclassMirror, results: &results)
    }
     
    // 供上方方法（获取对象所有有的属性和属性值）调用
    private func processMirror(obj: Mirror, results: inout [String: Any]) {
        for (_, attr) in obj.children.enumerated() {
            if let name = attr.label {
                // 忽略 table 和 db 这两个属性
                if name == "table" || name == "db" {
                    continue
                }
                // 忽略人为指定的属性
                if ignoredKeys().contains(name) ||
                    name.hasSuffix(".storage") {
                    continue
                }
                results[name] = unwrap(attr.value)
            }
        }
    }
     
    //将可选类型（Optional）拆包
    func unwrap(_ any:Any) -> Any {
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != .optional {
            return any
        }
         
        if mi.children.count == 0 { return any }
        let (_, some) = mi.children.first!
        return some
    }
     
    // 返回新增或者修改的SQL语句
    private func getSQL(data:[String:Any], forInsert:Bool = true)
        -> (String, [Any]?) {
        var sql = ""
        var params:[Any]? = nil
        if forInsert {
            sql = "INSERT INTO \(table)("
        } else {
            sql = "UPDATE \(table) SET "
        }
        let pkey = primaryKey()
        var wsql = ""
        var rid:Any?
        var first = true
        for (key, val) in data {
            // 处理主键
            if pkey == key {
                if forInsert {
                    if val is Int && (val as! Int) == -1 {
                        continue
                    }
                } else {
                    wsql += " WHERE " + key + " = ?"
                    rid = val
                    continue
                }
            }
            // 设置参数
            if first && params == nil {
                params = [AnyObject]()
            }
            if forInsert {
                sql += first ? "\(key)" : ", \(key)"
                wsql += first ? " VALUES (?" : ", ?"
                params!.append(val)
            } else {
                sql += first ? "\(key) = ?" : ", \(key) = ?"
                params!.append(val)
            }
            first = false
        }
        // 生成最终的SQL
        if forInsert {
            sql += ")" + wsql + ")"
        } else if params != nil && !wsql.isEmpty {
            sql += wsql
            params!.append(rid!)
        }
        return (sql, params)
    }
     
    // 返回建表时每个字段的sql语句
    private func getColumnSQL(column:(key: String, value: Any)) -> String {
        let key = column.key
        let val = column.value
        var sql = "'\(key)' "
        if val is Int {
            // 如果是Int型
            sql += "INTEGER"
            if key == primaryKey() {
                sql += " PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE"
            } else {
                sql += " DEFAULT \(val)"
            }
        } else {
            // 如果是其它类型
            if val is Float || val is Double {
                sql += "REAL DEFAULT \(val)"
            } else if val is Bool {
                sql += "BOOLEAN DEFAULT " + ((val as! Bool) ? "1" : "0")
            } else if val is Date {
                sql += "DATE"
            } else if val is NSData {
                sql += "BLOB"
            } else {
                // Default to text
                sql += "TEXT"
            }
            if key == primaryKey() {
                sql += " PRIMARY KEY NOT NULL UNIQUE"
            }
        }
        return sql
    }
}
 
extension SQLModelProtocol where Self: SQLModel {
    // 根据完成的sql返回数据结果
    static func rowsFor(sql: String = "") -> [Self] {
        var result = [Self]()
        let tmp = self.init()
        let data = tmp.values()
        let db = SQLiteManager.shareManger().db
        let fsql = sql.isEmpty ? "SELECT * FROM \(table)" : sql
        if let res = db.executeQuery(fsql, withArgumentsIn: []){
            // 遍历输出结果
            while res.next() {
                let t = self.init()
                for (key, _) in data {
                    if let val = res.object(forColumn: key) {
                        t.setValue(val, forKey:key)
                    }
                }
                result.append(t)
            }
        }else{
            print("查询失败")
        }
        return result
    }
     
    // 根据指定条件和排序算法返回数据结果
    static func rows(filter: String = "", order: String = "",
                     limit: Int = 0) -> [Self] {
        var sql = "SELECT * FROM \(table)"
        if !filter.isEmpty {
            sql += " WHERE \(filter)"
        }
        if !order.isEmpty {
            sql += " ORDER BY \(order)"
        }
        if limit > 0 {
            sql += " LIMIT 0, \(limit)"
        }
        return self.rowsFor(sql:sql)
    }
}
