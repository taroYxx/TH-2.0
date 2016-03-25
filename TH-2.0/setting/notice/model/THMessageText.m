//
//  THMessageText.m
//  TH-2.0
//
//  Created by Taro on 16/3/13.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THMessageText.h"

@implementation THMessageText


- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.messageId = dic[@"messageId"];
        self.celltext = dic[@"celltext"];
        self.celldetailtext = dic[@"celldetailtext"];
        self.icon = dic[@"icon"];
    }
    return self;
}
+ (instancetype)textWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}
@end
