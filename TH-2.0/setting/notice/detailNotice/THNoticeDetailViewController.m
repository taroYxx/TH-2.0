//
//  THNoticeDetailViewController.m
//  TH-2.0
//
//  Created by Taro on 16/3/2.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THNoticeDetailViewController.h"
#import <FMDB/FMDatabase.h>
#import "THMessage.h"
#import "THRecord.h"
#import "THNoticeCellTableViewCell.h"



@interface THNoticeDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) FMDatabase * db;
@property (nonatomic , strong) NSArray * student;


@end

@implementation THNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    THAbsenceMessage *absence = self.absenceMessage;
//    THLog(@"absence%@",self.messageId);
    [self getdataFromDatabase];
    [self addTableView];
  
    
}
- (void)getdataFromDatabase{
    NSString *path =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"student.sqlite"];
    self.db = [FMDatabase databaseWithPath:path];
    [self.db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM message WHERE messageId = %@;",self.messageId];
    FMResultSet *set = [self.db executeQuery:sql];
    NSMutableArray *student = [NSMutableArray array];
    while ([set next]) {
        NSString *studentId = [set stringForColumn:@"studentId"];
        NSString *name = [set stringForColumn:@"name"];
        NSString *studentNo = [set stringForColumn:@"studentNo"];
        NSString *major = [set stringForColumn:@"major"];
        NSString *classNo = [set stringForColumn:@"classNo"];
        NSString *state = [set stringForColumn:@"state"];
        
        NSString *sql1 = [NSString stringWithFormat:@"SELECT * FROM record WHERE studentId = %@;",studentId];
        FMResultSet *set1 = [self.db executeQuery:sql1];
        NSString *recordString = [NSString string];
        while ([set1 next]) {
            NSString *teacherName = [set1 stringForColumn: @"teacherName"];
            NSString *courseName = [set1 stringForColumn:@"courseName"];
            NSString *courseNo = [set1 stringForColumn:@"courseNo"];
            NSString *string = [NSString stringWithFormat:@"课程：%@ 课程号：%@ 课程老师:%@\n",courseName,courseNo,teacherName];
            recordString = [recordString stringByAppendingString:string];
        }
        NSDictionary *dict = @{
                               @"studentId" : studentId,
                               @"name" : name,
                               @"studentNo" :studentNo,
                               @"major" : major,
                               @"classNo" : classNo,
                               @"recordString" : recordString,
                               @"state" : state
                               };
        THMessage *message = [THMessage messageWithDic:dict];
        [student addObject:message];
        
        
    }
    self.student = student;

}

- (void)addTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    
//    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(0, 0, 100, 40);
//    view.backgroundColor = [UIColor redColor];
//    
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(0, 0, 100, 40);
//    label.backgroundColor = [UIColor blueColor];
//    [view addSubview:label];
//    
//    return view;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.student.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    THNoticeCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[THNoticeCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    THMessage *student = self.student[indexPath.row];
//    THLog(@"%@--%@",student.studentId,student.recordString);
    [cell setlableTextname:student.name studentmajor:student.major classNo:student.classNo studentNo:student.studentNo record:student.recordString];
    

   
    if (student.state.intValue == 0) {
        
        
        [cell setStateText:@"未处理"];
    }else{
    [cell setStateText:@"已处理"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //8.0需要先调用这个方法
}
- (NSArray <UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    THNoticeCellTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   THMessage *student = self.student[indexPath.row];
    UITableViewRowAction *deal = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"处理" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
          [_db executeUpdate:[NSString stringWithFormat:@"UPDATE message SET state = 1 WHERE studentId = %@ ;",student.studentId]];
        [self getdataFromDatabase];
        [self.tableView reloadData];
        
        [tableView setEditing:NO];
    }];
    deal.backgroundColor = YColor(208, 85, 90, 1);
        return @[deal];
    
}


@end
