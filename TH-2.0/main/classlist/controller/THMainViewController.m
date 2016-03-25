//
//  THMainViewController.m
//  TH-2.0
//
//  Created by Taro on 16/1/13.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THMainViewController.h"
#import "THStatisticsViewController.h"
#import "THTopView.h"
#import "THClass.h"
#import <FMDB/FMDatabase.h>
#import "THClassTableViewCell.h"
#import "THNextViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUD+YXX.h"
#import "THLoginViewController.h"

@interface THMainViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>


@property (nonatomic , weak) UITableView * tableView;
@property (nonatomic , weak) THTopView * topview;
@property (nonatomic , assign) NSInteger week;
@property (nonatomic , strong) FMDatabase * db;
//@property (nonatomic , strong) NSArray * allDay;
@property (nonatomic , strong) NSNumber * weekOrdinal;


@property (nonatomic , strong) NSMutableArray * allday;


@end

@implementation THMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.automaticallyAdjustsScrollViewInsets = NO;// 空白
    self.view.backgroundColor = [UIColor whiteColor];
    [self getCurrentWeek];
    THTopView *topview = [[THTopView alloc] initWithFrame:CGRectMake(0, 64, screenW, screenH-64-48)];
    self.topview = topview;
    [self.topview.scrollview setContentOffset:CGPointMake(screenW*self.week, 0)];
    [self.view addSubview:self.topview];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    [self getWeekOrdinal:^(NSArray *array) {
        if (array) {
        //获得周数
            self.weekOrdinal = [array objectAtIndex:0][@"weekOrdinal"];}
        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:1];
        THStatisticsViewController *statistic = [nav.viewControllers objectAtIndex:0];
        statistic.classList = array;
        
        
        //星期判断
        NSArray *result = array;
        NSMutableArray *total = [[NSMutableArray alloc] init];
        for (int a = 0; a < 7; a++) {
            NSMutableArray *preweek = [[NSMutableArray alloc] init];
            for (int i = 0; i < result.count; i++) {
                NSDictionary *dict = [result objectAtIndex:i];
                if ([dict[@"week"]integerValue] == a) {
                    [preweek addObject:dict];
                }
            }
            [total addObject:preweek];
        }
        //上下午判断
        _allday = [NSMutableArray array];
        for (int i = 0; i < total.count; i++) {
            NSArray *everyday = [total objectAtIndex:i];
            NSMutableArray *morning = [[NSMutableArray alloc] init];
            NSMutableArray *afternoon = [[NSMutableArray alloc] init];
            NSMutableArray *evening = [[NSMutableArray alloc] init];
            for (int a = 0; a < everyday.count; a++) {
                NSDictionary *timeseparate = [everyday objectAtIndex:a];
                //取一门课判断上下午
                THClass *class = [THClass classWithDic:timeseparate];
                NSInteger time = [timeseparate[@"time"] integerValue];
                if (time == 0) {
                    [morning addObject:class];
                }else if (time == 1){
                    [afternoon addObject:class];
                }else if (time == 2){
                    [evening addObject:class];
                }
            }
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:morning forKey:@"morning"];
            [dict setValue:afternoon forKey:@"afternoon"];
            [dict setValue:evening forKey:@"evening"];
            [self.allday addObject:dict];
         
            
        }
       [self addTableviewToScrollView];
       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
    
    
    
}

- (NSInteger)getCurrentWeek{
    NSDate *date = [NSDate date];
    //    //IOS7
    //    //    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    //ios8
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone:timeZone];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    self.week = week;
    if (self.week == 1) {
        self.week = 6;
    }else if (self.week == 2){
        self.week = 0;
    }else{
        self.week = self.week-2;
    }
    return self.week;
}

- (void)addTableviewToScrollView{
    if (!self.tableView) {
    for (int i = 0 ; i < 7; i++) {
        UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(screenW*i,0,screenW, self.topview.bounds.size.height-43) style:UITableViewStyleGrouped];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.tag = i;
        self.tableView = tableview;
        [self.topview.scrollview addSubview:self.tableView];
        
        
    }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
       return [self returnNumberOfSection:tableView with:self.allday with:@"morning"];
    }
    else if (section == 1) {
       return [self returnNumberOfSection:tableView with:self.allday with:@"afternoon"];
    }
    else if (section == 2) {
       return [self returnNumberOfSection:tableView with:self.allday with:@"evening"];
    }
    return 0;
}

- (NSInteger)returnNumberOfSection: (UITableView *)tableview with:(NSArray *)array with:(NSString *)key{
    for (int i = 0; i < 7; i++) {
        if (tableview.tag == i) {
            NSDictionary *dict = [array objectAtIndex:i];
            NSArray *ary = [NSArray array];
            ary = [dict objectForKey:key];
            return ary.count;
        }
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 1){
        if ([self returnNumberOfSection:tableView with:self.allday with:@"afternoon"] == 0) {
            return nil;
        }
        return @"下午";
    }else if(section == 2){
        if ([self returnNumberOfSection:tableView with:self.allday with:@"evening"] == 0) {
            return nil;
        }
        return @"晚上";
    }else{
        if ([self returnNumberOfSection:tableView with:self.allday with:@"morning"] == 0) {
            return nil;
        }
        return @"上午";
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    THClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[THClassTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        for (int i = 0; i < 7; i++) {
            if (tableView.tag == i) {
                NSDictionary *array = [self.allday objectAtIndex:i];
                if (indexPath.section == 0) {
                    NSArray *mor = array[@"morning"];
                    THClass *classmor = mor[indexPath.row];
                    cell.textLabel.text = classmor.courseName;
                    cell.timeOfClass.text =[NSString stringWithFormat:@"%@节",classmor.lessonPeriod];
                    cell.location.text = classmor.venue;
                    cell.tag = [classmor.courseId intValue];
                }else if (indexPath.section == 1) {
                    NSArray *aft = array[@"afternoon"];
                    THClass *classaft = aft[indexPath.row];
                    cell.textLabel.text = classaft.courseName;
                    cell.timeOfClass.text =[NSString stringWithFormat:@"%@节",classaft.lessonPeriod];
                    cell.location.text = classaft.venue;
                    cell.tag = [classaft.courseId intValue];
                }else if (indexPath.section == 2){
                    NSArray *eve = array[@"evening"];
                    THClass *classeve = [eve objectAtIndex:i];
                    cell.textLabel.text = classeve.courseName;
                    cell.timeOfClass.text =[NSString stringWithFormat:@"%@节",classeve.lessonPeriod];
                    cell.location.text = classeve.venue;
                    cell.tag = [classeve.courseId intValue];
                }
                
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 31.0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    THOrderNameViewController *orderName = [[THOrderNameViewController alloc] init];
    THNextViewController *next = [[THNextViewController alloc] init];
    THClassTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    next.courseId = [[NSNumber alloc] initWithInteger:cell.tag];
    next.Navtitle = cell.textLabel.text;
    next.weekOrdinal = self.weekOrdinal;
    [self.navigationController pushViewController:next animated:YES];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    });
    
    
    
}

- (void)getWeekOrdinal:(void(^)( NSArray *array))success{
    NSString *url = [NSString stringWithFormat:@"%@/%@/course_names/",host,version];
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
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        THLoginViewController *login = [[THLoginViewController alloc] init];
        window.rootViewController = login;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"teacherNo"];
    }];

}

//- (void)getDataFromDatabase{
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"student.sqlite"];
//    self.db = [FMDatabase databaseWithPath:path];
//    [self.db open];
//    NSMutableArray *allDay = [NSMutableArray array];
//    for (int i = 0; i < 7; i++) {
//        
//        NSMutableArray *morning = [NSMutableArray array];
//        [self databaseToolWith:[self returnSqlWith:0 :i] :morning];
//        NSMutableArray *afternoon = [NSMutableArray array];
//        [self databaseToolWith:[self returnSqlWith:1 :i] :afternoon];
//        NSMutableArray *evening = [NSMutableArray array];
//        [self databaseToolWith:[self returnSqlWith:2 :i] :evening];
//        
//        NSDictionary *day = @{@"morning" : morning,
//                              @"afternoon" : afternoon,
//                              @"evening" : evening
//                              };
//        [allDay addObject:day];
//    }
//    self.allday = allDay;
//    if (allDay.count == 0) {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        THLoginViewController *login = [[THLoginViewController alloc] init];
//        window.rootViewController = login;
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"teacherNo"];
//    }
////    THLog(@"%@",self.allDay);
//    
//}
//- (NSString *)returnSqlWith:(NSInteger)time :(NSInteger)week{
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM allclass WHERE week = %ld AND time = %ld;",week,time];
//    return sql;
//    
//}
//
//- (void)databaseToolWith :(NSString *)sql :(NSMutableArray *)array{
//    FMResultSet *set = [self.db executeQuery:sql];
//    while ([set next]) {
//        [array addObject:[self dataToModelwith:set]];
//    }
//    
//    
//}

//- (THClass *)dataToModelwith:(FMResultSet *)set{
//    NSDictionary *dict = @{@"courseName": [set stringForColumn:@"coursename"],
//                           @"courseNo": [set stringForColumn:@"courseno"],
//                           @"courseId": [set stringForColumn:@"courseid"],
//                           @"venue": [set stringForColumn:@"venue"],
//                           @"lessonPeriod": [set stringForColumn:@"lessonperiod"]
//                           };
//    THClass *classDay = [THClass classWithDic:dict];
//    return classDay;
//}






@end
