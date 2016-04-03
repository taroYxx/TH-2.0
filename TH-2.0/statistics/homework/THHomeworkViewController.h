//
//  THHomeworkViewController.h
//  TH
//
//  Created by Taro on 15/12/3.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THHomeworkViewController : UIViewController
@property (nonatomic , strong) NSNumber * courseId;
@property (nonatomic , copy) NSString * courseName;
@property (nonatomic , strong) NSNumber * weekNumber;
@property (nonatomic , weak) UITableView * tableView;
@end
