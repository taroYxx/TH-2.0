//
//  THRecord.h
//  TH-2.0
//
//  Created by Taro on 16/3/13.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THRecord : NSObject

@property (nonatomic , strong) NSString * teacherName;
@property (nonatomic , strong) NSString * courseName;
@property (nonatomic , strong) NSString * courseNo;
@property (nonatomic , strong) NSNumber * courseId;
@property (nonatomic , strong) NSString * ctime;
@property (nonatomic , strong) NSNumber * week;
@property (nonatomic , strong) NSString * recordId;
+ (instancetype)recodeWithDic:(NSDictionary *)dic;
@end
