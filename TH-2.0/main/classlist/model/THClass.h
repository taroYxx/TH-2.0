//
//  THClass.h
//  Teacher-Help
//
//  Created by Taro on 15/10/23.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THClass : NSObject
@property (nonatomic , copy) NSString * courseName;
@property (nonatomic , copy) NSString * courseNo;
@property (nonatomic , copy) NSString * venue;
@property (nonatomic , strong) NSNumber *week;
@property (nonatomic , strong) NSString * lessonPeriod;
@property (nonatomic , strong) NSNumber * courseId;
@property (nonatomic , strong) NSNumber * weekOrdinal;
@property (nonatomic , strong) NSNumber * singleOrDouble;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)classWithDic:(NSDictionary *)dic;

@end
