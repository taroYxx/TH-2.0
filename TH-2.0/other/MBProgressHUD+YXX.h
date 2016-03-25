//
//  MBProgressHUD+YXX.h
//  WD-teacher
//
//  Created by Taro on 15/10/17.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (YXX)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+(void)showSuccess:(NSString *)success;
+(void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
