//
//  Detail.h
//  FMDBDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Modes.h"

NS_ASSUME_NONNULL_BEGIN

@interface Detail : Modes
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *created_at;
- (void)insertWithUserId:(int)userId;
- (void)deleteContent;
@end

NS_ASSUME_NONNULL_END
