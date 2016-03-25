//
//  THOrderNameViewController.m
//  TH-2.0
//
//  Created by Taro on 16/2/25.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THOrderNameViewController.h"
#import "MBProgressHUD+YXX.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "THStudent.h"
#import <FMDB/FMDatabase.h>
#import "THDetailViewController.h"
#import "THStudentTableViewCell.h"
#import "THdetailStudent.h"

@interface THOrderNameViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , weak) UITableView * tableView;
@property (nonatomic , weak) UIButton * subBtn;
@property (nonatomic , strong) NSDictionary * totalDict;
@property (nonatomic , strong) NSArray * recommendModel;
@property (nonatomic , strong) NSArray * normalModel;
@property (nonatomic , strong) NSArray * totalModel;
@property (nonatomic , strong) NSMutableSet * absenceSet;
@property (nonatomic , strong) NSMutableSet * leaveSet;
@property (nonatomic , strong) FMDatabase * db;
@property (nonatomic , strong) THDetailViewController * detail;


@end

@implementation THOrderNameViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    self.view.backgroundColor = YColor(241, 241, 241, 1);
    self.absenceSet = [NSMutableSet set];
    self.leaveSet = [NSMutableSet set];
    [self getDataFromServe:^(NSDictionary *dict) {
        self.totalDict = dict;
        NSMutableArray *recommendModel = [NSMutableArray array];
        NSMutableArray *normalModel = [NSMutableArray array];
        NSMutableArray *totalModel = [NSMutableArray array];
        for (id object in dict[@"recommend"]) {
            THStudent *student = [THStudent studentWithDic:object];
            [recommendModel addObject:student];
            [totalModel addObject:student];
        }
        for (id object in dict[@"normal"]) {
            THStudent *student = [THStudent studentWithDic:object];
            [normalModel addObject:student];
            [totalModel addObject:student];
        }
        self.recommendModel = recommendModel;
        self.normalModel = normalModel;
        self.totalModel = totalModel;
        [self addTableViewAndNav];
        [self addSubmitBtn];
//        [self addDataToDatabase];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
    
    
}

//// 添加数据到数据库
//- (void)addDataToDatabase{
//    NSString *path =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"student.sqlite"];
//    self.db = [FMDatabase databaseWithPath:path];
//    [self.db open];
//     [_db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS class_%@ (number integer PRIMARY KEY,week integer, studentId integer ,studentNo integer, studentName text , lateTimes integer ,absence integer , leave integer , later integer , arrive integer );",self.courseId]];
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM class_%@ WHERE week = %@;",self.courseId, self.weekOrdinal];
//    FMResultSet *set = [self.db executeQuery:sql];
//    if (!set.next) {
//        
//        for (int i = 0; i < self.totalModel.count; i++) {
//            
//            THStudent *student = [self.totalModel objectAtIndex:i];
//            NSString *string = [NSString stringWithFormat:@"INSERT INTO class_%@ (week,studentId,studentNo,studentName, lateTimes, absence ,leave, later,arrive) VALUES (%@,%@, %@,'%@' ,%@, 0, 0, 0,0)",self.courseId,self.weekOrdinal,student.studentId,student.studentNo,student.name,student.lateTimes];
//            [self.db executeUpdate:string];
//        }
//    }
//    [self.db close];
//}

//添加view
- (void)addTableViewAndNav{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+43, screenW, screenH-107) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource =self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    
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

- (void)submit{
    UIAlertController *alertsubmit = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定提交" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //提交到网络
        [MBProgressHUD showMessage:@"正在提交" toView:self.view];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSArray *absence = [self.absenceSet allObjects];
    NSArray *leave = [self.leaveSet allObjects];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *dict = @{
                           @"studentIdForAbsence" :absence,
                           @"courseId" : self.courseId,
                           @"studentIdForLeave" :leave,
                           @"studentIdForLate" :@[]
                           };
    NSString *url = [NSString stringWithFormat:@"%@/%@/absence_record/",host,version];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        THLog(@"%@",responseObject[@"status"]);
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSNumber *status = responseObject[@"status"];
        if ([status integerValue] == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交成功！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                NSString *key = [NSString stringWithFormat:@"%@-%@",self.weekOrdinal,self.courseId];
//                [defaults setValue:@"wrote" forKey:key];
                //提交到数据库
//                [self.db open];
//                for (NSNumber *studentId in absence) {
//                    [_db executeUpdate:[NSString stringWithFormat:@"UPDATE class_%@ SET absence = 1, leave = 0 WHERE studentId = %@ AND week = %@;",self.courseId,studentId,self.weekOrdinal]];
//                }
//                for (NSNumber *student in leave) {
//                    [_db executeUpdate:[NSString stringWithFormat:@"UPDATE class_%@ SET absence = 0, leave = 1 WHERE studentId = %@ AND week = %@;",self.courseId,student,self.weekOrdinal]];
//                }
//                [_db executeUpdate:[NSString stringWithFormat:@"UPDATE class_%@ SET arrive = 1 WHERE absence = 0 and leave = 0 AND week = %@",self.courseId,self.weekOrdinal]];
//                [self.db close];
                
                [self getDetailFromServers:^(NSDictionary *dict) {
                    THDetailViewController *detail = [[THDetailViewController alloc] init];
                    detail.courseId = self.courseId;
                    detail.weekOrdinal = self.weekOrdinal;
                    detail.Navtitle = self.Navtitle;
                    NSDictionary *dictionary = dict[@"history"];
                    NSArray *absenceModel = [self dictionaryToModelWithArray:dictionary[@"absence"]];
                    NSArray *leaveModel = [self dictionaryToModelWithArray:dictionary[@"leave"]];
                    NSArray *laterModel = [self dictionaryToModelWithArray:dictionary[@"later"]];
                    NSArray *appearModel = [self dictionaryToModelWithArray:dictionary[@"appear"]];
                    NSArray *tableViewData = @[absenceModel,leaveModel,laterModel,appearModel];
                    NSNumber *absence = [self numberMutipilay:dict[@"absenceProportion"]];
                    NSNumber *leave = [self numberMutipilay:dict[@"leaveProportion"]];
                    NSNumber *late = [self numberMutipilay:dict[@"lateProportion"]];
                    NSNumber *appear = [self numberMutipilay:dict[@"appearProportion"]];
                    detail.slices = @[absence,leave,late,appear];
                    detail.totalModel = tableViewData;
                    detail.tableviewData = [detail.totalModel objectAtIndex:0];
                    self.detail = detail;
                    [self.view addSubview:self.detail.view];
               
           

                }];
                
            }];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
        }
            else{
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"这次点名为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alertView show];

        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请确定网络是否连接" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        
    }];
       }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertsubmit addAction:cancel];
    [alertsubmit addAction:confirm];
    [self presentViewController:alertsubmit animated:YES completion:nil];

}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"系统推荐点名";
    }else{
        return @"常规点名";
    }
}

//tableview的一些方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict = self.totalDict;
    NSArray *normal = dict[@"normal"];
    NSArray *recommend = dict[@"recommend"];
   
    if (section == 1) {
        return normal.count;
    }else{
    return recommend.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    THStudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[THStudentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        NSArray *array = [NSArray array];
        cell.tag = 0;
        if (indexPath.section == 0) {
            array = self.recommendModel;
        }else {
            array = self.normalModel;
        }
        THStudent *student = array[indexPath.row];
        cell.textLabel.text = student.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",student.studentNo];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    THStudentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.tag = (cell.tag+1)%3;
    UIImage *image = [[UIImage alloc] init];
    NSArray *array = [NSArray array];
    if (indexPath.section == 0 ) {
        array = self.recommendModel;
    }else{
        array = self.normalModel;
    }
    THStudent *student = array[indexPath.row];
    if (cell.tag == 0) {
       image = [UIImage imageNamed:@"green_status"];
      [self cancelActive:student.studentId];
    }else if(cell.tag == 1){
       image = [UIImage imageNamed:@"red_status"];
      [self putStudentIdToAbsence:student.studentId];
    }
    if (cell.tag == 2) {
       image = [UIImage imageNamed:@"blue_status"];
      [self putStudentIdToLeave:student.studentId];
    }
    [cell changeCellIconWith:image];
//    THLog(@"%@--%@",self.absenceSet,self.leaveSet);
    
}

- (void)putStudentIdToAbsence :(NSNumber *)studentId{
    [self.absenceSet addObject:studentId];
    [self.leaveSet removeObject:studentId];
}

- (void)putStudentIdToLeave :(NSNumber *)studentId{
    [self.absenceSet removeObject:studentId];
    [self.leaveSet addObject:studentId];
}

- (void)cancelActive :(NSNumber *)studentId{
    [self.absenceSet removeObject:studentId];
    [self.leaveSet removeObject:studentId];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //8.0需要先调用这个方法
}

- (NSArray <UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    THStudentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *array = [NSArray array];
    if (indexPath.section == 0 ) {
        array = self.recommendModel;
    }else{
        array = self.normalModel;
    }

    
    THStudent *student = array[indexPath.row];
    UITableViewRowAction *absence = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"缺席" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self changeCellEditActionRightImage:tableView :cell :[UIImage imageNamed:@"red_status"]];
        [self putStudentIdToAbsence:student.studentId];
        cell.tag = (cell.tag+1)%3;
    }];
    absence.backgroundColor = YColor(208, 85, 90, 1);
    UITableViewRowAction *leave = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"请假" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self changeCellEditActionRightImage:tableView :cell :[UIImage imageNamed:@"blue_status"]];
        [self putStudentIdToLeave:student.studentId];
        cell.tag = (cell.tag+2)%3;
          }];
    leave.backgroundColor = YColor(64, 186, 217, 1);
    UITableViewRowAction *cancel = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"撤销"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self changeCellEditActionRightImage:tableView :cell :[UIImage imageNamed:@"green_status"]];
        [self cancelActive:student.studentId];
    }];
    return @[cancel,leave,absence];
    
}

- (void)changeCellEditActionRightImage :(UITableView *)tableView :(THStudentTableViewCell *)cell :(UIImage *)image{
    [cell changeCellIconWith:image];
    [tableView setEditing:NO];
}

// 网络请求
- (void)getDataFromServe:(void(^)( NSDictionary  * dict))success{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/%@/test_create_test/?courseId=%@",host,version,self.courseId];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *array = responseObject[@"class"];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(array);
            }
        }];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请确定网络是否连接" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        THLog(@"%@",error);
    }];
}

- (void)getDetailFromServers:(void(^)(NSDictionary  * dict))success{
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
- (NSNumber *)numberMutipilay :(NSNumber *)number{
    NSNumber *result = [NSNumber numberWithFloat:number.floatValue * 360];
    return result;
}

- (NSArray *)dictionaryToModelWithArray :(NSArray *)array{
    NSMutableArray *model = [NSMutableArray array];
    for (NSDictionary *state in array) {
        THdetailStudent *detail = [THdetailStudent detailWithDic:state];
        [model addObject:detail];
    }
    return model;
    
}

@end
