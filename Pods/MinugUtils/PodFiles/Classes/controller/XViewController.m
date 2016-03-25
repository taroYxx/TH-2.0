//
//  XViewController.m
//  ShoesSeller
//
//  Created by minug on 15/11/7.
//  Copyright © 2015年 minug. All rights reserved.
//

#import "XViewController.h"
#import "CommonBtnFooterView.h"

@implementation XViewController

-(void)viewDidLoad{
    [super viewDidLoad ];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(self.view);
        make.top.equalTo(@(navigationBarHeight));
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
}


-(void)setFootViewWithText:(NSString *)text margin:(CGFloat)margin{
    CommonBtnFooterView *footView = [[CommonBtnFooterView alloc] initWithTitle:text leftPad:margin];
    self.tableView.tableFooterView = footView;
    self.footView = footView;
    footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
}

-(void)configureInitCell:(UITableViewCell *)cell tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
