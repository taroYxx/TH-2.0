//
//  THHistoryViewController.m
//  TH-2.0
//
//  Created by Taro on 16/3/1.
//  Copyright © 2016年 Taro. All rights reserved.
//
#import "THPresentTableViewController.h"
#import "THHistoryViewController.h"
#import "THHomeworkViewController.h"
#import "UITextfield+UIPickView.h"
#import <XYPieChart/XYPieChart.h>
#import "THDetailHistoryViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUD+YXX.h"




@interface THHistoryViewController ()<XYPieChartDataSource,XYPieChartDelegate>


@property (nonatomic , strong) UIPickerView * pickview;
@property (nonatomic , weak) UIButton * button;
//@property (nonatomic , weak) UIButton * rightBtn;
@property (nonatomic , weak) UITextfield_UIPickView *textfield;
@property (nonatomic , strong) XYPieChart * pieChart;
@property (nonatomic , strong) NSArray * slices;
@property (nonatomic , strong) NSArray * colorOfSlice;
@property (nonatomic , strong) NSArray * nameOfSlice;
@property (nonatomic , strong) NSArray * btnArray;
@property (nonatomic , strong) NSArray * nextViewData;



@end

@implementation THHistoryViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showMessage:@"载入中" toView:self.view];
    [self addTitleView];
//    UIButton *btn = [[UIButton alloc] init];
//    btn.frame = CGRectMake(0, 0, 70, 30);
//    [btn setTitle:@"第一周" forState:UIControlStateNormal];
//    [btn setTitleColor:YColor(207, 85, 89, 1) forState:UIControlStateNormal];
//    btn.hidden = YES;
//    [btn addTarget:self action:@selector(chooseWeek) forControlEvents:UIControlEventTouchUpInside];
//    self.rightBtn = btn;
//    
//    
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItem = right;
    
    [self getDataFromServers:^(NSDictionary *dict) {
//        NSInteger absence = [dict[@"absenceProportion"]floatValue]*360;
//        NSInteger leave = [dict[@"leaveProportion"]floatValue]*360;
//        NSInteger later = [dict[@"lateProportion"]floatValue]*360;
//        NSInteger appear = [dict[@"appearProportion"]floatValue]*360;
//        self.slices = @[[NSNumber numberWithInteger:absence],[NSNumber numberWithInteger:leave],[NSNumber numberWithInteger:later],[NSNumber numberWithInteger:appear]];
        NSArray *weeks = dict[@"weeks"];
        weeks = [weeks sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return NSOrderedAscending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        NSMutableArray *mutarray = [NSMutableArray arrayWithArray:weeks];
        [mutarray insertObject:@"全部" atIndex:0];
        
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < weeks.count; i++) {
            NSString *zhou = [NSString stringWithFormat:@"第%@周",weeks[i]];
            [array addObject:zhou];
        }
        [array insertObject:@"全部" atIndex:0];
        if (weeks.count == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"此课程无任何点名记录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
        UITextfield_UIPickView *textfield = [[UITextfield_UIPickView alloc] initWithFrame:CGRectMake(10, 143, screenW*2/3, 44) :array :mutarray ];
        self.textfield = textfield;
        self.textfield.subdata = mutarray[0];
        [self.view addSubview:textfield];
        [self addsomeView];
        [self addPiechartView];
        [self addbutton];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
    [self showTotalDataFromServe];
    
}

- (void)showTotalDataFromServe{
    [self totalDataFromServe:^(NSDictionary *dictionary) {
        NSInteger absence = [dictionary[@"absenceProportion"]floatValue]*360;
        NSInteger leave = [dictionary[@"leaveProportion"]floatValue]*360;
        NSInteger later = [dictionary[@"lateProportion"]floatValue]*360;
        NSInteger appear = [dictionary[@"appearProportion"]floatValue]*360;
        self.slices = @[[NSNumber numberWithInteger:absence],[NSNumber numberWithInteger:leave],[NSNumber numberWithInteger:later],[NSNumber numberWithInteger:appear]];
        
        
        NSArray *absenceArray = dictionary[@"history"][@"absence"];
        NSArray *leaveArray = dictionary[@"history"][@"leave"];
        NSArray *lateArray = dictionary[@"history"][@"late"];
        NSArray *appearArray = dictionary[@"history"][@"all"];
        self.nextViewData = @[absenceArray,leaveArray,lateArray,appearArray];
        [self.pieChart reloadData];
    }];
}



//- (void)chooseWeek{
//    THPresentTableViewController *week = [[THPresentTableViewController alloc] init];
//    week.view.frame = CGRectMake(0, 0, screenW-100, screenW-10);
//    //        present.tableViewData = dict[@"weekList"];
//    week.tableViewData = @[@"第一周",@"第二周"];
//    week.delegate = self;
//    [self presentPopupViewController:week animationType:MJPopupViewAnimationFade];


//    [self getWeekFromServers:^(NSDictionary *dict) {
//        THLog(@"%@",dict);
//        THGetWeekTableViewController *present = [[THGetWeekTableViewController alloc] init];
//        present.view.frame = CGRectMake(0, 0, screenW-100, screenW-10);
////        present.tableViewData = dict[@"weekList"];
//        present.tableViewData = @[@"第一周",@"第二周"];
//        
//        [self presentPopupViewController:present animationType:MJPopupViewAnimationFade];
//    }];
    
//}
//
//- (void)didSelectSegment:(UISegmentedControl *)sender{
//    sender = _segment;
//    if (sender.selectedSegmentIndex == 0) {
//        self.view.hidden = NO;
//        _homework.view.hidden = YES;
//        self.rightBtn.hidden = YES;
//    }else if(sender.selectedSegmentIndex == 1){
//        if (!_homework)
//        {
//           
//            _homework = [[THHomeworkViewController alloc] init];
//            _homework.courseId = self.courseId;
//            _homework.view.frame = CGRectMake(0, 64+43, screenW, screenH-64-43);
//            [self.view addSubview:_homework.view];
//        }
//         self.rightBtn.hidden = NO;
//        _homework.view.hidden = NO;
//    }
//}

- (void)addTitleView{
    UILabel *titleOfClass = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenW, 43)];
    titleOfClass.text = self.courseName;
    [titleOfClass setTextAlignment:NSTextAlignmentCenter];
    titleOfClass.backgroundColor = YColor(228, 228, 228, 1);
    [self.view addSubview:titleOfClass];
}

- (void)addsomeView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 200, 40)];
    label.text = @"请选择需要查询的周数:";
    [self.view addSubview:label];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.layer setCornerRadius:6.0];
    [button addTarget:self action:@selector(submitOk) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor =  YColor(207, 85, 89, 1);
    [self.view addSubview:button];
    self.button = button;
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@143);
        make.left.equalTo(self.textfield).with.offset(screenW*2/3+10);
        make.right.equalTo(@-10);
        make.height.equalTo(@44);
    }];
}

- (void)submitOk{
    
    [self.textfield endEditing:YES];
    [self loadNewView:^(NSDictionary *dict) {
        NSInteger absence = [dict[@"absenceProportion"]floatValue]*360;
        NSInteger leave = [dict[@"leaveProportion"]floatValue]*360;
        NSInteger later = [dict[@"lateProportion"]floatValue]*360;
        NSInteger appear = [dict[@"appearProportion"]floatValue]*360;
        NSArray *absenceArray = dict[@"history"][@"absence"];
        NSArray *leaveArray = dict[@"history"][@"leave"];
        NSArray *lateArray = dict[@"history"][@"late"];
        NSArray *appearArray = dict[@"history"][@"appear"];
        self.nextViewData = @[absenceArray,leaveArray,lateArray,appearArray];
        self.slices = @[[NSNumber numberWithInteger:absence],[NSNumber numberWithInteger:leave],[NSNumber numberWithInteger:later],[NSNumber numberWithInteger:appear]];
        [self.pieChart reloadData];
    }];
    
}

- (void)loadNewView:(void(^)(NSDictionary  * dict))success{
    
    if ([self.textfield.subdata isEqual:@"全部"]) {
        [self showTotalDataFromServe];
        THLog(@"ssss");
    }else{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSDictionary *requestData = @{
                                  @"courseId" : self.courseId,
                                  @"weekNumber" : self.textfield.subdata
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

}


- (void)totalDataFromServe:(void(^)(NSDictionary *dictionary))success{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/%@/get_history/",host,version];
    NSDictionary *body = @{
                           @"courseId" : self.courseId
                           };
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:url parameters:body success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
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


- (void)addPiechartView{
    self.pieChart = [[XYPieChart alloc] init];
    self.pieChart.delegate = self;
    self.pieChart.dataSource = self;
    [self.pieChart setStartPieAngle:M_PI];
    [self.pieChart setAnimationSpeed:1.0];
    CGFloat R  = screenH/3-80;
    [self.pieChart setPieRadius:R];//饼图半径
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:20]];
    [self.pieChart setLabelRadius:R-20];//数据标签出现的位置
    [self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChart setPieCenter:CGPointMake(screenW/2, screenH*2/3.5)];
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];
    

        [self.pieChart setShowPercentage:NO];
    self.nameOfSlice = [NSMutableArray arrayWithObjects:@"缺席名单",@"请假名单",@"迟到名单",@"已到名单",nil];
    self.colorOfSlice =[NSMutableArray arrayWithObjects:
                        YColor(208, 85, 90, 2),
                        YColor(64, 186, 217, 1),
                        YColor(255, 204, 43, 1),
                        YColor(85, 219, 105, 1),
                        nil];
    [self.view addSubview:self.pieChart];
    [self.pieChart reloadData];

}

- (void)addbutton{
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:self.nameOfSlice[i] forState:UIControlStateNormal];
        button.tag = i;
//        button.hidden = YES;
        button.backgroundColor = self.colorOfSlice[i];
        [button.layer setCornerRadius:8.0];
        [button addTarget:self action:@selector(btnselect:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        if (i == 0) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@-80);
                make.left.equalTo(@20);
                make.right.equalTo(@(-screenW/2-20));
                make.height.equalTo(@40);
            }];
        }
        if (i == 1) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@-80);
                make.left.equalTo(@(screenW/2+20));
                make.right.equalTo(@-20);
                make.height.equalTo(@40);
            }];
        }
        if (i == 2) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@-30);
                make.left.equalTo(@20);
                make.right.equalTo(@(-screenW/2-20));
                make.height.equalTo(@40);
            }];
        }
        if (i == 3) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@-30);
                make.left.equalTo(@(screenW/2+20));
                make.right.equalTo(@-20);
                make.height.equalTo(@40);
            }];
        }
        [array addObject:button];
    }
    self.btnArray = array;
}



- (void)btnselect :(id)sender{
    UIButton *button = sender;
   
    NSArray *nameList = [self.nextViewData objectAtIndex:button.tag];
    NSInteger icontag = button.tag;
//    THDetailHistoryViewController *detail = [[THDetailHistoryViewController alloc] init];
//    detail.nameList = [self.nextViewData objectAtIndex:button.tag];
//    detail.courseName = self.courseName;
//    detail.icontag = button.tag;
//    detail.courseId = self.courseId;
//    
    [self.delegate PresentsendValue:icontag nameList:nameList];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    });
//
    
}

- (void)getDataFromServers:(void(^)(NSDictionary  * dict))success{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSDictionary *requestData = @{
                                  @"courseId" : self.courseId,
                                  };
    NSString *url = [NSString stringWithFormat:@"%@/%@/history/",host,version];
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

//- (void)getWeekFromServers:(void(^)(NSDictionary  * dict))success{
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
//    NSDictionary *requestData = @{
//                                  @"courseId" : self.courseId,
//                                  };
//    NSString *url = [NSString stringWithFormat:@"%@/%@/homework_weeks/",host,version];
//    [manager POST:url parameters:requestData success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSDictionary *dict = responseObject;
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            if (success) {
//                success(dict);
//            }
//        }];
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        THLog(@"%@",error);
//    }];
//}


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

//- (void)PresentsendValue:(NSUInteger)number{
//    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
//    THLog(@"%ld",number);
//    NSArray *array = @[@"第一周",@"第二周"];
//    [self.rightBtn setTitle:array[number] forState:UIControlStateNormal];
//}

@end
