//
//  THNoticeCellTableViewCell.h
//  TH-2.0
//
//  Created by Taro on 16/3/13.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNoticeCellTableViewCell : UITableViewCell

@property (nonatomic , weak) UILabel * name;
@property (nonatomic , weak) UILabel * studentNo;
@property (nonatomic , weak) UILabel * major;
@property (nonatomic , weak) UILabel * classNo;
@property (nonatomic , weak) UILabel * record;
@property (nonatomic , weak) UILabel * state;
- (void)setlableTextname :(NSString *)name studentmajor:(NSString *)studentmajor classNo:(NSString *)classNo studentNo:(NSString *)studentNo record:(NSString *)record;
- (void)setStateText:(NSString *)string;
@end
