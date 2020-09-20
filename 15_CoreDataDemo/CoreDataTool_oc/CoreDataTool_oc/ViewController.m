//
//  ViewController.m
//  CoreDataTool_oc
//
//  Created by sunke on 2020/9/20.
//  Copyright © 2020 KentSun. All rights reserved.
//

/*
 multiple commands produce 问题
 
 Xcode 8 adds support for automatic Core Data subclass generation, which you can read about in the document What's New in Core Data in macOS 10.12, iOS 10.0, tvOS 10.0, and watchOS 3.0. New projects have automatic code generation turned on so when you created NSManagedObject subclasses manually, you created duplicates, which is causing the compiler error.

 There are two ways to fix this. First, you could remove the NSManagedObject subclasses you manually created. Second you can turn off automatic code generation for your data model from the Data Model inspector by choosing Manual/None from the Codegen menu. If you're following a tutorial, I recommend the second option because the tutorial was most likely written before Apple added automatic Core Data subclass generation.
 */


#import "ViewController.h"
#import "CoreDataTool.h"
#import "People+CoreDataProperties.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)batchDeleteThan60 {
    
    NSPredicate *pre = [CoreDataTool predicateOfBigThan:60 forProperty:@"age"];
    [CoreDataTool batchDeleteEntity:@"People" predicate:pre result:^(NSError *error) {
        NSLog(@"error: %@", error.userInfo);
    }];
}
- (void)batchUpdateZLY {
    NSPredicate *pre = [CoreDataTool predicateOfMatch:@"赵丽颖" forProperty:@"name"];
    [CoreDataTool batchUpdateEntity:@"People" predicate:pre propertiesToUpdate:@{@"age": @20} result:^(NSError *error) {
        
        NSLog(@"已更新");
    }];
}
- (void)deleteAll {
    [CoreDataTool deleteEntity:@"People" predicate:nil result:^(NSArray *deletedObjs) {
        NSLog(@"已删除");
    }];
}
- (void)select50 {
    NSPredicate *pre = [CoreDataTool predicateOfSmallThan:50 forProperty:@"age"];
    [CoreDataTool fetchEntity:@"People" predicate:pre properties:nil sortKey:nil result:^(NSArray *info) {
        NSLog(@"*********** 查询 age 小于 50 **********");
        for (People *p in info) {
            NSLog(@"name: %@---age: %d", p.name, p.age);
        }
    }];
}
- (void)updateFBB {
    NSLog(@"*********** 更新 **********");
    NSPredicate *pre = [CoreDataTool predicateOfMatch:@"范冰冰" forProperty:@"name"];
    [CoreDataTool updateEntity:@"People" predicate:pre configNewObj:^(NSArray *objs) {
        for (People *p in objs) {
            p.name = @"哈哈哈";
            p.age = 100;
        }
    } result:^(NSError *error) {
        NSLog(@"%@", error.userInfo);
    }];
}
- (void)delete30 {
    NSLog(@"************** 删除年龄为 30 的 ***********");
    NSPredicate *pre = [CoreDataTool predicateOfEqual:30 forProperty:@"age"];
    [CoreDataTool deleteEntity:@"People" predicate:pre result:^(NSArray *deletedObjs) {
        for (People *p in deletedObjs) {
            NSLog(@"name: %@---age: %d", p.name, p.age);
        }
    }];
}
- (void)selectZLY {
    NSPredicate *pre = [CoreDataTool predicateOfMatch:@"赵丽颖" forProperty:@"name"];
    
    [CoreDataTool fetchEntity:@"People" predicate:pre properties:nil sortKey:nil result:^(NSArray *info) {
        NSLog(@"************* 查询赵丽颖 ************");
        for (People *p in info) {
            NSLog(@"name: %@---age: %d", p.name, p.age);
        }
    }];
}

- (void)selectAll {
    
    [CoreDataTool fetchEntity:@"People" predicate:nil properties:nil sortKey:nil result:^(NSArray *info) {
        
        for (People *p in info) {
            NSLog(@"name: %@---age: %d", p.name, p.age);
        }
    }];
}
- (void)insert {
    
    NSArray *names = @[@"夏侯惇", @"貂蝉", @"诸葛亮", @"张三", @"李四", @"流火绯瞳", @"流火", @"李白", @"张飞", @"韩信", @"范冰冰", @"赵丽颖"];
    
    for (int i = 0; i < 60; i++) {
        [CoreDataTool insertEntity:@"People" configData:^(NSManagedObject *obj) {
            
            People *entity = (People *)obj;
            entity.name = names[i%names.count];
            entity.age = arc4random() % 80 + 20;
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataSource = [NSMutableArray arrayWithObjects:@"插入新数据", @"查询所有数据", @"删除所有数据",  @"删除age为30的, 如果有的话", @"更新所有的范冰冰为 哈哈哈",@"查找age小于50", @"寻找赵丽颖", @"批量更新赵丽颖的年龄为28", @"批量删除age大于60的", nil];
    
    UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
//    CoreDataTool *d1 = [[CoreDataTool alloc]init];
//    CoreDataTool *d2 = [CoreDataTool shared];
//
//    NSLog(@"d1 == %@\nd2 == %@", d1, d2);
//    NSLog(@"%d",d1 == d2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"dell"];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            [self insert];
            break;
        case 1:
            [self selectAll];
            break;
            case 2:
            [self deleteAll];
            break;
            case 3:
            [self delete30];
            break;
            case 4:
            [self updateFBB];
            break;
            case 5:
            [self select50];
            break;
            case 6:
            [self selectZLY];
            break;
            case 7:
            [self batchUpdateZLY];
            break;
            case 8:
            [self batchDeleteThan60];
            break;
        default:
            break;
    }
}


@end
