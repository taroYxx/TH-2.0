//
//  UIViewController+UnSelectTableCell.m
//  ShoesSeller
//
//  Created by minug on 15/10/22.
//  Copyright © 2015年 minug. All rights reserved.
//

#import "UIViewController+DeSelectTableCell.h"

@implementation UIViewController (DeSelectTableCell)

-(void)deSeleceTableViewCell:(UITableView *)tableView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        }];
    });
}

@end
