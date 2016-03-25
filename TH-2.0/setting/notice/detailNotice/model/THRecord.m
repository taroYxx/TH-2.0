//
//  THRecord.m
//  TH-2.0
//
//  Created by Taro on 16/3/13.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THRecord.h"

@implementation THRecord


- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.teacherName = dic[@"teacherName"];
        self.courseName = dic[@"courseName"];
        self.courseId = dic[@"courseId"];
        self.courseNo = dic[@"courseNo"];
        self.recordId = dic[@"recordId"];
        self.week = dic[@"week"];
        self.ctime = dic[@"ctime"];
    }
    return self;
}
+ (instancetype)recodeWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}

@end
