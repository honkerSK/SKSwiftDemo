//
//  SQLiteManager.m
//  SQLiteDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "SQLiteManager.h"
#import <sqlite3.h>

@interface SQLiteManager ()

@property (assign, nonatomic) sqlite3 *db;

@end

@implementation SQLiteManager

static SQLiteManager *_instance;

+ (instancetype)shareIntance {
//    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SQLiteManager alloc] init];
    });
    
    return _instance;
}

#pragma mark - 打开数据库
- (BOOL)openDB {
    // 1.获取数据库的存储路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"mydb.sqlite"];

    NSLog(@"数据库路径 %@", path);
    // 2.创建数据库对象
    //打开数据库文件(如果数据库文件不存在,那么该函数会自动创建数据库文件)
    return sqlite3_open(path.UTF8String, &_db) == SQLITE_OK;
}

#pragma mark - 执行SQL语句
- (BOOL)execSQLWithSQL:(NSString *)sqlString {
    // 参数一:数据库对象
    // 参数二:执行的SQL语句
    return sqlite3_exec(self.db, sqlString.UTF8String, nil, nil, nil) == SQLITE_OK;
}


#pragma mark - 数据查询
- (NSArray *)querySQLWithSQL:(NSString *)sqlString {
    // 1.定义游标
    sqlite3_stmt *stmt;
    
    // 2.给游标赋值
    // 1> 参数一: 数据库对象
    // 2> 参数二: 查询语句
    // 3> 参数三: 查询语句的长度,填写-1则自动计算
    // 4> 游标的地址
    if (sqlite3_prepare_v2(self.db, sqlString.UTF8String, -1, &stmt, nil) != SQLITE_OK) {
        return nil;
    }
    
    // 3.查询一行数据
    // 3.1.获取行数
    int count = sqlite3_column_count(stmt);
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        // 3.1.遍历每一列
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (int i = 0; i < count; i++) {
            // 3.2.取出Key
            NSString *key = [NSString stringWithUTF8String:sqlite3_column_name(stmt, i)];
            
            // 3.3.获取值
            NSString *value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, i)];
            
            // 3.4.放入到字典中
            [dict setObject:value forKey:key];
        }
        
        [tempArray addObject:dict];
    }
    
    return tempArray;
}



- (void)beiginTransation {
    // 1.开启的sql
    NSString *beginSQL = @"BEGIN TRANSACTION;";
    
    // 2.执行SQL
    [self execSQLWithSQL:beginSQL];
}

- (void)commitTransation {
    // 1.提交的sql
    NSString *beginSQL = @"COMMIT TRANSACTION;";
    
    // 2.执行SQL
    [self execSQLWithSQL:beginSQL];
}

- (void)rollbackTransation {
    // 1.回滚的sql
    NSString *beginSQL = @"ROLLBACK TRANSACTION;";
    
    // 2.执行SQL
    [self execSQLWithSQL:beginSQL];
}

@end
