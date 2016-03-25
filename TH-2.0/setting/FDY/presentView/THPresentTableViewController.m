//
//  THPresentTableViewController.m
//  TH-2.0
//
//  Created by Taro on 16/3/24.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THPresentTableViewController.h"


@interface THPresentTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation THPresentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//       self.view.frame = CGRectMake(0, 0,screenW-100, screenW-10);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.tableViewData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@班",self.tableViewData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.delegate PresentsendValue:indexPath.row];
}

@end
