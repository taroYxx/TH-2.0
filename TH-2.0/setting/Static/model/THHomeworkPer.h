//
//  THHomeworkPer.h
//  TH-2.0
//
//  Created by Taro on 16/4/23.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THHomeworkPer : NSObject


@property (nonatomic , strong) NSString * courseName;
@property (nonatomic , strong) NSNumber * deduct_points;
@property (nonatomic , strong) NSString * homeworkper;
@property (nonatomic , strong) NSNumber * courseId;
- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)HomeWorkPerWithDic:(NSDictionary *)dic;
@end
