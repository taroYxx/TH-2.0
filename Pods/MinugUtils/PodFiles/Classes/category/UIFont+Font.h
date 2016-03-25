//
//  UIFont+Font.h
//  ShoesSeller
//
//  Created by minug on 15/11/8.
//  Copyright © 2015年 minug. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Font)

+(UIFont * (^)(CGFloat))systemFont;
+(UIFont * (^)(CGFloat))boldSystemFont;

@end
