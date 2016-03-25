
//  CommonBtnFooterView.h
//  ShoesSeller
//
//  Created by minug on 15/11/5.
//  Copyright © 2015年 minug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUCommon.h"

@class CommonBtn;

@interface CommonBtnFooterView : UIView

@property (nonatomic , weak) CommonBtn * btn ;

-(instancetype)initWithTitle:(NSString *)title leftPad:(CGFloat)pad;


@end
