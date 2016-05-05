//
//  THSetStaticViewController.m
//  Teacher-Help
//
//  Created by Taro on 15/11/20.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import "THSetStaticViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "THClass.h"
#import <XYPieChart/XYPieChart.h>
#import <FMDB/FMDatabase.h>
#import "THClassNameListTool.h"
#import <MJPopupViewController/UIViewController+MJPopupViewController.h>
#import "THPresentTableViewController.h"
#import "THHomeworkPer.h"

@interface THSetStaticViewController ()<UITextFieldDelegate,XYPieChartDataSource,XYPieChartDelegate,THPresentDelegate>
@property (nonatomic , weak) UISlider * slider;
@property (nonatomic , weak) UILabel * label;
@property (nonatomic , strong) UIPickerView * pickview;
@property (nonatomic , weak) UITextField * textfield;
@property (nonatomic , strong) XYPieChart * pieChart;
@property (nonatomic , strong) NSArray * pickViewData;
@property (nonatomic , strong) NSArray * courseId;
@property (nonatomic , strong) NSNumber * subcourseId;
@property (nonatomic , weak) UIButton * button;
@property (nonatomic , strong) NSArray * slices;
@property (nonatomic , strong) NSMutableArray * colorOfSlice;
@property (nonatomic , strong) NSMutableArray * nameOfSlice;
@property (nonatomic , weak) UILabel * absenceLabel;
@property (nonatomic , weak) UITextField * absenceTextField;
@property (nonatomic , strong) NSArray * PerModel;




@end

@implementation THSetStaticViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(150, screenH/2+50, screenW-170, 20)];
    [slider setTintColor:YColor(208, 86, 90, 1)];
//    slider.minimumValue = 5.0;
    
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    _slider = slider;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, screenH/2+40, screenW-15, 44)];
    label.text = @"设置百分比：";
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    _label = label;
    UILabel *kechengming = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, screenW/3, 30)];
    kechengming.text = @"请选择课程名：";
    kechengming.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:kechengming];
    UITextField *textfield =[[UITextField alloc] initWithFrame:CGRectMake(screenW/3+15, 70, screenW-screenW/3-20,40)];
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.delegate = self;
//    self.pickview = [[UIPickerView alloc] initWithFrame:CGRectMake(0,screenH-200, screenW, 200)];
//    self.pickview.delegate = self;
//    self.pickview.dataSource = self;
//    self.pickview.backgroundColor = YColor(235, 235, 241, 1);
//    textfield.inputView = self.pickview;
//    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, 44)];
//    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(toolbarDone)];
//    done.tintColor = YColor(208, 86, 90, 1);
//    UIBarButtonItem *Flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    doneToolbar.items = @[Flexible,done];
//    textfield.inputAccessoryView = doneToolbar;
    [self.view addSubview:textfield];
    self.textfield = textfield;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(35, screenH * 3/4+10, screenW-70, 44)];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    button.backgroundColor = YColor(208, 86, 90, 1);
    [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.button = button;
    [self addPiechart];
    
    UILabel *absenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, screenH/2+40+44+6, 100, 44)];
    absenceLabel.text = @"缺勤扣除：";
    absenceLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:absenceLabel];
    self.absenceLabel = absenceLabel;
    
    UITextField *absenceText = [[UITextField alloc] initWithFrame:CGRectMake(120, screenH/2+40+44+6, 100, 38)];
    absenceText.borderStyle = UITextBorderStyleRoundedRect;
    absenceText.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:absenceText];
    self.absenceTextField = absenceText;

    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(120+100+5, screenH/2+40+44+6, 80, 44)];
    tip.text = @"分/人/次";
    tip.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:tip];
    
    
    
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSMutableArray *classId = [NSMutableArray array];
    
    NSArray *array = self.classlist;

    for (NSDictionary *dict in array) {
        THClass *class = [THClass classWithDic:dict];
        
        
        [mutableArray addObject:class.courseName];
        [classId addObject:class.courseId];
    }
    self.pickViewData = mutableArray;
    self.courseId = classId;
    
    [self getHomeworkPerByCourseId:^(NSArray *array) {
        NSMutableArray *mutaleArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            THHomeworkPer *per = [THHomeworkPer HomeWorkPerWithDic:dict];
            [mutaleArray addObject:per];
        }
        self.PerModel = mutaleArray;
    }];
    
}

- (UIView *)pieView :(CGRect)frame :(UIColor *)color :(NSString *)title{
    UIView * bgView = [[UIView alloc] initWithFrame:frame];
    UIView * view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, frame.size.width/3, frame.size.height);
    view.backgroundColor = color;
    [bgView addSubview:view];
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.adjustsFontSizeToFitWidth = YES;
    label.frame = CGRectMake(frame.size.width/3, 0, frame.size.width*2/3, frame.size.height);
    [bgView addSubview:label];
    return bgView;

}

- (void)addPiechart{
    self.pieChart = [[XYPieChart alloc] init];
    self.pieChart.delegate = self;
    self.pieChart.dataSource = self;
    [self.pieChart setStartPieAngle:M_PI];
    [self.pieChart setAnimationSpeed:1.0];
    CGFloat R  = (screenH/2-64-43)/2-10;
    [self.pieChart setPieRadius:R];//饼图半径
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:20]];
    [self.pieChart setLabelRadius:R-20];//数据标签出现的位置
    [self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChart setPieCenter:CGPointMake(screenW/2, screenH/3+10)];
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];
//        [self.pieChart setShowPercentage:NO];
    self.nameOfSlice = [NSMutableArray arrayWithObjects:@"考勤",@"平时作业",nil];
    self.colorOfSlice =[NSMutableArray arrayWithObjects:
                        YColor(209, 84, 87, 1),YColor(228, 228, 228, 1),
                        nil];
    [self.view addSubview:[self pieView:CGRectMake(screenW/4, screenH/2+5, screenW/4, screenW/12) :YColor(208, 86, 90, 1) :@"课堂考勤"]];
    [self.view addSubview:[self pieView:CGRectMake(screenW/2, screenH/2+5, screenW/4, screenW/12) :YColor(228, 228, 228, 1) :@"平时作业"]];
 
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
    return [self.nameOfSlice objectAtIndex:index];
}




- (void)submit{
    if(self.subcourseId && self.slider.value && self.absenceTextField.text){
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/%@/course_homework_per/",host,version];
    //存在百分比没有精确的问题
    NSDictionary *dict = @{
                           @"courseId" : self.subcourseId,
                           @"homeworkPer" : [NSString stringWithFormat:@"%0.2f",self.slider.value],
                           @"deductPoint" : self.absenceTextField.text
                           };
    
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        THLog(@"%@",responseObject);
        NSNumber *status = responseObject[@"status"];
        if (status.intValue == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交成功！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"系统信息" message:@"网络连接有问题" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    }];
    }else {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"系统信息" message:@"请完善所有信息再提交！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    }

    
}

- (void)sliderValueChange:(id)sender{
  

    UISlider *control = (UISlider *)sender;
    if (control.value < 0.04) {
        [control setValue:0];
    }else{
        
        float a = control.value;
        float b = (int)(a * 10) / 10.0;
        float c = (int)(a * 100) / 100.0 - b;
        float d;
        if (c > 0.05) {
            d = b+0.1;
        }else{
            d = b+0.05;
        }
        [control setValue:d]; }
        float kaoqin = control.value * 360;
        float zuoye = (1-control.value) * 360;
        self.slices = @[[NSNumber numberWithFloat:kaoqin],[NSNumber numberWithFloat:zuoye
                        ]];
        [self.pieChart reloadData];

}



- (void)presentClassView{
    THPresentTableViewController *present = [[THPresentTableViewController alloc] init];
    NSMutableArray *mutalArray = [NSMutableArray array];
    [self getWeekOrdinal:^(NSArray *array) {
        self.classlist = array;
        for (NSDictionary *dict in array) {
            NSString *courseName = [NSString stringWithFormat:@"%@  %@",dict[@"courseName"],dict[@"courseNo"]];
            [mutalArray addObject:courseName];
        }
        present.tableViewData = mutalArray;
        present.delegate = self;
        present.view.frame = CGRectMake(0, 0, screenW-100, screenW-10);
        [self presentPopupViewController:present animationType:MJPopupViewAnimationFade];
    }];
   

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField == self.textfield){
    [self presentClassView];

        [textField endEditing:YES];

    }
}



- (void)PresentsendValue:(NSUInteger)number{
    
    NSDictionary *dict = self.classlist[number];
    self.subcourseId = dict[@"courseId"];
    THLog(@"%@",self.courseId);
    self.textfield.text = dict[@"courseName"];
     THLog(@"%@",self.textfield);
    
    
    for (THHomeworkPer *per in self.PerModel) {
        if (per.courseId == self.subcourseId) {
      
            self.slider.value = 1-[per.homeworkper floatValue];
            THLog(@"%f",self.slider.value);
            self.absenceTextField.text = [NSString stringWithFormat:@"%@",per.deduct_points];
            float kaoqin = (1-[per.homeworkper floatValue]) * 360;
            float zuoye = [per.homeworkper floatValue] * 360;
            self.slices = @[[NSNumber numberWithFloat:kaoqin],[NSNumber numberWithFloat:zuoye
                                                               ]];
            [self.pieChart reloadData];
        }
    }
    
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
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

- (void)getHomeworkPerByCourseId:(void(^)( NSArray *array))success{
    NSString *url = [NSString stringWithFormat:@"%@/%@/getHomeworkPerByCourseId/",host,version];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *result = responseObject[@"course"];
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
