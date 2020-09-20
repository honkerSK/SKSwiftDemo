//
//  ViewController.m
//  FMDBDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import "ViewController.h"
#import "HttpTool.h"
#import "User.h"
#import "HomeCell.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation ViewController


#pragma mark - 懒加载
- (NSMutableArray *)datasource {
    if (_datasource == nil) {
        _datasource = [[NSMutableArray alloc] init];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 从缓存获取数据
    NSArray *array = [User fetchDatasource];
    if (array.count > 0) {
        
        [self.datasource addObjectsFromArray:array];
        NSLog(@"从缓存加载数据");
        return;
    }
    
    // 网络加载数据
    NSLog(@"从网络加载数据");
    [HttpTool loadRequestWithUrlString:@"http://api.budejie.com/api/api_open.php?a=list&c=data&type=29" resultData:^(NSDictionary *resultData) {
        NSArray *dictArray = resultData[@"list"];
        for (NSDictionary *dict in dictArray) {
            User *user = [User dict:dict];
            [self.datasource addObject:user];
            [user insert];
        }
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"HomeCell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.user = self.datasource[indexPath.row];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return [[self.datasource[indexPath.row] detail].text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height + 87;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        User *user = self.datasource[indexPath.row];
        [self.datasource removeObject:user];
        [tableView reloadData];
    }
}


@end
