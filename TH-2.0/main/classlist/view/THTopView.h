//
//  THTopView.h
//  TH-2.0
//
//  Created by Taro on 16/2/26.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THTopView : UIView<UIScrollViewDelegate>
@property (nonatomic , strong) UIScrollView * scrollview;
@property (nonatomic , strong) UIView * SelectView;
@property (nonatomic , strong) UIButton * headBtn;

@end
