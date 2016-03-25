//
//  UIFont+Font.m
//  ShoesSeller
//
//  Created by minug on 15/11/8.
//  Copyright © 2015年 minug. All rights reserved.
//

#import "UIFont+Font.h"

@implementation UIFont (Font)

+(UIFont * (^)(CGFloat))systemFont{
    return ^(CGFloat size){
        return [UIFont systemFontOfSize:size];
    };
}

+(UIFont * (^)(CGFloat))boldSystemFont{
    return ^(CGFloat size){
        return [UIFont boldSystemFontOfSize:size];
    };
}

@end
