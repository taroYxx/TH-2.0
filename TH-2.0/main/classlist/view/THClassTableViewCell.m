//
//  THClassTableViewCell.m
//  TH-2.0
//
//  Created by Taro on 16/2/27.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THClassTableViewCell.h"

@implementation THClassTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *timeOfClass = [[UILabel alloc] initWithFrame:CGRectMake(16, 40.6, 50, 20)];
        timeOfClass.font = [UIFont systemFontOfSize:13.8];
        timeOfClass.adjustsFontSizeToFitWidth = YES;
        self.timeOfClass = timeOfClass;
        [self addSubview:self.timeOfClass];
        UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(screenW/2+10, 40.6, screenW/2-10, 16)];
        location.font = [UIFont systemFontOfSize:11.4];
        location.textColor = YColor(138, 138, 138, 1);
        //        location.adjustsFontSizeToFitWidth = YES;
        self.location = location;
        [self addSubview:self.location];
    }
    return self;
}


@end
