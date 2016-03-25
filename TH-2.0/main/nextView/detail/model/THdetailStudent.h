//
//  THdetailStudent.h
//  TH
//
//  Created by Taro on 15/12/5.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THdetailStudent : NSObject
@property (nonatomic , strong) NSString * name;
@property (nonatomic , strong) NSNumber * studentId;
@property (nonatomic , strong) NSNumber * latetime;
@property (nonatomic , strong) NSNumber * arrive;
@property (nonatomic , strong) NSString * studentNo;
- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)detailWithDic:(NSDictionary *)dic;
@end
