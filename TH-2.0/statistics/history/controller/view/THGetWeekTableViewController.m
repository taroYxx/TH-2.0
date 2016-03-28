//
//  THGetWeekTableViewController.m
//  TH-2.0
//
//  Created by Taro on 16/3/27.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THGetWeekTableViewController.h"

@interface THGetWeekTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation THGetWeekTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    THLog(@"asd%@",self.tableViewData);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%@周",self.tableViewData[indexPath.row]];
    
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *ID = @"cell";
//          THLog(@"asd%@",self.tableViewData);
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"第%@周",self.tableViewData[indexPath.row]];
//  
//    return cell;
//}



@end
