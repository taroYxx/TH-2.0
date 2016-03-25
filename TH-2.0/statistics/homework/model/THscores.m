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
    
        self.name = dic[@"name"];
        self.studentNo = dic[@"studentNo"];
        self.classNo = dic[@"classNo"];
        self.major = dic[@"major"];
        self.score = dic[@"score"];
        
        //        [self setValuesForKeysWithDictionary: dic];
    }
    return self;
}
+ (instancetype)scoresWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}


@end
