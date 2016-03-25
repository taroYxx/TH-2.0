//
//  THSettingTableViewController.h
//  Teacher-Help
//
//  Created by Taro on 15/11/20.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface THSettingTableViewController : UITableViewController

@property (nonatomic , copy) NSString * name;
@property (nonatomic , strong) NSNumber * teacherNO;
@property (nonatomic , strong) NSArray * classlist;
@property (nonatomic , strong) NSArray * noticeData;


@end
