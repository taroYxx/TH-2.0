//
//  NSString+RegularExpression.h
//  JuHappy
//
//  Created by minug on 15/5/18.
//  Copyright (c) 2015年 plusman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegularExpression)

-(NSString *)replaceRegularExpression:(NSString *)regularExpression placeholder:(NSString *)placeholder;
-(BOOL)searchRegularExpression:(NSString *)regularExpression;

-(BOOL)isPhoneNumber;

-(NSString *)replaceString:(NSString *)str withPlaceholderString:(NSString *)placeStr;
-(NSString *)replaceStringS:(NSArray *)strArray withPlaceholderString:(NSString *)placeStr;

@end
