//
//  THHomeworkViewController.m
//  TH
//
//  Created by Taro on 15/12/3.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import "THHomeworkViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "THscores.h"



@interface THHomeworkViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , weak) UISegmentedControl* segment;
@property (nonatomic , strong) NSMutableArray * model;
@property (nonatomic , weak) UITableView * tableView;

@end

@implementation THHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [NSMutableArray array];

    self.view.backgroundColor = [UIColor whiteColor];
   

    [self getDataFromServe:^(NSArray *array) {
        
        for (NSDictionary *dict in array) {
            THscores *scores = [THscores scoresWithDic:dict];
            [self.model addObject:scores];
            
        }
        THLog(@"%@",self.model);
        [self addTableViewTo];
    }];
    
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(chooseWeek)];
//    self.navigationItem.rightBarButtonItem = rightBtn;

 }



- (void)addTableViewTo{
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH-64-43)];
    self.tableView = tableview;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    THscores *scores = self.model[indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(screenW/3, 0, screenW/3, cell.frame.size.height)];
        [cell addSubview:name];
        name.text = scores.name;
        UILabel *fenshu = [[UILabel alloc] initWithFrame:CGRectMake(screenW - 44, 0, 44, 44)];
        fenshu.text = [NSString stringWithFormat:@"%@分",scores.score];
        [cell addSubview:fenshu];
        
        
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@",scores.studentNo];


    return cell;
}

- (void)getDataFromServe:(void(^)( NSArray *array))success{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/%@/get_scores/",host,version];

    NSDictionary *body = @{
                               @"courseId" : self.courseId
                               };
    [manager POST:url parameters:body success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSArray *result = responseObject[@"scores"];
            if (success) {
                success(result);
            }
        }];

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
    }];
    
    
}


@end
