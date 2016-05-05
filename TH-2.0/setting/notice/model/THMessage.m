//
//  THMessage.m
//  TH-2.0
//
//  Created by Taro on 16/3/11.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THMessage.h"

@implementation THMessage
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.classNo = dic[@"classNo"];
        self.major = dic[@"major"];
        self.name = dic[@"name"];
        self.studentNo = dic[@"studentNo"];
        self.studentId = dic[@"studentId"];
        self.records = dic[@"records"];
        self.recordString = dic[@"recordString"];
        self.state = dic[@"state"];
        self.period = dic[@"period"];
        
        //        [self setValuesForKeysWithDictionary: dic];
    }
    return self;
}
+ (instancetype)messageWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}
@end
