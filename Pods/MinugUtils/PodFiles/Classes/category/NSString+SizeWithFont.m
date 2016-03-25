//
//  NSString+SizeWithFont.m
//  ShoesSeller
//
//  Created by minug on 15/10/27.
//  Copyright © 2015年 minug. All rights reserved.
//

#import "NSString+SizeWithFont.h"

@implementation NSString (SizeWithFont)

-(CGSize)x_SizeWithFont:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName : font}];
}

-(CGSize)x_SizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
