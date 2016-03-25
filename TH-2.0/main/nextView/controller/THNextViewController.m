//
//  THNextViewController.m
//  TH-2.0
//
//  Created by Taro on 16/2/28.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THNextViewController.h"
#import "THOrderNameViewController.h"
#import "THDetailViewController.h"
#import "THRepairViewController.h"
#import "THdetailStudent.h"
#import "MBProgressHUD+YXX.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface THNextViewController ()
@property (nonatomic , strong) THOrderNameViewController * orderName;
@property (nonatomic , strong) THDetailViewController * detail;
@property (nonatomic , strong) THRepairViewController * repair;
@property (nonatomic , strong) UISegmentedControl * segment;
@property (nonatomic , strong) NSArray * segmentTitle;
@property (nonatomic , strong) UIView * firstView;

@end

@implementation THNextViewController

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
    THRepairViewController *repair = [[THRepairViewController alloc] init];
    repair.courseId = self.courseId;
    repair.weekOrdinal = self.weekOrdinal;
    repair.Navtitle = self.Navtitle;
    [self.view addSubview:repair.view];
    self.repair = repair;
    [self addSegment];
    [MBProgressHUD showMessage:@"载入中" toView:self.view];
    [self getDataFromServers:^(NSDictionary *dict) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (dict[@"createTime"] == NULL) {
            //没有记录
            [self.segment setTitle:@"点名" forSegmentAtIndex:0];
            [self.segment setTitle:@"补签" forSegmentAtIndex:1];
            THOrderNameViewController *orderName = [[THOrderNameViewController alloc] init];
            orderName.courseId = self.courseId;
            orderName.Navtitle = self.Navtitle;
            orderName.weekOrdinal = self.weekOrdinal;
            self.orderName = orderName;
            [self.view addSubview:self.orderName.view];
            self.firstView = self.orderName.view;
        }else{
            [self.segment setTitle:@"详情" forSegmentAtIndex:0];
            [self.segment setTitle:@"补签" forSegmentAtIndex:1];
            THDetailViewController *detail = [[THDetailViewController alloc] init];
            detail.courseId = self.courseId;
            detail.weekOrdinal = self.weekOrdinal;
            detail.Navtitle = self.Navtitle;
            self.firstView = self.detail.view;
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
            detail.slices = @[absence,leave,late,appear];
            detail.totalModel = tableViewData;
            detail.tableviewData = [detail.totalModel objectAtIndex:0];
               self.detail = detail;
            self.detail.view.tag = 22;
            [self.view addSubview:self.detail.view];
            self.firstView = self.detail.view;
            
            
            UIBarButtonItem *right = [[UIBarButtonItem alloc] init];
            [right setTarget:self];
            [right setAction:@selector(submitAgain)];
            [right setTitle:@"再次点名"];
            self.navigationItem.rightBarButtonItem = right;
            
        }
        
     
    }];

}

- (void)submitAgain{
    for (UIView *sub in self.view.subviews) {
        if (sub.tag == 22) {
            [sub removeFromSuperview];
        }
    }
    
    
    [self.segment setTitle:@"点名" forSegmentAtIndex:0];
    [self.segment setTitle:@"补签" forSegmentAtIndex:1];
    THOrderNameViewController *orderName = [[THOrderNameViewController alloc] init];
    orderName.courseId = self.courseId;
    orderName.Navtitle = self.Navtitle;
    orderName.weekOrdinal = self.weekOrdinal;
    orderName.view.tag = 22;
    self.orderName = orderName;
    [self.view addSubview:self.orderName.view];
    self.firstView = self.orderName.view;
    self.segment.selectedSegmentIndex = 0;
 
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


- (void)addSegment{

    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"点名",@"补签"]];
    [segment setTintColor:YColor(208, 85, 90, 1)];
    [segment setBackgroundColor:[UIColor whiteColor]];
    segment.selectedSegmentIndex = 0;
//    segment.numberOfSegments = 2;
    [segment addTarget:self action:@selector(didSelectSegment) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    self.navigationItem.titleView.frame = CGRectMake(0, 0, 180, 22.2);
    self.segment = segment;
    
}

- (void)didSelectSegment{
    if (self.segment.selectedSegmentIndex == 0) {
        self.firstView.hidden = NO;
        self.repair.view.hidden = YES;
    }else{
        self.firstView.hidden = YES;
        self.repair.view.hidden = NO;
    }
}

- (void)getDataFromServers:(void(^)(NSDictionary  * dict))success{
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

@end
