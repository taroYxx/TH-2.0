//  XAlertView.h
//  ShoesSeller
//
//  Created by minug on 15/10/23.
//  Copyright © 2015年 minug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUCommon.h"

@interface XAlertView : NSObject

typedef void(^ConfirmBlock) (NSString *fromWhere);
typedef void(^CancleBlock) (NSString *fromWhere);

// 弹框提醒不带回调事件
+ (void)TTAlert:(NSString *)title message:(NSString *)message;

// 弹框提醒带回调事件
+ (void)TTAlert:(NSString *)title message:(NSString *)message confirmBlock:(ConfirmBlock) block;

// 带取消
+ (void)TTAlertC:(NSString *)title message:(NSString *)message confirmBlock:(ConfirmBlock) block;

+(void)TTAlertC:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles  confirmBlock:(ConfirmBlock) block;

+(void)TTAlertC:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles  confirmBlock:(ConfirmBlock) confirmblock cancelBlock:(CancleBlock)cancelblock;


@end
