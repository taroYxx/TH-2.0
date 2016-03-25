
//  XTableViewCell.m
//  ShoesSeller
//
//  Created by minug on 15/11/21.
//  Copyright © 2015年 minug. All rights reserved.
//

#import "XTableViewCell.h"

@implementation XTableViewCell


-(UILabel *)rightL{
    if (!_rightL) {
        UILabel *rightL = [[UILabel alloc] init];
        [self.contentView addSubview:rightL];
        _rightL = rightL;
    }
    return _rightL;
}

-(UILabel *)leftL{
    if (!_leftL) {
        UILabel *leftL = [[UILabel alloc] init];
        [self.contentView addSubview:leftL];
        _leftL = leftL;
    }
    return _leftL;
}

-(UIImageView *)imageV{
    if (!_imageV) {
        UIImageView *imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:imageV];
        _imageV = imageV;
    }
    return _imageV;
}

-(UIView *)line{
    if (!_line) {
        UIView *line = [[UIView alloc] init];
        _line = line;
        [self.contentView addSubview:_line];
    };
    return _line;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier ]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
