//
//  FMDBTool.h
//  FMDBDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMDBTool : NSObject

/**
 执行语句
 */
+ (void)execute:(NSString *)sql;


/**
 执行多条sql语句

 @param sqls sql语句数组
 */
+ (void)excuteStatements:(NSArray *)sqls;

/**
 查询数据

 @param sql sql语句
 @param columnNames 字段名数组
 @return 字典数组
 */
+ (NSArray *)queryWithSql:(NSString *)sql columnNames:(NSArray *)columnNames;

@end

NS_ASSUME_NONNULL_END
