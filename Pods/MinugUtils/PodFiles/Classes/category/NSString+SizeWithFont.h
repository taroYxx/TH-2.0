//
//  NSString+SizeWithFont.h
//  ShoesSeller
//
//  Created by minug on 15/10/27.
//  Copyright © 2015年 minug. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SizeWithFont)

-(CGSize)x_SizeWithFont:(UIFont *)font;
-(CGSize)x_SizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
