//
//  THStatisticsViewController.m
//  TH-2.0
//
//  Created by Taro on 16/1/13.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THStatisticsViewController.h"
#import "THClass.h"
#import <FMDB/FMDatabase.h>
#import "THHistoryViewController.h"
#import "THSegmentScrollViewController.h"
#import "THSettingTableViewController.h"

@interface THStatisticsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray * tableviewData;
@property (nonatomic , strong) FMDatabase * db;

@end

@implementation THStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self getDataFromDatabase];
 
   
       [self getWeekOrdinal:^(NSArray *array) {
        self.classList = array;
//        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:2];
//        THSettingTableViewController  *setting = [nav.viewControllers objectAtIndex:0];
           NSMutableArray *mutableArray = [NSMutableArray array];
           for (NSDictionary *classData in self.classList) {
               THClass *allclass = [THClass classWithDic:classData];
               [mutableArray addObject:allclass];
           }
//        setting.classlist = array;
           self.tableviewData = mutableArray;
           [self addView];

    }];
    
    
    
//    UINavigationController *nav1 = [self.tabBarController.viewControllers objectAtIndex:1];
//    THStatisticsViewController  *statist = [nav1.viewControllers objectAtIndex:0];
//    statist.classList = array;
}


- (void)addView{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenW, 49)];
    lable.text = @"选择课程";
    lable.backgroundColor = YColor(228, 228, 228, 1);
    [lable setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lable];
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+49, screenW, screenH-64-49-48) ];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = YColor(241, 241, 241, 1);
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

//- (void)getDataFromDatabase{
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"student.sqlite"];
//    self.db = [[FMDatabase alloc] initWithPath:path];
//    [self.db open];
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM allclass ;"];
//    FMResultSet *set = [self.db executeQuery:sql];
//    NSMutableArray *array = [NSMutableArray array];
//    while ([set next]) {
//        NSDictionary *dict = @{@"courseName": [set stringForColumn:@"coursename"],
//                               @"courseNo": [set stringForColumn:@"courseno"],
//                               @"courseId": [set stringForColumn:@"courseid"],
//                               @"venue": [set stringForColumn:@"venue"],
//                               @"lessonPeriod": [set stringForColumn:@"lessonperiod"],
//                               @"week":[set stringForColumn:@"week"]
//                               };
//        THClass *allclass = [THClass classWithDic:dict];
//
//        [array addObject:allclass];
//    }
//    self.tableviewData = array;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableviewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 48,screenW , 2);
        view.backgroundColor = YColor(108, 108, 108, 1);
        [cell addSubview:view];
       
    }
    THClass *classdetail = self.tableviewData[indexPath.row];

    switch (classdetail.singleOrDouble.integerValue) {
        case 0:
            cell.textLabel.text = classdetail.courseName;
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@(单周)",classdetail.courseName];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%@(双周)",classdetail.courseName];
            break;
        default:
            break;
    }
    
    NSArray *allweek = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",[allweek objectAtIndex:classdetail.week.intValue],classdetail.lessonPeriod];
    cell.imageView.image = [UIImage imageNamed:@"pencil"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    THHistoryViewController *history = [[THHistoryViewController alloc] init];
    THClass *allclass = self.tableviewData[indexPath.row];
//    history.courseId = allclass.courseId;
//    history.courseName = allclass.courseName;
//    [self.navigationController pushViewController:history animated:YES];
    THSegmentScrollViewController *nextview = [[THSegmentScrollViewController alloc] init];
        nextview.courseId = allclass.courseId;
        nextview.courseName = allclass.courseName;
    [self.navigationController pushViewController:nextview animated:YES];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
    back.title = @"返回";
    self.navigationItem.backBarButtonItem = back;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    });
   
    

}



- (void)getWeekOrdinal:(void(^)( NSArray *array))success{
    NSString *url = [NSString stringWithFormat:@"%@/%@/all_courses/",host,version];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *result = responseObject[@"courses"];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(result);
            }
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        THLoginViewController *login = [[THLoginViewController alloc] init];
//        window.rootViewController = login;
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"teacherNo"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"groupName"];
    }];
    
}


@end
