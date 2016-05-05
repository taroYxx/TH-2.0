//
//  THHomeworkPer.m
//  TH-2.0
//
//  Created by Taro on 16/4/23.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THHomeworkPer.h"

@implementation THHomeworkPer


- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.courseName = dic[@"courseName"];
        self.deduct_points = dic[@"deduct_points"];
        self.homeworkper = dic[@"homeworkper"];
        self.courseId = dic[@"courseId"];
    //        [self setValuesForKeysWithDictionary: dic];
    }
    return self;
}
+ (instancetype)HomeWorkPerWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}
@end
