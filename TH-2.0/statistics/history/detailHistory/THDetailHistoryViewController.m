//
//  THDetailHistoryViewController.m
//  TH-2.0
//
//  Created by Taro on 16/3/5.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THDetailHistoryViewController.h"
#import "THStudent.h"


@interface THDetailHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , weak) UITableView * tableView;
@property (nonatomic , weak) UILabel * label;
@property (nonatomic , strong) NSArray * model;
@property (nonatomic , strong) NSNumber * studentId;


@end

@implementation THDetailHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self dataToModelWith:self.nameList];
    [self addTableView];
}

- (void)dataToModelWith :(NSArray *)array{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        THStudent *student = [THStudent studentWithDic:dict];
        [mutableArray addObject:student];
    }
    self.model = mutableArray;
}

- (void)addTableView{
    UILabel *titleOfClass = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenW, 43)];
    titleOfClass.text = self.courseName;
    [titleOfClass setTextAlignment:NSTextAlignmentCenter];
    titleOfClass.backgroundColor = YColor(228, 228, 228, 1);
    [self.view addSubview:titleOfClass];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 107, screenW, screenH-107)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nameList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        NSArray *array = @[[UIImage imageNamed:@"red_status"],[UIImage imageNamed:@"blue_status"],[UIImage imageNamed:@"yellow_status"],[UIImage imageNamed:@"green_status"]];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.imageView.image = array[self.icontag];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(screenW/2, 0, 100, cell.frame.size.height);
        [cell addSubview:label];
        self.label = label;
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    THStudent *student = self.model[indexPath.row];
    cell.textLabel.text = student.name;
    cell.detailTextLabel.text = student.major;
    self.label.text = [NSString stringWithFormat:@"%@",student.studentNo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    THStudent *student = self.model[indexPath.row];
    self.studentId = student.studentId;
    [self getDataFromServers:^(NSDictionary *dict) {
        NSArray *absence = dict[@"absenceArray"];
        NSArray *leave = dict[@"leaveArray"];
//        NSArray *absence = @[@1,@2,@3,@4,@5,@6];
//        NSArray *leave = @[@3,@4];
        NSArray *later = dict[@"lateArray"];
        NSArray *array = @[absence,leave,later];
        NSString *text = [NSString stringWithFormat:@"缺席: %lu次 请假: %lu次  迟到: %lu次\n\n",absence.count,leave.count,later.count];
        NSArray *statue = @[@"缺席:",@"请假:",@"迟到:"];
        for (int i = 0; i < 3; i++) {
            NSArray *statuArray = array[i];
            if (statuArray.count != 0) {
                NSString *statusString = statue[i];
                for (NSNumber *number in statuArray) {
                    NSString *string = [NSString stringWithFormat:@"第%@周 ",number];
                    statusString = [statusString stringByAppendingString:string];
                }
                text = [text stringByAppendingString:statusString];
                text = [text stringByAppendingString:@"\n"];
            }
            
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:cell.textLabel.text message:text delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
}

- (void)getDataFromServers:(void(^)(NSDictionary  * dict))success{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSDictionary *requestData = @{
                                  @"courseId" : self.courseId,
                                  @"studentId" : self.studentId
                                  };
    NSString *url = [NSString stringWithFormat:@"%@/%@/someonehistory/",host,version];
    [manager POST:url parameters:requestData success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = responseObject[@"history"];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(dict);
            }
        }];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
    }];
}

@end
