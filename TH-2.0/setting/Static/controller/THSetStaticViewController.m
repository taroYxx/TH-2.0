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


@interface THSetStaticViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,XYPieChartDataSource,XYPieChartDelegate>
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
    UITextField *textfield =[[UITextField alloc] initWithFrame:CGRectMake(screenW/3+15, 70, screenW-screenW/3-20, 30)];
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.delegate = self;
    self.pickview = [[UIPickerView alloc] initWithFrame:CGRectMake(0,screenH-200, screenW, 200)];
    self.pickview.delegate = self;
    self.pickview.dataSource = self;
    self.pickview.backgroundColor = YColor(235, 235, 241, 1);
    textfield.inputView = self.pickview;
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, 44)];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(toolbarDone)];
    done.tintColor = YColor(208, 86, 90, 1);
    UIBarButtonItem *Flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    doneToolbar.items = @[Flexible,done];
    textfield.inputAccessoryView = doneToolbar;
    [self.view addSubview:textfield];
    self.textfield = textfield;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(35, screenH * 3/4, screenW-70, 44)];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    button.backgroundColor = YColor(208, 86, 90, 1);
    [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.button = button;
    
//    self.slices = @[@180,@180];
    [self addPiechart];
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
    [self.pieChart setPieCenter:CGPointMake(screenW/2, screenH/3)];
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];
//        [self.pieChart setShowPercentage:NO];
    self.nameOfSlice = [NSMutableArray arrayWithObjects:@"考勤",@"平时作业",nil];
    self.colorOfSlice =[NSMutableArray arrayWithObjects:
                        YColor(209, 84, 87, 1),YColor(228, 228, 228, 1),
                        nil];
    [self.view addSubview:[self pieView:CGRectMake(screenW/4, screenH/2, screenW/4, screenW/12) :YColor(208, 86, 90, 1) :@"课堂考勤"]];
    [self.view addSubview:[self pieView:CGRectMake(screenW/2, screenH/2, screenW/4, screenW/12) :YColor(228, 228, 228, 1) :@"平时作业"]];
 
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


- (void)toolbarDone{
    [self.textfield endEditing:YES];
}


- (void)submit{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/%@/course_homework_per/",host,version];
    //存在百分比没有精确的问题
    NSDictionary *dict = @{
                           @"courseId" : self.subcourseId,
                           @"homeworkPer" : [NSString stringWithFormat:@"%0.2f",self.slider.value]
                           };
    
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        THLog(@"%@",responseObject);
        NSNumber *status = responseObject[@"status"];
        if (status.intValue == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交成功！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"系统信息" message:@"网络连接有问题" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    }];

    
}

- (void)sliderValueChange:(id)sender{
  

    UISlider *control = (UISlider *)sender;

    
    
        float kaoqin = control.value * 360;
        float zuoye = (1-control.value) * 360;
        self.slices = @[[NSNumber numberWithFloat:kaoqin],[NSNumber numberWithFloat:zuoye
                                                           ]];
        [self.pieChart reloadData];

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickViewData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.pickViewData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.textfield.text = self.pickViewData[row];
    self.subcourseId = self.courseId[row];

}



@end
