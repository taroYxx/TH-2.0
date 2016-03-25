//
//  THStudentTableViewCell.m
//  TH-2.0
//
//  Created by Taro on 16/2/28.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THStudentTableViewCell.h"

@implementation THStudentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      

        self.iconimage = [UIImage imageNamed:@"green_status"];
        UIImageView *icon = [[UIImageView alloc] initWithImage:self.iconimage];
        icon.frame = CGRectMake(screenW-10-30, (self.frame.size.height-30)/2, 30, 30);
        self.accessoryView = icon;
        
    }
    return self;
}

- (void)changeCellIconWith :(UIImage *)icon{
    self.iconimage = icon;
    UIImageView *iconView = [[UIImageView alloc] initWithImage:self.iconimage];
    self.accessoryView = iconView;
}

@end
