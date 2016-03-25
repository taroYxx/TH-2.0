//
//  XViewController.h
//  ShoesSeller
//
//  Created by minug on 15/11/7.
//  Copyright © 2015年 minug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUCommon.h"

@class CommonBtnFooterView;

@interface XViewController : UIViewController <UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , weak) UITableView * tableView ;
@property (nonatomic , weak) CommonBtnFooterView * footView ;

@property (nonatomic , strong) NSArray *cellModel ;

-(void)setFootViewWithText:(NSString *)text margin:(CGFloat)margin;
-(void)configureInitCell:(UITableViewCell *)cell tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath ;

@end
