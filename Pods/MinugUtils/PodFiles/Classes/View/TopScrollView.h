//
//  TopScrollView.h
//  HXD
//
//  Created by minug on 15/4/3.
//  Copyright (c) 2015年 minug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUCommon.h"

@protocol TopScrollViewDelegate <NSObject>

@optional

-(void)topScrollViewBtnDidChange:(int)numberOfBtn;

@end


@interface TopScrollView : UIScrollView

@property (nonatomic , strong ) NSArray *listArray;
@property (nonatomic , weak) id <TopScrollViewDelegate> listDelegate ;
@property (nonatomic , assign,readonly) NSInteger  selectNum ;

-(void)setTitleColor:(UIColor*)color backColor:(UIColor *)backColor;

-(void)moveLineWithScollView:(UIScrollView *)scrollView;
-(void)moveLineToCurrentBtn;
-(void)changeBtnWithNum:(int)number;
-(void)hideBottomLine;
-(void)moveLineWithBtnNum:(int)num;


@end
