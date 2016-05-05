//
//  THHomeworkRecord.h
//  TH-2.0
//
//  Created by Taro on 16/4/23.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THHomeworkRecord : NSObject

@property (nonatomic , strong) NSString * coursePeriod;
@property (nonatomic , strong) NSNumber * courseId;
@property (nonatomic , strong) NSString * courseName;
@property (nonatomic , strong) NSNumber * homeworkRecordWeek;
@property (nonatomic , strong) NSNumber * homeworkRecordId;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)homeworkRecordWithDic:(NSDictionary *)dic;

@end
