
//  XButton.m
//  ShoesSeller
//
//  Created by minug on 15/10/27.
//  Copyright © 2015年 minug. All rights reserved.
//

#import "XButton.h"

@implementation XButton

-(UILabel *)titleL{
    if (!_titleL) {
        UILabel *l = [[UILabel alloc] init];
        _titleL = l;
        [self addSubview:_titleL];
    }
    return _titleL;
}

-(UIImageView *)imageV{
    if (!_imageV) {
        UIImageView *v = [[UIImageView alloc] init];
        _imageV = v;
        [self addSubview:v];
    }
    return _imageV;
}

-(UIView *)line{
    if (!_line) {
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        _line = line;
    }
    return _line;
}

@end
