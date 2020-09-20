//
//  Student+CoreDataProperties.h
//  CoreDataDemo_oc
//
//  Created by sunke on 2020/9/20.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "Student+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)
+ (NSFetchRequest<Student *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nonatomic) int16_t height;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t number;
@property (nullable, nonatomic, copy) NSString *sex;

@end

NS_ASSUME_NONNULL_END
