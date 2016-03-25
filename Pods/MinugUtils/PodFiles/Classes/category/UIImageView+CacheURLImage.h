//
//  UIImageView+cacheURLImage.h
//  JuHappy
//
//  Created by minug on 15/8/1.
//  Copyright (c) 2015年 minug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUCommon.h"

@interface UIImageView (CacheURLImage)

-(void)x_setImageWithUrl:(NSURL *)url placeholder:(UIImage *)placeholder;

@end
