//
//  Student.h
//  SQLiteDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) double score;

- (void)insertIntoDB;
+ (NSArray *)loadStudentData:(NSInteger)page;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)studentWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
