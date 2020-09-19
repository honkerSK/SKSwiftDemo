//
//  Detail.m
//  FMDBDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "Detail.h"
#import "FMDBTool.h"


@implementation Detail

- (void)insertWithUserId:(int)userId {
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO t_detail (text, created_at, user_id) VALUES ('%@', '%@', '%d')", self.text, self.created_at, userId];
    [FMDBTool execute:sql];
}

- (void)deleteContent {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_detail WHERE created_at = '%@'", self.created_at];
    [FMDBTool execute:sql];
}


@end
