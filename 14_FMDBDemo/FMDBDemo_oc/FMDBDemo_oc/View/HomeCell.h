//
//  HomeCell.h
//  FMDBDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

NS_ASSUME_NONNULL_BEGIN

@interface HomeCell : UITableViewCell
@property (nonatomic, strong) User *user;

@end

NS_ASSUME_NONNULL_END
