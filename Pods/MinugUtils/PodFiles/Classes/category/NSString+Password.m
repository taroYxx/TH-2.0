//
//  NSString+Password.m
//  JuHappy
//
//  Created by minug on 15/8/3.
//  Copyright (c) 2015年 plusman. All rights reserved.
//

#import "NSString+Password.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Password)

// 32位MD5加密方式
+(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
