
//  XAlertView.m
//  ShoesSeller
//
//  Created by minug on 15/10/23.
//  Copyright © 2015年 minug. All rights reserved.
//

#import "XAlertView.h"

static XAlertView  *sharedAlertView;
ConfirmBlock oBlock;
CancleBlock cBlock;;

@interface XAlertView () <UIAlertViewDelegate>

@end

@implementation XAlertView

+(void)initialize{
    static dispatch_once_t sessitonOneToken;
    
    dispatch_once(&sessitonOneToken, ^{
        sharedAlertView = [[self alloc] init];
    });
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static XAlertView *instance;
    
    // dispatch_once是线程安全的，onceToken默认为0
    static dispatch_once_t onceToken;
    // dispatch_once宏可以保证块代码中的指令只被执行一次
    dispatch_once(&onceToken, ^{
        // 在多线程环境下，永远只会被执行一次，instance只会被实例化一次
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}

#pragma mark - 提醒事件
+ (void)TTAlert:(NSString *)title message:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    
    [alert show];
}

#pragma mark - 带回调事件
+ (void)TTAlert:(NSString *)title message:(NSString *)message confirmBlock:(ConfirmBlock) block{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    
    oBlock = block;
    
    [alert show];
}


#pragma mark - 带回调事件，带取消
+ (void)TTAlertC:(NSString *)title message:(NSString *)message confirmBlock:(ConfirmBlock) block{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    
    oBlock = block;
    
    [alert show];
}

+(void)TTAlertC:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles  confirmBlock:(ConfirmBlock) block{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    
    oBlock = block;
    
    [alert show];
}

+(void)TTAlertC:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles  confirmBlock:(ConfirmBlock) confirmblock cancelBlock:(CancleBlock)cancelblock{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    
    oBlock = confirmblock;
    cBlock = cancelblock;
    
    [alert show];
    
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (oBlock) {
        if((long)alertView.numberOfButtons == 2){
            if ((long)buttonIndex == 1) {
                if (oBlock) {
                    oBlock(@"okClick");
                }
            }else if ((int)buttonIndex == 0 ){
                if (cBlock) {
                    cBlock(@"");
                }
            }
        }else{
            if (oBlock) {
                oBlock(@"okClick");
            }
        }
    }
    cBlock = nil;
    oBlock = nil;
}

@end
