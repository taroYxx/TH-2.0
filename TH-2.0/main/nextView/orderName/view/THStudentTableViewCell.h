//
//  THStudentTableViewCell.h
//  TH-2.0
//
//  Created by Taro on 16/2/28.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THStudentTableViewCell : UITableViewCell


@property (nonatomic , strong) UIImage * iconimage;

- (void)changeCellIconWith :(UIImage *)icon;
@end
