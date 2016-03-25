//
//  MBProgressHUD+XBX.m
//  HXD
//
//  Created by minug on 15/4/2.
//  Copyright (c) 2015年 minug. All rights reserved.
//

#import "MBProgressHUD+XBX.h"

@implementation MBProgressHUD (XBX)

+(void)showWithView:(UIView *)view Text:(NSString *)text hideDelayTime:(NSTimeInterval)time{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationFade;
    [hud show:YES];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}

+(void)showSuccessWithView:(UIView *)view Text:(NSString *)text hideDelayTime:(NSTimeInterval)time{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.customView = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"success"]];
    [self makeHudCustomViewMode:hud view:view Text:text hideDelayTime:time];
}

+(void)showFailWithView:(UIView *)view Text:(NSString *)text hideDelayTime:(NSTimeInterval)time{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.customView = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:@"error"]];
    [self makeHudCustomViewMode:hud view:view Text:text hideDelayTime:time];
}

+(void)makeHudCustomViewMode:(MBProgressHUD *)hud view:(UIView *)view Text:(NSString *)text hideDelayTime:(NSTimeInterval)time{
    [view addSubview:hud];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationFade;
    [hud show:YES];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}


@end
