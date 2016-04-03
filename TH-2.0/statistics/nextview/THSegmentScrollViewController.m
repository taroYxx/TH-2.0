//
//  THSegmentScrollViewController.m
//  TH-2.0
//
//  Created by Taro on 16/3/29.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THSegmentScrollViewController.h"
#import "THHistoryViewController.h"
#import "THHomeworkViewController.h"
#import "THDetailHistoryViewController.h"




@interface THSegmentScrollViewController ()<UIScrollViewDelegate,THHistory>


@property (nonatomic , weak) UIScrollView * scrollView;
@property (nonatomic , weak) UISegmentedControl * segment;
@property (nonatomic , strong) THHistoryViewController * history;
@property (nonatomic , strong) THHomeworkViewController * homework;
@property (nonatomic , strong) NSArray * weekArray;
@property (nonatomic , strong) NSNumber * weekNumber;


@end

@implementation THSegmentScrollViewController

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    [self addScrollViewToView];
    [self addsegmentToView];
    
//    UIButton *btn = [[UIButton alloc] init];
//    btn.frame = CGRectMake(0, 0, 70, 30);
////    [btn setTitle:@"第一周" forState:UIControlStateNormal];
//    [btn setTitleColor:YColor(207, 85, 89, 1) forState:UIControlStateNormal];
//    btn.hidden = YES;
//    [btn addTarget:self action:@selector(chooseWeek) forControlEvents:UIControlEventTouchUpInside];
//    self.rightBtn = btn;
//    
//    
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.rightBarButtonItem = right;
    
    
//    [self getWeekFromServers:^(NSDictionary *dict) {
//
//        NSArray *week = dict[@"weekList"];
//        if (week.count > 0) {
//            NSString *string = [NSString stringWithFormat:@"第%@周",week[week.count-1]];
//            [self.rightBtn setTitle:string forState:UIControlStateNormal];
//            self.weekArray = week;
//            THHomeworkViewController *homework = [[THHomeworkViewController alloc] init];
//            homework.courseId = self.courseId;
//            homework.courseName = self.courseName;
//            homework.weekNumber = week[week.count-1];
//            homework.view.frame = CGRectMake(screenW, 0, screenW, screenH-64-43);
//            [self.scrollView addSubview:homework.view];
//            self.homework = homework;
//        }
//       
//
//
//    }];
    
    
}
//- (void)chooseWeek{
//    NSMutableArray *mutalArray = [NSMutableArray array];
//    for (NSNumber *number in self.weekArray) {
//        NSString *string = [NSString stringWithFormat:@"第%@周",number];
//        [mutalArray addObject:string];
//    }
//    
//    THPresentTableViewController *present = [[THPresentTableViewController alloc] init];
//    present.tableViewData = mutalArray;
//    present.view.frame = CGRectMake(0, 0, screenW-100, screenW-10);
//    present.delegate = self;
//    [self presentPopupViewController:present animationType:MJPopupViewAnimationFade];
//    
//}

- (void)addsegmentToView{
    NSArray *segmentTitle = @[@"考勤统计",@"平时作业"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:segmentTitle];
    self.segment = segment;
    self.segment.frame = CGRectMake(0, 0, 120, 22.2);
    self.segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = _segment;
    [_segment addTarget:self action:@selector(didSelectSegment:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)addScrollViewToView{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH)];
    scroll.contentSize = CGSizeMake(screenW * 2, screenH);
    scroll.backgroundColor = [UIColor whiteColor];
    scroll.delegate = self;
    scroll.bounces = NO;
    scroll.pagingEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scroll];
    
    

    THHistoryViewController *history = [[THHistoryViewController alloc] init];
    history.courseId = self.courseId;
    history.courseName = self.courseName;
    history.view.frame = CGRectMake(0, 0, screenW, screenH);
    history.delegate = self;
    [scroll addSubview:history.view];
    self.history = history;

    THHomeworkViewController *homework = [[THHomeworkViewController alloc] init];
    homework.courseId = self.courseId;
    homework.courseName = self.courseName;
    homework.view.backgroundColor = [UIColor whiteColor];
    homework.view.frame = CGRectMake(screenW, 0, screenW, screenH);
    [scroll addSubview:homework.view];
    self.homework = homework;

    self.scrollView = scroll;
    
   
    
}



- (void)didSelectSegment:(UISegmentedControl *)seg{
    [self.scrollView setContentOffset:CGPointMake(seg.selectedSegmentIndex * screenW, 0)];
//    if (seg.selectedSegmentIndex == 1) {
//        self.rightBtn.hidden = NO;
//    }else{
//        self.rightBtn.hidden = YES;
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
 
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int x = scrollView.contentOffset.x / screenW;

    self.segment.selectedSegmentIndex = x;
   
//    if (x == 1) {
//        self.rightBtn.hidden = NO;
//    }else{
//        self.rightBtn.hidden = YES;
//    }
    
}

- (void)PresentsendValue:(NSUInteger)icontag nameList:(NSArray *)nameList{
    THDetailHistoryViewController *detail = [[THDetailHistoryViewController alloc] init];
    detail.nameList = nameList;
    detail.courseName = self.courseName;
    detail.icontag = icontag;
    detail.courseId = self.courseId;
    [self.navigationController pushViewController:detail animated:YES];
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

//- (void)PresentsendValue:(NSUInteger)number{
//    THLog(@"%ld",number);
//    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
//  
//}



@end
