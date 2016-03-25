//
//  YuButton.m
//  TH-2.0
//
//  Created by Taro on 16/3/5.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "YuButton.h"

@implementation YuButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIButton *button = [[UIButton alloc] init];
        [button.layer setCornerRadius:10.0];
                
    }
    return  self;
}

@end
