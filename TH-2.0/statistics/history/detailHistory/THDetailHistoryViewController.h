//
//  THDetailHistoryViewController.h
//  TH-2.0
//
//  Created by Taro on 16/3/5.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THDetailHistoryViewController : UIViewController

@property (nonatomic , copy) NSString * courseName;
@property (nonatomic , strong) NSArray * nameList;
@property (nonatomic , assign) NSInteger icontag;
@property (nonatomic , strong) NSNumber * courseId;

@end
