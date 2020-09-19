//
//  ViewController.m
//  SQLiteDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
#import "SQLiteManager.h"
#import "Student.h"

@interface ViewController ()

@property (assign, nonatomic) sqlite3 *db;
/* 学生的数据 */
@property (nonatomic, strong) NSMutableArray *students;
/* 查询到的数据 */
@property (nonatomic, strong) NSArray *queryStus;

@property (assign, nonatomic) NSInteger page;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SQLiteManager shareIntance] openDB];
    self.page = 0;
}

#pragma mark - 对表的操作
- (IBAction)createTable {
    // 1.获取需要执行的SQLString
    NSString *createTableSQL = @"CREATE TABLE IF NOT EXISTS t_student (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, score REAL);";
    
    // 2.执行sql语句
    [[SQLiteManager shareIntance] execSQLWithSQL:createTableSQL];
}

- (IBAction)dropTable {
    // 1.获取删除表的SQL语句
    NSString *dropTableSQL = @"DROP TABLE IF EXISTS t_student;";
    
    // 2.执行sqli语句
    BOOL flag =  [[SQLiteManager shareIntance] execSQLWithSQL:dropTableSQL];
    if (flag) {
        NSLog(@"删除表成功");
    } else {
        NSLog(@"删除表失败");
    }
}

#pragma mark - DML操作
/*
 如果在插入数据的过程中,没有手动开启事务,那么系统会在每次插入一条数据时就开启一个事务.
 如果在插入数据的过程中,有手动开启事务,那么系统就不会再帮助我们开启事务.
 
 开启事务有两个好处:
 1> 可以保证数据全部插入到数据库中
 2> 可以打开提供插入的效率
 */

- (IBAction)insertData {
    // 插入 10000 个学生
    //20.778942
    //3.431365
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 1.开启事务
        [[SQLiteManager shareIntance] beiginTransation];
        
        // 2.插入数据
        NSInteger index = 0;
        NSInteger count = self.students.count;
        
        CFTimeInterval startTime = CACurrentMediaTime();
        
        for (Student *stu in self.students) {
            [stu insertIntoDB];
            index++;
        }
            
        // 3.判断是提交事务还是回滚事务
        if (index == count) {
            [[SQLiteManager shareIntance] commitTransation];
        } else {
            [[SQLiteManager shareIntance] rollbackTransation];
        }
        // 获取结束时间
        CFTimeInterval endTime = CACurrentMediaTime();
        
        //打印时间差
        NSLog(@"%f", endTime - startTime);
    });
    
    
}

- (IBAction)updateData {
    // 1.获取更新的语句
    NSString *updateSQL = @"UPDATE t_student SET name = 'abc' WHERE score = 100;";
    
    // 2.执行语句
    [[SQLiteManager shareIntance] execSQLWithSQL:updateSQL];
}

- (IBAction)deleteData {
    // 1.获取删除语句
    NSString *deleteSQL = @"DELETE FROM t_student;";
    
    // 2.执行语句
    [[SQLiteManager shareIntance] execSQLWithSQL:deleteSQL];
}

- (IBAction)queryData {
    
    self.queryStus = [Student loadStudentData:self.page];
    
    // 4.遍历学生类
    for (Student *stu in self.queryStus) {
        NSLog(@"%@", stu.name);
    }
    
    self.page++;
}

#pragma mark - 懒加载属性
- (NSMutableArray *)students {
    if (_students == nil) {
        _students = [NSMutableArray array];
        
        for (int i = 0; i < 1000; i++) {
            Student *stu = [[Student alloc] init];
            stu.name = [NSString stringWithFormat:@"kent%d", arc4random_uniform(1000)];
            stu.age = arc4random_uniform(10) + 10;
            stu.score = 1 + arc4random_uniform(100);
            
            [_students addObject:stu];
        }
    }
    
    return _students;
}


@end
