//
//  User.m
//  FMDBDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "User.h"
#import "FMDBTool.h"


@implementation User

- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    [super setValuesForKeysWithDictionary:keyedValues];
    self.detail = [Detail dict:keyedValues];
}

+ (void)initialize {
    [self createTable];
}

+ (void)createTable {
    [FMDBTool excuteStatements:@[@"CREATE TABLE IF NOT EXISTS t_user(id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL)", @"CREATE TABLE IF NOT EXISTS t_detail(id integer PRIMARY KEY AUTOINCREMENT, text text, created_at text, user_id integer, CONSTRAINT fk_detail_ref_user FOREIGN KEY (user_id) REFERENCES t_user (id))"]];
}

- (void)insert {
    // 1.查询数据库中是否有对应用户的数据
    NSString *sql = [NSString stringWithFormat:@"SELECT id FROM t_user WHERE name ='%@'", self.name];
    NSArray *columnNames = @[@"id"];
    NSArray *resultArray = [FMDBTool queryWithSql:sql columnNames:columnNames];
    
    // 2.如果有则插入详情数据
    int userId = [resultArray.firstObject[columnNames.firstObject] intValue];
    if (userId) {
        [self.detail insertWithUserId:userId];
    } else {
        // 3.如果没有则插入用户的数据
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_user(name) VALUES ('%@')", self.name];
        [FMDBTool execute:sql];
        
        // 4.递归
        [self insert];
    }
}

+ (NSArray *)fetchDatasource {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_user tu, t_detail WHERE tu.id = user_id"];
    NSArray *columnNames = @[@"name", @"text", @"created_at"];
    NSArray *resultArray = [FMDBTool queryWithSql:sql columnNames:columnNames];
    NSMutableArray *datasource = [NSMutableArray array];
    for (NSDictionary *dict in resultArray) {
        
        [datasource addObject:[self dict:dict]];
    }
    return datasource;
}

@end
