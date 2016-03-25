
//  CommonBtnFooterView.m
//  ShoesSeller
//
//  Created by minug on 15/11/5.
//  Copyright © 2015年 minug. All rights reserved.
//

#import "CommonBtnFooterView.h"
#import "CommonBtn.h"

@implementation CommonBtnFooterView

-(instancetype)initWithTitle:(NSString *)title leftPad:(CGFloat)pad{
    if (self = [super init]) {
        CommonBtn *btn = [[CommonBtn alloc] initWithString:title];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-8);
            make.centerY.equalTo(self);
            make.width.equalTo(@(SCREEN_WIDTH - 2*pad));
            make.centerX.equalTo(self);
        }];
        self.btn = btn;
    }
    return self;
}

-(void)setConfigureArray:(NSDictionary *)dict{
    
}

@end
