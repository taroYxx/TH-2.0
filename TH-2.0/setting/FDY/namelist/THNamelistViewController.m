//
//  THNamelistViewController.m
//  TH-2.0
//
//  Created by Taro on 16/3/22.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THNamelistViewController.h"
#import "THMessage.h"


@interface THNamelistViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic , weak) UITableView * tableview;

@end

@implementation THNamelistViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, 0,screenW-100, screenW-10);
    [self.view addSubview:tableView];
    self.tableview = tableView;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.studentModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    THMessage *student = self.studentModel[indexPath.row];
    
    
    cell.textLabel.text = student.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld次",student.records.count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate sendValue:indexPath.row];
}



@end
