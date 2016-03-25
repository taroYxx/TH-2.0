//
//  THMessageText.h
//  TH-2.0
//
//  Created by Taro on 16/3/13.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THMessageText : NSObject

@property (nonatomic , strong) NSNumber * messageId;
@property (nonatomic , strong) NSString * celltext;
@property (nonatomic , strong) NSString * celldetailtext;
@property (nonatomic , strong) NSString * icon;

+ (instancetype)textWithDic:(NSDictionary *)dic;
@end
