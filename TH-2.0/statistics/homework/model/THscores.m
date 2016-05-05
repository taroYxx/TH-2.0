//
//  THscores.m
//  TH
//
//  Created by Taro on 15/12/9.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import "THscores.h"

@implementation THscores
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
    
        self.studentName = dic[@"studentName"];
        self.studentNo = dic[@"studentNo"];
        self.studentId = dic[@"studentId"];
        self.score = dic[@"score"];
        
        //        [self setValuesForKeysWithDictionary: dic];
    }
    return self;
}
+ (instancetype)scoresWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}


@end
