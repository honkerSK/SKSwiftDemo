//
//  HomeCell.m
//  FMDBDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "HomeCell.h"
#import "User.h"

@interface HomeCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation HomeCell

- (void)setUser:(User *)user {
    _user = user;
    self.nameLabel.text = user.name;
    self.timeLabel.text = user.detail.created_at;
    self.contentLabel.text = user.detail.text;
}
@end
