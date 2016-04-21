//
//  THStudentCollectionViewCell.h
//  TH-2.0
//
//  Created by Taro on 16/3/23.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconText.h"

@interface THStudentCollectionViewCell : UICollectionViewCell<UITableViewDataSource,UITableViewDelegate>



@property (nonatomic , strong) IconText * studentName;
@property (nonatomic , strong) IconText * studentNo;
@property (nonatomic , strong) IconText * classNo;
@property (nonatomic , strong) IconText * major;
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) NSArray * tableViewData;
@property (nonatomic , weak) UILabel * courseName;
@property (nonatomic , weak) UILabel * teacherName;
@property (nonatomic , weak) UILabel * courseNo;
@property (nonatomic , weak) UILabel * time;
@property (nonatomic , assign) NSInteger tableViewCount;
@end
