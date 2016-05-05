//
//  THMessage.h
//  TH-2.0
//
//  Created by Taro on 16/3/11.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THMessage : NSObject
@property (nonatomic , strong) NSString * classNo;
@property (nonatomic , strong) NSString * major;
@property (nonatomic , strong) NSString * name;
@property (nonatomic , strong) NSString * studentNo;
@property (nonatomic , strong) NSNumber * studentId;
@property (nonatomic , strong) NSArray * records;
@property (nonatomic , strong) NSString * recordString;
@property (nonatomic , strong) NSNumber * state;
@property (nonatomic , strong) NSNumber * period;


- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)messageWithDic:(NSDictionary *)dic;
@end
