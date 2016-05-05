//
//  THHomeworkRecord.m
//  TH-2.0
//
//  Created by Taro on 16/4/23.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THHomeworkRecord.h"

@implementation THHomeworkRecord


- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        
        self.coursePeriod = dic[@"coursePeriod"];
        self.courseId = dic[@"courseId"];
        self.courseName = dic[@"courseName"];
        self.homeworkRecordWeek = dic[@"homeworkRecordWeek"];
        self.homeworkRecordId = dic[@"homeworkRecordId"];
        
        
    }
    return self;
}
+ (instancetype)homeworkRecordWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}
@end
