//
//  NSMutableDictionary+QuickCreat.h
//  ShoesSeller
//
//  Created by minug on 15/11/6.
//  Copyright © 2015年 minug. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (QuickCreate)

+(instancetype (^)(NSArray *values,NSArray *keys))setValuesAndKeys;

@end
