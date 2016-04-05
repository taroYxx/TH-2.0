//
//  THDetailViewController.m
//  TH-2.0
//
//  Created by Taro on 16/2/28.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THDetailViewController.h"
#import <FMDB/FMDatabase.h>
#import <XYPieChart/XYPieChart.h>
#import "THdetailStudent.h"
#import <MJRefresh/MJRefresh.h>


@interface THDetailViewController ()<XYPieChartDataSource,XYPieChartDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) FMDatabase * db;
@property (nonatomic , strong) XYPieChart * pieChart;
@property (nonatomic , weak) UITableView * tableView;
@property (nonatomic , strong) NSMutableArray * colorOfSlice;
@property (nonatomic , strong) NSMutableArray * nameOfSlice;
@property (nonatomic , strong) NSArray * iconArray;
@property (nonatomic , strong) UIImage * rightIcon;
@property (nonatomic , strong) NSNumber * studentId;
@property (nonatomic , strong) NSArray * labelArray;





@end

@implementation THDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *array = @[[UIImage imageNamed:@"red_status"],[UIImage imageNamed:@"blue_status"],[UIImage imageNamed:@"yellow_status"],[UIImage imageNamed:@"green_status"]];
    self.iconArray = array;
    self.rightIcon = array[0];
//    THLog(@"%@",self.weekOrdinal);
//    [self getDataFromDatabase];
    [self addXYpieChart];
    UILabel *lab1 = [[UILabel alloc] init];
    UILabel *lab2 = [[UILabel alloc] init];
    UILabel *lab3 = [[UILabel alloc] init];
    UILabel *lab4 = [[UILabel alloc] init];
    self.labelArray = @[lab1,lab2,lab3,lab4];
    [self addButton];

    [self addTableView];
       self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    [self.tableView.mj_header beginRefreshing];
}


- (void)loadNewData{
    [self getWeekhistoryFromServers:^(NSDictionary *dict) {
        NSDictionary *dictionary = dict[@"history"];
        NSArray *absenceModel = [self dictionaryToModelWithArray:dictionary[@"absence"]];
        NSArray *leaveModel = [self dictionaryToModelWithArray:dictionary[@"leave"]];
        NSArray *laterModel = [self dictionaryToModelWithArray:dictionary[@"late"]];
        NSArray *appearModel = [self dictionaryToModelWithArray:dictionary[@"appear"]];
        NSArray *tableViewData = @[absenceModel,leaveModel,laterModel,appearModel];
        NSNumber *absence = [self numberMutipilay:dict[@"absenceProportion"]];
        NSNumber *leave = [self numberMutipilay:dict[@"leaveProportion"]];
        NSNumber *late = [self numberMutipilay:dict[@"lateProportion"]];
        NSNumber *appear = [self numberMutipilay:dict[@"appearProportion"]];
        self.slices = @[absence,leave,late,appear];
        self.totalModel = tableViewData;
        self.tableviewData = [self.totalModel objectAtIndex:0];
        [self.tableView reloadData];
        [self.pieChart reloadData];
        for (int i = 0; i < 4; i++) {
            NSArray *ary = [self.totalModel objectAtIndex:i];
            UILabel *label = [self.labelArray objectAtIndex:i];
            label.text = [NSString stringWithFormat:@"%ld",ary.count];
        }
        
        [self.tableView.mj_header endRefreshing];
    }];

}

//UI布局



- (void)addXYpieChart{
    UILabel *titleOfClass = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenW, 43)];
    titleOfClass.text = self.Navtitle;
    [titleOfClass setTextAlignment:NSTextAlignmentCenter];
    titleOfClass.backgroundColor = YColor(228, 228, 228, 1);
    [self.view addSubview:titleOfClass];
    self.pieChart = [[XYPieChart alloc] init];
    self.pieChart.delegate = self;
    self.pieChart.dataSource = self;
    [self.pieChart setStartPieAngle:M_PI];
    [self.pieChart setAnimationSpeed:1.0];
    CGFloat R  = (screenH/2-64-43)/2-5;
    [self.pieChart setPieRadius:R];//饼图半径
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:20]];
    [self.pieChart setLabelRadius:R-20];//数据标签出现的位置
    [self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChart setPieCenter:CGPointMake(screenW/2, screenH/2-R)];
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];
//    [self.pieChart setShouldGroupAccessibilityChildren:YES];
//    [self.pieChart setShowLabel:YES];
    
    
        [self.pieChart setShowPercentage:NO];
    self.nameOfSlice = [NSMutableArray arrayWithObjects:@"缺席",@"请假",@"迟到",@"已到",nil];
    self.colorOfSlice =[NSMutableArray arrayWithObjects:
                        YColor(208, 85, 90, 2),
                        YColor(64, 186, 217, 1),
                        YColor(255, 204, 43, 1),
                        YColor(85, 219, 105, 1),
                        nil];
 
// 饼图的数据处理
//    NSMutableArray *everycount = [NSMutableArray array];
//    float sum = 0.000;
//    for (int i = 0; i < self.totalModel.count; i++) {
//        NSArray *array = self.totalModel[i];
//        NSInteger arraycount = array.count;
////        [everycount addObject:[NSNumber numberWithInteger:arraycount]];
//        sum = sum + arraycount;
//    }
//    NSMutableArray *everypercent = [NSMutableArray array];
//    for (int a = 0; a < 4; a ++) {
//        NSNumber *statusPercent = @([[everycount objectAtIndex:a]floatValue] / sum * 360);
////        THLog(@"%@",statusPercent);
//        [everypercent addObject:statusPercent];
//    }
//    self.slices = everypercent;
    [self.pieChart reloadData];
    [self.view addSubview:self.pieChart];
    
}


- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] integerValue];
}
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.colorOfSlice objectAtIndex:(index % self.colorOfSlice.count)];
}
- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index{

    NSNumber *number = [self.slices objectAtIndex:index];
    
    return [NSString stringWithFormat:@"%0.1f %%", number.floatValue / 360 * 100];
}

- (void)addButton{
    NSArray *bgViewName = @[@"re",@"blu",@"yel",@"gre"];
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = i;
        button.frame = CGRectMake(screenW/4 * i,screenH/2+5, screenW/4, 44);
        button.backgroundColor = YColor(226, 226, 226, 1);
        [button setTitle:self.nameOfSlice[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(transitTableView:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgViewName[i]]];
        imageview.frame = CGRectMake(screenW/4 * 2/3+5, 13, 20, 20);
        [button addSubview:imageview];
        UILabel *lable = [self.labelArray objectAtIndex:i];
        lable.frame = CGRectMake(screenW/4 * 2/3, 0, screenW/4 * 1/3, 44);
        lable.font = [UIFont systemFontOfSize:12.0];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        [button addSubview:lable];
        
   
    }
    for (int i = 1; i < 4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(screenW/4*i,screenH/2+5, 2, 40)];
        view.backgroundColor = YColor(165, 165, 165, 1);
        [self.view addSubview:view];
    }
    
}



- (void)transitTableView:(UIButton *)btn{
    self.tableviewData = [self.totalModel objectAtIndex:btn.tag];
    self.rightIcon = [self.iconArray objectAtIndex:btn.tag];

    [self.tableView reloadData];
}


- (void)addTableView{
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, screenH/2+47, screenW, screenH-screenH/2-2-44)];
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableView = tableview;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableviewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    THdetailStudent *student = self.tableviewData[indexPath.row];
    cell.textLabel.text = student.name;
//    self.studentId = student.studentId;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",student.studentNo];
    UIImageView *icon = [[UIImageView alloc] init];
    icon.frame = CGRectMake(screenW-10-30, (cell.frame.size.height-30)/2, 30, 30);

    icon.image = self.rightIcon;
     cell.accessoryView = icon;
    return cell;
}

//从数据获取数据
- (void)getDataFromDatabase{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"student.sqlite"];
    self.db = [[FMDatabase alloc] initWithPath:path];
    [_db open];
    NSArray *statusTitle = @[@"absence",@"leave",@"later",@"arrive"];
 
    NSMutableArray *totalModel = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        NSArray *status = [NSArray array];
        status = [self getStatusModelarrayFrom:[statusTitle objectAtIndex:i]];
        [totalModel addObject:status];
    }
//    self.totalModel = totalModel;
//    self.tableviewData = totalModel[0];
    self.rightIcon = self.iconArray[0];
//    THLog(@"%@",totalModel);
    [self.db close];
}

- (NSArray *)getStatusModelarrayFrom :(NSString *)status{
    NSMutableArray *model = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM class_%@ WHERE %@ = 1 AND week = %@",self.courseId,status,self.weekOrdinal];
    FMResultSet *set = [self.db executeQuery:sql];
    while ([set next]) {
        NSString *studentId = [set stringForColumn:@"studentId"];
        NSString *studentName = [set stringForColumn:@"studentName"];
        NSString *lateTime = [set stringForColumn:@"lateTimes"];
        NSString *arrive = [set stringForColumn:@"arrive"];
        NSString *studentNo = [set stringForColumn:@"studentNo"];
        NSDictionary *dict = @{
                               @"studentId" : studentId,
                               @"studentName" : studentName,
                               @"lateTime" :lateTime,
                               @"arrive" : arrive,
                               @"studentNo" : studentNo
                               };
        THdetailStudent *student = [THdetailStudent detailWithDic:dict];
        [model addObject:student];
    }
    return model;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    THdetailStudent *student = self.tableviewData[indexPath.row];
    self.studentId = student.studentId;
    [self getDataFromServers:^(NSDictionary *dict) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSArray *absence = dict[@"absenceArray"];
        NSArray *leave = dict[@"leaveArray"];
        //        NSArray *absence = @[@1,@2];
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

- (void)getWeekhistoryFromServers:(void(^)(NSDictionary  * dict))success{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSDictionary *requestData = @{
                                  @"courseId" : self.courseId,
                                  @"weekNumber" : self.weekOrdinal
                                  };
    NSString *url = [NSString stringWithFormat:@"%@/%@/weekhistory/",host,version];
    [manager POST:url parameters:requestData success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = responseObject;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(dict);
            }
        }];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
    }];
}

- (NSArray *)dictionaryToModelWithArray :(NSArray *)array{
    NSMutableArray *model = [NSMutableArray array];
    for (NSDictionary *state in array) {
        THdetailStudent *detail = [THdetailStudent detailWithDic:state];
        [model addObject:detail];
    }
    return model;
    
}

- (NSNumber *)numberMutipilay :(NSNumber *)number{
    NSNumber *result = [NSNumber numberWithFloat:number.floatValue * 360];
    return result;
}

@end
