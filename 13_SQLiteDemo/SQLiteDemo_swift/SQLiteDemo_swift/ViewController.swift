//
//  ViewController.swift
//  SQLiteDemo_swift
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //插入数据
//        let stu = Student(name: "张三", age: 20, score: 100)
//        let stu1 = Student(name: "李四", age: 20, score: 100)
//        stu.insert()
//        stu1.insert()
        
        //查询
        //Student.quaryAllPrepare()
        
        
        //更新数据
        let sql1 = "UPDATE t_student set score = score-50 WHERE name = '张三'"
        let sql2 = "UPDATE t_student set score = score+50 WHERE name = '李四'"
        
        // 开启事务
        SQLiteTool.shareInstance.beginTransaction()
        let result1 = SQLiteTool.shareInstance.execute(sql: sql1)
        let result2 = SQLiteTool.shareInstance.execute(sql: sql2)
        
        if result1 && result2 {
            // 提交事务
            SQLiteTool.shareInstance.commitTransaction()
        } else {
            // 回滚事务
            SQLiteTool.shareInstance.rollbackTransaction()
        }
        
    }
    
    
}

