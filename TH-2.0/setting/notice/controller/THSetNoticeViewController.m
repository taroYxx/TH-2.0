//
//  THSetNoticeViewController.m
//  Teacher-Help
//
//  Created by Taro on 15/11/20.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import "THSetNoticeViewController.h"
#import "THNoticeDetailViewController.h"
#import "THMessage.h"
#import "THAbsenceMessage.h"
#import <FMDB/FMDatabase.h>
#import "THRecord.h"
#import "THMessageText.h"
#import <MJRefresh/MJRefresh.h>

@interface THSetNoticeViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic , strong) UITableView * tableview;
@property (nonatomic , strong) NSArray * absenceMessage;
@property (nonatomic , strong) NSArray * messageModel;
@property (nonatomic , strong) NSMutableArray * messageText;
@property (nonatomic , strong) FMDatabase * db;

@end

@implementation THSetNoticeViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableview.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];


    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITabBarController *tabBarController = (UITabBarController *)window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem = [tabBar.items objectAtIndex:2];
    tabBarItem.badgeValue = nil;
   
    NSString *path =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"student.sqlite"];
    self.db = [FMDatabase databaseWithPath:path];
    [self.db open];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS message (studentId integer PRIMARY KEY,messageId integer ,studentNo integer, Name text, major text, classNo integer, state integer);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS record (studentId integer ,teacherName text ,courseName text, courseNo text, courseId integer);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS messagetext (messageId integer ,celltext text, celldetailtext text)"];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTableview];
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    [self.tableview.mj_header beginRefreshing];
    
}

- (void)loadNewData{
    
    [self GetMessage:^(NSArray *array) {
        NSMutableArray *mutalarray = [NSMutableArray array];
        self.noticeData = array;
        for (NSDictionary *dict in self.noticeData) {
            NSString *messageId = dict[@"messageId"];
            NSArray *absenceStudent = dict[@"absence_students"];
            NSString *celltext = [NSString stringWithFormat:@"有%ld位同学严重迟到",absenceStudent.count];
            NSRange range = NSMakeRange(5,5);
            NSString *string1 = [dict[@"time"] substringWithRange:range];
            NSRange range1 = NSMakeRange(11, 8);
            NSString *string2 = [dict[@"time"] substringWithRange:range1];
            NSString *celldetailtext = [NSString stringWithFormat:@"%@ %@",string1,string2];
            NSDictionary *dict = @{
                                   @"messageId" : messageId,
                                   @"celltext" : celltext,
                                   @"celldetailtext" :celldetailtext,
                                   @"icon" : @"re"
                                   };
            THMessageText *messagetext = [THMessageText textWithDic:dict];
            [mutalarray addObject:messagetext];
        }
        self.messageText = mutalarray;
        [self getCelltextFromDataBase];
        [self.tableview reloadData];
        [self.tableview.mj_header endRefreshing];
    }];
    
}

//- (void)putDataToDadabaseWith :(NSString *)messageId{
//    for (NSDictionary *message in self.noticeData) {
//        NSArray *absenceStudent = message[@"absence_students"];
//        NSString *celltext = [NSString stringWithFormat:@"有%ld位同学严重迟到",absenceStudent.count];
//        NSRange range = NSMakeRange(5,5);
//        NSString *string1 = [message[@"time"] substringWithRange:range];
//        NSRange range1 = NSMakeRange(11, 8);
//        NSString *string2 = [message[@"time"] substringWithRange:range1];
//        NSString *celldetailtext = [NSString stringWithFormat:@"%@ %@",string1,string2];
//        NSString *msgSql = [NSString stringWithFormat:@"INSERT INTO messagetext (messageId, celltext, celldetailtext) VALUES (%@, '%@', '%@')",message[@"messageId"],celltext,celldetailtext];
//        [self.db executeUpdate:msgSql];
//    }
    
//    for (NSDictionary *dict in self.noticeData) {
//        THAbsenceMessage *absenceMessgae = [THAbsenceMessage absenceMessageWithDic:dict];
//        for (NSDictionary *dictionary in dict[@"absence_students"]) {
//            THMessage *message = [THMessage messageWithDic:dictionary];
//            NSString *sql = [NSString stringWithFormat:@"INSERT INTO message (studentId, messageId, studentNo, Name,  major, classNo, state) VALUES (%@, %@, %@,'%@', '%@', %@, 0)",message.studentId, absenceMessgae.messageId, message.studentNo, message.name, message.major, message.classNo];
//            [self.db executeUpdate:sql];
//            for (NSDictionary *recordDic in message.records) {
//                THRecord *record = [THRecord recodeWithDic:recordDic];
//                NSString *string = [NSString stringWithFormat:@"INSERT INTO record (studentId, teacherName, courseName, courseNo, courseId) VALUES (%@, '%@', '%@','%@', %@)",message.studentId, record.teacherName,record.courseName, record.courseNo,record.courseId];
//                [self.db executeUpdate:string];
//            }
//        }
//
//    }
//}

- (void)getCelltextFromDataBase{
    NSString *path =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"student.sqlite"];
    self.db = [FMDatabase databaseWithPath:path];
    [self.db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM messagetext "];
    FMResultSet *set = [self.db executeQuery:sql];
    while ([set next]) {
        NSString *messageId = [set stringForColumn:@"messageId"];
        NSString *celltext = [set stringForColumn:@"celltext"];
        NSString *celldetailtext = [set stringForColumn:@"celldetailtext"];
        
        NSDictionary *dict = @{
                               @"messageId" : messageId,
                               @"celltext" : celltext,
                               @"celldetailtext" :celldetailtext,
                               
                               };
        THMessageText *msg = [THMessageText textWithDic:dict];
        [self.messageText addObject:msg];
    }
    

}

- (void)addTableview{
    UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.frame];
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableview = tableview;
    [self.view addSubview:self.tableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageText.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
     THMessageText *msg = self.messageText[indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        if (msg.icon) {
            cell.imageView.image = [UIImage imageNamed:msg.icon];
        }
        cell.tag = 1;
    }
   
    cell.textLabel.text = msg.celltext;
    cell.detailTextLabel.text = msg.celldetailtext;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    THMessageText *message = self.messageText[indexPath.row];
    THNoticeDetailViewController *detail = [[THNoticeDetailViewController alloc] init];
    detail.messageId = message.messageId;
    FMResultSet *set = [self.db executeQuery:[NSString stringWithFormat:@"SELECT * FROM message WHERE messageId = %@ ", message.messageId]];
    if (!set.next) {
        [self confirmMessage:message.messageId];
     //记录信息
        NSString *msgSql = [NSString stringWithFormat:@"INSERT INTO messagetext (messageId, celltext, celldetailtext) VALUES (%@, '%@', '%@')",message.messageId,message.celltext,message.celldetailtext];
        [self.db executeUpdate:msgSql];
     //记录record信息
        NSDictionary *dict = self.noticeData[indexPath.row];
            THAbsenceMessage *absenceMessgae = [THAbsenceMessage absenceMessageWithDic:dict];
            for (NSDictionary *dictionary in dict[@"absence_students"]) {
                THMessage *message = [THMessage messageWithDic:dictionary];
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO message (studentId, messageId, studentNo, Name,  major, classNo, state) VALUES (%@, %@, %@,'%@', '%@', %@, 0)",message.studentId, absenceMessgae.messageId, message.studentNo, message.name, message.major, message.classNo];
                [self.db executeUpdate:sql];
                for (NSDictionary *recordDic in message.records) {
                    THRecord *record = [THRecord recodeWithDic:recordDic];
                    NSString *string = [NSString stringWithFormat:@"INSERT INTO record (studentId, teacherName, courseName, courseNo, courseId) VALUES (%@, '%@', '%@','%@', %@)",message.studentId, record.teacherName,record.courseName, record.courseNo,record.courseId];
                    [self.db executeUpdate:string];
                }
            }
        
    }
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)confirmMessage :(NSNumber *)messageId{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];

    NSDictionary *dict = @{
                            @"messageId":messageId
                           };
    NSString *url = [NSString stringWithFormat:@"%@/%@/messages/",host,version];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        THLog(@"%@",responseObject);
        NSNumber *status = responseObject[@"status"];
        if ([status integerValue] == 1) {
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请确定网络是否连接" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        
    }];

}

- (void)GetMessage:(void(^)( NSArray *array))success{
    NSString *url = [NSString stringWithFormat:@"%@/%@/messages/",host,version];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *result = responseObject[@"absence_messages"];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(result);
            }
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
    }];
    
}



@end
