//
//  StudentCell.h
//  CoreDataDemo_oc
//
//  Created by sunke on 2020/9/20.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Student+CoreDataClass.h"
#import "Student+CoreDataProperties.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN

@interface StudentCell : UITableViewCell

/** model */
@property(nonatomic, strong)Student *student;

@end

NS_ASSUME_NONNULL_END
