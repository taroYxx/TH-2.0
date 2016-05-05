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
#import "THPresentTableViewController.h"
#import <MJPopupViewController/UIViewController+MJPopupViewController.h>
#import "THHomeworkRecord.h"



@interface THHomeworkViewController ()<UITableViewDataSource,UITableViewDelegate,THPresentDelegate>
@property (nonatomic , weak) UISegmentedControl* segment;
//@property (nonatomic , weak) UIButton * button;
@property (nonatomic , strong) NSMutableArray * model;
@property (nonatomic , weak) UIButton * btn;
@property (nonatomic , strong) NSArray * weekArray;
@property (nonatomic , strong) NSArray * recordModel;
@property (nonatomic , strong) NSNumber * homeworkRecordId;
@property (nonatomic , weak) UILabel * fenshu;
@property (nonatomic , weak) UILabel * name;


@end

@implementation THHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [NSMutableArray array];
  
    [self addTitleView];
    [self addTableViewTo];
    [self getWeekFromServers:^(NSArray *array) {
      
        if (array.count > 0) {
            NSMutableArray *mutaleArray = [NSMutableArray array];
            for (NSDictionary *dict in array) {
                THHomeworkRecord *record = [THHomeworkRecord homeworkRecordWithDic:dict];
                [mutaleArray addObject:record];
            }
            self.recordModel = mutaleArray;
            UIButton *btn = [[UIButton alloc] init];
            btn.backgroundColor = YColor(207, 85, 89, 1);
            btn.frame = CGRectMake(screenW-screenW/5, 64, screenW/5, 43);
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [self.view addSubview:btn];
            [btn addTarget:self action:@selector(chooseWeek) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setTitle:@"选择作业" forState:UIControlStateNormal];
            self.btn = btn;
            
            
//            self.weekArray = week;
//            self.weekNumber = week[week.count-1];
            
            
            
            
        }
        else{
            UILabel *label = [[UILabel alloc] init];
            label.text = @"无作业信息";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:18];
            [self.view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.centerY.equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(200, 200));
            }];

        }
        
     
        
        
//        NSArray *week = dict[@"weekList"];
//                if (week.count > 0) {
//                    UIButton *btn = [[UIButton alloc] init];
//                    btn.backgroundColor = YColor(207, 85, 89, 1);
//                    btn.frame = CGRectMake(screenW-screenW/5, 64, screenW/5, 43);
//                    [self.view addSubview:btn];
//                    [btn addTarget:self action:@selector(chooseWeek) forControlEvents:UIControlEventTouchUpInside];
//                    NSString *string = [NSString stringWithFormat:@"第%@周",week[week.count-1]];
//                    [btn setTitle:string forState:UIControlStateNormal];
//                    self.btn = btn;
//                    self.weekArray = week;
//                    self.weekNumber = week[week.count-1];
//                    [self getDataFromServe:^(NSArray *array) {
//                        NSMutableArray *mutableArray = [NSMutableArray array];
//                        for (NSDictionary *dict in array) {
//                            THscores *scores = [THscores scoresWithDic:dict];
//                            [mutableArray addObject:scores];
//                            
//                        }
//                        self.model = mutableArray;
//                        [self.tableView reloadData];
//                    }];
//                }else{
//                    UILabel *label = [[UILabel alloc] init];
//                    label.text = @"无作业信息";
//                    label.textAlignment = NSTextAlignmentCenter;
//                    label.textColor = [UIColor grayColor];
//                    label.font = [UIFont systemFontOfSize:18];
//                    [self.view addSubview:label];
//                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.centerX.equalTo(self.view);
//                        make.centerY.equalTo(self.view);
//                        make.size.mas_equalTo(CGSizeMake(200, 200));
//                    }];
//                }

    }];

//    [self getDataFromServe:^(NSArray *array) {
//        
//        for (NSDictionary *dict in array) {
//            THscores *scores = [THscores scoresWithDic:dict];
//            [self.model addObject:scores];
//            
//        }
////        THLog(@"%@",self.model);
//        [self addTableViewTo];
//    }];
    
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(chooseWeek)];
//    self.navigationItem.rightBarButtonItem = rightBtn;

 }

- (void)addTitleView{
    UILabel *titleOfClass = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenW, 43)];
    titleOfClass.text = self.courseName;
    [titleOfClass setTextAlignment:NSTextAlignmentCenter];
    titleOfClass.backgroundColor = YColor(228, 228, 228, 1);
    [self.view addSubview:titleOfClass];
    
    
}
- (void)chooseWeek{
    NSMutableArray *mutalArray = [NSMutableArray array];
    for (THHomeworkRecord *record in self.recordModel) {
        NSString *title = [NSString stringWithFormat:@"第%@周",record.homeworkRecordWeek];
        [mutalArray addObject:title];
    }
//
//    
//    for (NSNumber *number in self.weekArray) {
//        NSString *string = [NSString stringWithFormat:@"第%@周",number];
//        [mutalArray addObject:string];
//    }

    THPresentTableViewController *present = [[THPresentTableViewController alloc] init];
    present.tableViewData = mutalArray;
    present.view.frame = CGRectMake(0, 0, screenW-100, screenW-10);
    present.delegate = self;
    [self presentPopupViewController:present animationType:MJPopupViewAnimationFade];

}


- (void)addTableViewTo{
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+43, screenW, screenH-64-43)];
    self.tableView = tableview;
//    self.tableView.backgroundColor = [UIColor redColor];
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
        self.name = name;
        UILabel *fenshu = [[UILabel alloc] initWithFrame:CGRectMake(screenW - 44, 0, 44, 44)];
        [cell addSubview:fenshu];
        self.fenshu = fenshu;
        
    }
    self.name.text = scores.studentName;
    self.fenshu.text = [NSString stringWithFormat:@"%@分",scores.score];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",scores.studentNo];


    return cell;
}

- (void)getDataFromServe:(void(^)( NSArray *array))success{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/%@/getHomeworksByHomeworkRecordId/",host,version];
//    THLog(@"self.week%@--%@",self.weekNumber,self.courseId);
    THLog(@"id%@",self.homeworkRecordId);
    if (self.homeworkRecordId) {
        NSDictionary *body = @{
                               @"homeworkRecordId":self.homeworkRecordId
                               };
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:url parameters:body success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            THLog(@"re%@",responseObject);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSArray *result = responseObject[@"homeworkScores"];
                if (success) {
                    success(result);
                }
            }];
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            THLog(@"%@",error);
        }];
    }else{
        
    }
   
    
    
}

- (void)getWeekFromServers:(void(^)(NSArray  * array))success{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSDictionary *requestData = @{
                                  @"courseId" : self.courseId,
                                  };
    NSString *url = [NSString stringWithFormat:@"%@/%@/listHomewordRecordByCourseId/",host,version];
//    manager.requestSerializer. = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url parameters:requestData success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *array = responseObject;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(array);
            }
        }];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
    }];
}

- (void)PresentsendValue:(NSUInteger)number{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
//    self.weekNumber = self.weekArray[number];
    
    THHomeworkRecord *record = self.recordModel[number];
    self.homeworkRecordId = record.homeworkRecordId;
    [self.btn setTitle:[NSString stringWithFormat:@"第%@周",record.homeworkRecordWeek] forState:UIControlStateNormal];
    [self getDataFromServe:^(NSArray *array) {
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            THscores *scores = [THscores scoresWithDic:dict];
            [mutableArray addObject:scores];
            
        }
        self.model = mutableArray;
        [self.tableView reloadData];
    }];

}


@end
