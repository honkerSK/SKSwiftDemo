//
//  FMDBTool.m
//  FMDBDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "FMDBTool.h"
#import "FMDB.h"

@implementation FMDBTool

static FMDatabase *_db;

+ (void)load {
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"demo.sqlite"];
    NSLog(@"%@", filePath);
    _db = [FMDatabase databaseWithPath:filePath];
    if ([_db open]) {
        NSLog(@"数据库打开成功");
    }
}

+ (void)execute:(NSString *)sql {
    if ([_db executeUpdate:sql]) {
        NSLog(@"sql语句执行成功");
    }
}

+ (NSArray *)queryWithSql:(NSString *)sql columnNames:(NSArray *)columnNames {
    FMResultSet *resultSet = [_db executeQuery:sql];
    NSMutableArray *arrayM = [NSMutableArray array];
    while ([resultSet next]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *columnName in columnNames) {
           id value = [resultSet objectForColumnName:columnName];
            dict[columnName] = value;
        }
        [arrayM addObject:dict];
    }
    return arrayM;
}


+ (void)excuteStatements:(NSArray *)sqls {
    NSMutableString *strM = [[NSMutableString alloc] init];
    for (NSString *sql in sqls) {
        [strM appendString:sql];
        [strM appendString:@";"];
    }
    
    if ([_db executeStatements:strM]) {
        NSLog(@"执行多条sql语句成功");
    }
}

@end
