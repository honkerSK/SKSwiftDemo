//
//  Student.m
//  SQLiteDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "Student.h"
#import "SQLiteManager.h"

@implementation Student

- (void)insertIntoDB {
    // 1.获取sql语句
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO t_student (name, age, score) VALUES ('%@', %d, %f)", self.name, self.age, self.score];
    
    // 2.执行语句
    BOOL flag = [[SQLiteManager shareIntance] execSQLWithSQL:insertSQL];
    if (flag) {
        NSLog(@"插入数据成功");
    } else {
        NSLog(@"插入数据失败");
    }
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (NSArray *)loadStudentData:(NSInteger)page {
    // 1.获取查询语句
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM t_student LIMIT %ld, 3;", page * 3];
    
    // 2.查询内容
    NSArray *stuDicts = [[SQLiteManager shareIntance] querySQLWithSQL:querySQL];
    
    // 3.遍历数组中的内容
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in stuDicts) {
        [tempArray addObject:[Student studentWithDict:dict]];
    }
    
    return tempArray;
}

+ (instancetype)studentWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}


@end
