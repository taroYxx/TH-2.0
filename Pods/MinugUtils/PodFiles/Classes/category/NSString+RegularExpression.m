//
//  NSString+RegularExpression.m
//  JuHappy
//
//  Created by minug on 15/5/18.
//  Copyright (c) 2015年 plusman. All rights reserved.
//

#import "NSString+RegularExpression.h"

@implementation NSString (RegularExpression)

-(NSString *)replaceRegularExpression:(NSString *)regularExpression placeholder:(NSString *)placeholder{
    
    NSMutableString *mstr = [NSMutableString stringWithString:self];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression options:0 error:nil];
    NSTextCheckingResult *firstmatch = [regex firstMatchInString:mstr options:0 range:NSMakeRange(0, mstr.length)];
    NSRange range = [firstmatch rangeAtIndex:0];
    NSString *result = [mstr substringWithRange:range];
    while (result.length) {
        NSTextCheckingResult *firstmatch = [regex firstMatchInString:mstr options:0 range:NSMakeRange(0, mstr.length)];
        NSRange range = [firstmatch rangeAtIndex:0];
        result = [mstr substringWithRange:range];
        [mstr replaceCharactersInRange:range withString:placeholder];
    }
    return mstr;

}

-(BOOL)searchRegularExpression:(NSString *)regularExpression{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression options:0 error:nil];
    NSTextCheckingResult *firstmatch = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    NSRange range = [firstmatch rangeAtIndex:0];
    return range.length;
    
}

-(BOOL)isPhoneNumber{
    if (!self.length) {
        return NO;
    }
    return ![self replaceRegularExpression:@"^((\\+86)|(86))?1[34578]\\d{9}$" placeholder:@""].length;
}

-(NSString *)replaceString:(NSString *)str withPlaceholderString:(NSString *)placeStr{
    NSMutableString *result = [NSMutableString stringWithString:self];
    
    NSRange range = [result rangeOfString:str];
    while (range.length) {
        [result replaceCharactersInRange:range withString:placeStr];
        range = [result rangeOfString:str];
    }
    return [NSString stringWithString:result];
}

-(NSString *)replaceStringS:(NSArray *)strArray withPlaceholderString:(NSString *)placeStr{
    NSMutableString *result = [NSMutableString stringWithString:self];
    NSRange range;
    for (NSString *str in strArray) {
        range = [result rangeOfString:str];
        while (range.length) {
            [result replaceCharactersInRange:range withString:placeStr];
            range = [result rangeOfString:str];
        }
    }
    return [NSString stringWithString:result];
}



@end
