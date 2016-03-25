//
//  NSString+Password.h
//  JuHappy
//
//  Created by minug on 15/8/3.
//  Copyright (c) 2015年 plusman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Password)

// md5 字符串加密
+(NSString *) md5:(NSString *)str;

@end
