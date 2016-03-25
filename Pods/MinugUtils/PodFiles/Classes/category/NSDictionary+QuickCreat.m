//
//  NSMutableDictionary+QuickCreat.m
//  ShoesSeller
//
//  Created by minug on 15/11/6.
//  Copyright © 2015年 minug. All rights reserved.
//

#import "NSDictionary+QuickCreat.h"

@implementation NSDictionary (QuickCreate)

+(instancetype (^)(NSArray *values,NSArray *keys))setValuesAndKeys{
    return ^(NSArray *values , NSArray *keys){
        return [[self alloc] initWithObjects:values forKeys:keys];
    };
}

@end
