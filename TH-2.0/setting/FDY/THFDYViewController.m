//
//  THFDYViewController.m
//  TH-2.0
//
//  Created by Taro on 16/3/17.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THFDYViewController.h"
#import "THNamelistViewController.h"
#import <MJPopupViewController/UIViewController+MJPopupViewController.h>
#import "THStudentCollectionViewCell.h"
#import "THPresentTableViewController.h"
#import "THMessage.h"
#import "THRecord.h"
#import <MJRefresh/MJRefresh.h>
@interface THFDYViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,THNamelistControllerDelegate,THPresentDelegate>

@property (nonatomic , weak) UICollectionView * collection;
@property (nonatomic , weak) UIButton * button;
@property (nonatomic , weak) UILabel * label;
@property (nonatomic , strong) NSArray * namelist;
@property (nonatomic , strong) NSArray * studentIdArray;
@property (nonatomic , strong) NSArray * classNolist;
@property (nonatomic , strong) THNamelistViewController * namelistController;
@property (nonatomic , strong) NSNumber * pageNo;
@property (nonatomic , strong) NSArray * student;
@property (nonatomic , strong) NSArray * studentModel;
@property (nonatomic , strong) NSArray * totalModel;



@end

@implementation THFDYViewController

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
       self.automaticallyAdjustsScrollViewInsets = NO;
     
    
   
    
//    UIButton *btn = [[UIButton alloc] init];
//    [btn setTitle:@"一班" forState:UIControlStateNormal];
//    [btn setTitleColor:YColor(207, 85, 89, 1) forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(chooseClassNo) forControlEvents:UIControlEventTouchUpInside];
//    btn.frame = CGRectMake(0, 0, 100, 30);
//
//    
//    self.navigationItem.titleView = btn;
//    self.button = btn;
    
//     self.classNolist = @[@"一班",@"三班",@"四班",@"八班"];
//     self.namelist = @[@"张三",@"李四",@"小名",@"AAA"];
     self.studentIdArray = @[@0,@1,@2,@3];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(chooseItem)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UILabel *notext = [[UILabel alloc] init];
    notext.text = @"无信息";
    notext.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:notext];
    [notext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(150, 50));
    }];
    
    [self getDataFromServer:^(NSArray *array) {
        THLog(@"%@",array);
        if (array.count > 0) {
            NSMutableArray *classNoArray = [NSMutableArray array];
            NSMutableArray *totolModel = [NSMutableArray array];
            for (NSDictionary *dict in array) {
                NSNumber *classNo = dict[@"classNo"];
                [classNoArray addObject:classNo];
                
                NSArray *student = dict[@"students"];
                
                NSMutableArray *modelArray = [NSMutableArray array];
                for (NSDictionary *studentDict in student) {
                    NSArray *records = studentDict[@"records"];
                    NSString *studentNo = studentDict[@"studentNo"];
                    NSString *classNo = studentDict[@"classNo"];
                    NSString *major = studentDict[@"major"];
                    NSString *name = studentDict[@"name"];
                    NSNumber *studentId= studentDict[@"studentId"];
                    
                    
                    NSMutableArray *recodeModel = [NSMutableArray array];
                    for (NSDictionary *recodedict in records) {
                        THRecord *recodeM = [THRecord recodeWithDic:recodedict];
                        [recodeModel addObject:recodeM];
                    }
                    NSDictionary *dict1 = @{
                                            @"records" :recodeModel,
                                            @"studentNo" : studentNo,
                                            @"classNo" : classNo,
                                            @"major" : major,
                                            @"name" : name,
                                            @"studentId" : studentId
                                            };
                    THMessage *studentModel = [THMessage messageWithDic:dict1];
                    [modelArray addObject:studentModel];
                }
                self.student = student;
                [totolModel addObject:modelArray];
                //            self.studentModel = modelArray;
            }
            
            self.studentModel = totolModel[0];
            self.totalModel = totolModel;
            self.classNolist = classNoArray;
            if (classNoArray.count > 0) {
                self.navigationItem.title = [NSString stringWithFormat:@"%@班",classNoArray[0]];
            }
            
            UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
            [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 68, screenW-40+5, screenH-68-50)collectionViewLayout:flowlayout];
            flowlayout.itemSize = collectionView.frame.size;
            //清空行距
            flowlayout.minimumLineSpacing = 0;
            [collectionView registerClass:[THStudentCollectionViewCell class] forCellWithReuseIdentifier:@"collect"];
            collectionView.backgroundColor = [UIColor whiteColor];
            
            collectionView.dataSource = self;
            collectionView.delegate = self;
            collectionView.pagingEnabled = YES;
            collectionView.showsHorizontalScrollIndicator = NO;
            
            [self.view addSubview:collectionView];
            self.collection = collectionView;
            self.pageNo = @0;
            [self setClassLabel];

        }
        
  ///
        
        
   }];
    
    
   
    

}


- (void)setClassLabel{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(screenW/3, screenH-50, screenW/3, 30)];
    label.text = [NSString stringWithFormat:@"1/%ld",self.studentModel.count];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = YColor(207, 85, 89, 1);
    [self.view addSubview:label];
    self.label = label;
}

- (void)chooseItem{

    
    
   //设置actionsheet
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil
                                                                                   message:nil
                                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"选择班级"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                      

                                                        [self chooseClassNo];

                                                    }];
    [actionSheetController addAction:action0];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"选择学生"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [self chooseStudent];
                                                   }];
    [actionSheetController addAction:action];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    
    [actionSheetController addAction:actionCancel];
    [actionSheetController.view setTintColor:YColor(207, 85, 89, 1)];
    [self presentViewController:actionSheetController animated:YES completion:nil];
}





- (void)chooseStudent{
    THNamelistViewController *name = [[THNamelistViewController alloc] init];
    name.view.frame = CGRectMake(0, 0, screenW-100, screenW-10);
    name.studentModel = self.studentModel;
    [name setDelegate:self];
    [self presentPopupViewController:name animationType:MJPopupViewAnimationFade];
    self.namelistController = name;
    
}

- (void)chooseClassNo{
    THPresentTableViewController *present = [[THPresentTableViewController alloc] init];
    present.view.frame = CGRectMake(0, 0, screenW-100, screenW-10);
    present.tableViewData = self.classNolist;
    present.delegate = self;
    [self presentPopupViewController:present animationType:MJPopupViewAnimationFade];
    
//    THNamelistViewController *name = [[THNamelistViewController alloc] init];
//    name.view.frame = CGRectMake(0, 0, screenW-100, screenW-10);
//    name.nameArray = self.classNolist;
//    name.studentId = self.studentIdArray;
//    [name setDelegate:self];
//    [self presentPopupViewController:name animationType:MJPopupViewAnimationFade];
//    self.namelistController = name;
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.studentModel.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{

    THStudentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collect" forIndexPath:indexPath];
    THMessage *student = self.studentModel[indexPath.row];
       cell.studentName.label.text = student.name;
       cell.classNo.label.text = student.classNo;
       cell.studentNo.label.text = student.studentNo;
       cell.major.label.text = student.major;
       cell.tableViewData = student.records;

  
//        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, screenW-80, 40)];
//        name.text = self.namelist[indexPath.row];
//    cell.backgroundView = name;
    
        


//    cell.tag = indexPath.row;
//    
//    NSArray *array = @[[UIColor redColor],[UIColor blueColor],[UIColor orangeColor],[UIColor greenColor]];
//    cell.backgroundColor = [array objectAtIndex:rand()%4];
    
    return cell;
    
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(screenW-40,collectionView.frame.size.height);
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page = scrollView.contentOffset.x / (screenW-40+5)+0.1;
    self.pageNo = [NSNumber numberWithInt:page+1];
    self.label.text = [NSString stringWithFormat:@"%@/%ld",self.pageNo,self.studentModel.count];
   
}


- (void)PresentsendValue:(NSUInteger )number{
    self.navigationItem.title = [NSString stringWithFormat:@"%@班",[self.classNolist objectAtIndex:number]];
    self.studentModel = self.totalModel[number];
    [self.collection reloadData];
     [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
     [self.collection setContentOffset:CGPointMake(0, 0) animated:YES];
       self.label.text = [NSString stringWithFormat:@"1/%ld",self.studentModel.count];
}
//
-(void)sendValue:(NSUInteger )number{
//    THLog(@"%@",number);
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    CGFloat x =  number * (screenW-40+5);
    [self.collection setContentOffset:CGPointMake(x, 0) animated:YES];
    self.label.text = [NSString stringWithFormat:@"%ld/%ld",number+1,self.studentModel.count];
  
}

- (void)getDataFromServer:(void(^)( NSArray *array))success{
    NSString *url = [NSString stringWithFormat:@"%@/%@/administrative_class/",host,version];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *result = responseObject[@"classes"];
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
    }];
}

@end
