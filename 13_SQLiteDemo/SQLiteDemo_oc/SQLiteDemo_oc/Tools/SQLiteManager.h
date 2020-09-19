//
//  SQLiteManager.h
//  SQLiteDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SQLiteManager : NSObject

/** 获取单例对象 */
+ (instancetype)shareIntance;


/** 打开数据库 */
- (BOOL)openDB;

/** 创建表 */
- (BOOL)execSQLWithSQL:(NSString *)sqlString;


/** 数据查询 */
- (NSArray *)querySQLWithSQL:(NSString *)sqlString;

#pragma mark - 事务操作
- (void)beiginTransation;
- (void)commitTransation;
- (void)rollbackTransation;

@end

NS_ASSUME_NONNULL_END
