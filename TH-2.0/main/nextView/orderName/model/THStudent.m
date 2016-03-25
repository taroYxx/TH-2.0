//
//  THStudent.m
//  Teacher-Help
//
//  Created by Taro on 15/10/26.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import "THStudent.h"

@implementation THStudent

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.classNo = dic[@"classNo"];
        self.lateTimes = dic[@"lateTimes"];
        self.major = dic[@"major"];
        self.name = dic[@"name"];
        self.studentNo = dic[@"studentNo"];
        self.studentId = dic[@"studentId"];
        self.lateTimesAtThisClass = dic[@"lateTimesAtThisClass"];
       
        //        [self setValuesForKeysWithDictionary: dic];
    }
    return self;
}
+ (instancetype)studentWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}

@end
