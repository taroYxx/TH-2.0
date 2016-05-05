//
//  THRepairViewController.m
//  TH-2.0
//
//  Created by Taro on 16/2/28.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THRepairViewController.h"
#import "THStudent.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUD+YXX.h"
#import "THNextViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <FMDB/FMDatabase.h>

@interface THRepairViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) UIButton * subBtn;
@property (nonatomic , strong) NSArray * subData;
@property (nonatomic , strong) NSArray * tableViewData;
@property (nonatomic , strong) NSArray * allSet;
@property (nonatomic , strong) FMDatabase * db;


@end

@implementation THRepairViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    NSMutableSet *arriveSet = [NSMutableSet set];
    NSMutableSet *leaveSet = [NSMutableSet set];
    NSMutableSet *laterSet = [NSMutableSet set];
    NSMutableSet *absenceSet = [NSMutableSet set];
    self.subData = @[arriveSet,leaveSet,laterSet,absenceSet];
    [self.tableView.mj_header beginRefreshing];
    [self addTitleView];
    [self addtableView];
    [self addSubmitBtn];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)addTitleView{
    UILabel *titleOfClass = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenW, 43)];
    titleOfClass.text = self.Navtitle;
    [titleOfClass setTextAlignment:NSTextAlignmentCenter];
    titleOfClass.backgroundColor = YColor(228, 228, 228, 1);
    [self.view addSubview:titleOfClass];
}

- (void)addSubmitBtn{
    UIButton *subBtn = [[UIButton alloc] init];
    [subBtn setTitle:@"提交" forState:UIControlStateNormal];
    subBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    self.subBtn = subBtn;
    self.subBtn.layer.cornerRadius = 30.0;
    self.subBtn.layer.borderWidth = 1.0;
    self.subBtn.layer.borderColor =[UIColor clearColor].CGColor;
    self.subBtn.clipsToBounds = TRUE;
    [self.view addSubview:self.subBtn];
    [self.subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@60);
        make.width.mas_equalTo(@60);
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(-64);
    }];
    [self.subBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addtableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64+43, screenW, screenH-64-43)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)loadNewData{
    [self getDataFromServers:^(NSMutableArray *array) {
        
//        NSMutableArray *mutableArray = [NSMutableArray array];
//        for (NSDictionary *dict in array) {
//            THStudent *student = [[THStudent alloc] initWithDic:dict];
//            [mutableArray addObject:student];
//        }
        self.tableViewData = [self tableDataToRangWith:array];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSArray *)tableDataToRangWith: (NSArray *)array{
    NSArray *mutableArray = [NSArray array];
    NSMutableArray *absence = [NSMutableArray array];
    NSMutableArray *leave = [NSMutableArray array];
    NSMutableArray *late = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        THStudent *student = [[THStudent alloc] initWithDic:dict];
        switch ([student.state integerValue]) {
            case 0:
                [absence addObject:student];
                break;
            case 1:
                [leave addObject:student];
                break;
            case 2:
                [late addObject:student];
                break;
                
            default:
                break;
        }
    }
//   mutableArray = @[absence,leave,late];
    mutableArray = absence;
    mutableArray = [mutableArray arrayByAddingObjectsFromArray:leave];
    mutableArray = [mutableArray arrayByAddingObjectsFromArray:late];
    
//    NSMutableArray *result = [NSMutableArray array];
//    for (NSArray *subarray in mutableArray) {
//        for (THStudent *perST in subarray) {
//            [result addObject:perST];
//        }
//    }
    
   
    
    return mutableArray;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackArrow"]];
        icon.frame = CGRectMake(screenW-10-20, (cell.frame.size.height-15)/2, 10, 15);
        cell.accessoryView = icon;
    }
    THStudent *student = self.tableViewData[indexPath.row];
    cell.textLabel.text = student.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",student.studentNo];
    if ([student.state integerValue]== 0) {
        cell.imageView.image = [UIImage imageNamed:@"red_status"];
    }else if ([student.state integerValue] == 1){
        cell.imageView.image = [UIImage imageNamed:@"blue_status"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"yellow_status"];
    }
    
    cell.imageView.frame = CGRectMake(0, 0, screenW - cell.imageView.image.size.width, cell.imageView.image.size.height);
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
//     THStudent *student = self.tableViewData[indexPath.row];
//    if ([student.state integerValue]== 0) {
//        cell.imageView.image = [UIImage imageNamed:@"red_status"];
//    }else if ([student.state integerValue] == 1){
//        cell.imageView.image = [UIImage imageNamed:@"blue_status"];
//    }else{
//        cell.imageView.image = [UIImage imageNamed:@"yellow_status"];
//    }
//
//}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    THStudent *student = self.tableViewData[indexPath.row];
    UITableViewRowAction *arrive = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"已到" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        cell.imageView.image = [UIImage imageNamed:@"green_status"];
        [tableView setEditing:NO];
        [self.subData[0] addObject:student.studentId];
        [self.subData[1] removeObject:student.studentId];
        [self.subData[2] removeObject:student.studentId];
        [self.subData[3] removeObject:student.studentId];
        
    }];
    arrive.backgroundColor = YColor(79, 220, 101, 1);
    UITableViewRowAction *leave = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"请假" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        cell.imageView.image = [UIImage imageNamed:@"blue_status"];
        [tableView setEditing:NO];
        [self.subData[0] removeObject:student.studentId];
        [self.subData[1] addObject:student.studentId];
        [self.subData[2] removeObject:student.studentId];
        [self.subData[3] removeObject:student.studentId];
       
    }];
    leave.backgroundColor = YColor(58, 185, 218, 1);
    UITableViewRowAction *later = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"迟到" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        cell.imageView.image = [UIImage imageNamed:@"yellow_status"];
        [tableView setEditing:NO];
        [self.subData[0] removeObject:student.studentId];
        [self.subData[1] removeObject:student.studentId];
        [self.subData[2] addObject:student.studentId];
        [self.subData[3] removeObject:student.studentId];
        
    }];
    later.backgroundColor = YColor(254, 204, 43, 1);
    UITableViewRowAction *cancel = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"缺席" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        cell.imageView.image = [UIImage imageNamed:@"red_status"];
        [tableView setEditing:NO];
        [self.subData[0] removeObject:student.studentId];
        [self.subData[1] removeObject:student.studentId];
        [self.subData[2] removeObject:student.studentId];
        [self.subData[3] addObject:student.studentId];
    }];
    cancel.backgroundColor = YColor(207, 85, 89, 1);
//    cell.backgroundColor = YColor(228, 228, 228, 1);
    
    return @[cancel,later,leave,arrive];
}

- (void)getDataFromServers:(void(^)(NSMutableArray  * array))success{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSDictionary *requestData = @{
                                  @"courseId" : _courseId,
                                  @"weekOrdinal" : _weekOrdinal
                                  };
    NSString *url = [NSString stringWithFormat:@"%@/%@/special_offer/",host,version];
    [manager POST:url parameters:requestData success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSMutableArray *array = responseObject[@"class"];
//        THLog(@"%@",array);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(array);
            }
        }];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
    }];
}

//提交事件
- (void)submit{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSMutableArray *mutarray = [NSMutableArray array];
    for (int i = 0; i < self.subData.count; i++) {
        NSArray *array = [self.subData[i] allObjects];
        [mutarray addObject:array];
    }
    NSDictionary *dict = @{
                           @"courseId" : self.courseId,
                           @"weekOrdinal" : self.weekOrdinal,
                           @"studentIdForMiss" :mutarray[3],
                           @"studentIdForLeave" :mutarray[1],
                           @"studentIdForLate" :mutarray[2],
                           @"studentIdForArrive" : mutarray[0]
                           
                           };
    THLog(@"%@",dict);
    NSString *url = [NSString stringWithFormat:@"%@/%@/record_again/",host,version];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        THLog(@"%@",responseObject);
        NSNumber *status = responseObject[@"status"];
        if ([status integerValue] == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交成功！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [self.tableView.mj_header beginRefreshing];
                NSString *path =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"student.sqlite"];
                self.db = [FMDatabase databaseWithPath:path];
                [self.db open];
                NSArray *arrive = mutarray[0];
                for (NSNumber *number in arrive) {
                   [_db executeUpdate:[NSString stringWithFormat:@"UPDATE class_%@ SET absence = 0,leave = 0,arrive = 1,later=0 WHERE studentId = %@;",self.courseId,number]];
                }
                NSArray *leave = mutarray[1];
                for (NSNumber *number in leave) {
                   [_db executeUpdate:[NSString stringWithFormat:@"UPDATE class_%@ SET absence = 0,leave = 1,later = 0, arrive = 0 WHERE studentId = %@;",self.courseId,number]];
                }
                NSArray *later = mutarray[2];
                for (NSNumber *number in later) {
                   [_db executeUpdate:[NSString stringWithFormat:@"UPDATE class_%@ SET absence = 0,leave = 0,later =1, arrive = 0 WHERE studentId = %@;",self.courseId,number]];
                }
            }];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"提交不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alertView show];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请确定网络是否连接" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    }];
}


@end
