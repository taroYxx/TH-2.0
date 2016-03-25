//
//  THSettingItem.m
//  Teacher-Help
//
//  Created by Taro on 15/11/20.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import "THSettingItem.h"

@implementation THSettingItem


+ (instancetype)itemWithTitle:(NSString *)title{
    THSettingItem *item = [[THSettingItem alloc] init];
    item.title = title;
    return item;
}


@end
