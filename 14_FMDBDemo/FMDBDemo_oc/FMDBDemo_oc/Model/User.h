//
//  User.h
//  FMDBDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Detail.h"
#import "Modes.h"
NS_ASSUME_NONNULL_BEGIN

@interface User : Modes

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Detail *detail;
- (void)insert;
+ (NSArray *)fetchDatasource;

@end

NS_ASSUME_NONNULL_END
