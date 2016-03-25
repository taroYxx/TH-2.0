//
//  THStudent.h
//  Teacher-Help
//
//  Created by Taro on 15/10/26.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THStudent : NSObject
@property (nonatomic , strong) NSNumber * classNo;
@property (nonatomic , strong) NSNumber * lateTimes;
@property (nonatomic , strong) NSNumber * lateTimesAtThisClass;
@property (nonatomic , strong) NSString * major;
@property (nonatomic , strong) NSString * name;
@property (nonatomic , strong) NSNumber * studentNo;
@property (nonatomic , strong) NSNumber * studentId;


- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)studentWithDic:(NSDictionary *)dic;

@end
