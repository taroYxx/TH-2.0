//
//  IconText.m
//  TH-2.0
//
//  Created by Taro on 16/3/23.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "IconText.h"

@implementation IconText

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        

        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, self.frame.size.height-6, self.frame.size.height-6)];
        [self addSubview:self.imageView];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
//        self.backgroundColor = [UIColor redColor];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [YColor(207, 85, 89, 1) CGColor];
        
    }
    return self;
}


@end
