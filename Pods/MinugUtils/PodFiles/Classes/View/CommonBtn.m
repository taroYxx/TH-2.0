
//  CommonBtn.m
//  ShoesSeller
//
//  Created by minug on 15/10/29.
//  Copyright © 2015年 minug. All rights reserved.
//

#import "CommonBtn.h"

@implementation CommonBtn

-(instancetype)initWithString:(NSString *)str{
    if (self = [super init]) {
        self.layer.cornerRadius = 5.0f;
        [self setTitle:str forState:UIControlStateNormal];
        self.clipsToBounds = YES;
        [self setBackgroundImage:[UIImage imageNamed:@"redBack1"] forState:UIControlStateNormal];
    }
    return self;
}

@end
