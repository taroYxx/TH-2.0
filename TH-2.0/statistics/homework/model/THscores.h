//
//  THscores.h
//  TH
//
//  Created by Taro on 15/12/9.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THscores : NSObject
@property (nonatomic , copy) NSString * studentName;
@property (nonatomic , strong) NSNumber * studentId;
@property (nonatomic , strong) NSNumber * studentNo;
@property (nonatomic , strong) NSNumber * score;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)scoresWithDic:(NSDictionary *)dic;

@end
