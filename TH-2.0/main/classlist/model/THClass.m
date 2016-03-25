//
//  THClass.m
//  Teacher-Help
//
//  Created by Taro on 15/10/23.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import "THClass.h"

@implementation THClass


- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.courseName = dic[@"courseName"];
        self.courseNo = dic[@"courseNo"];
        self.venue = dic[@"venue"];
        self.lessonPeriod = dic[@"lessonPeriod"];
        self.courseId = dic[@"courseId"];
        self.weekOrdinal = dic[@"weekOrdinal"];
        self.week = dic[@"week"];
//        [self setValuesForKeysWithDictionary: dic];
    }
    return self;
}
+ (instancetype)classWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}

@end
