//
//  THSettingItem.h
//  Teacher-Help
//
//  Created by Taro on 15/11/20.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THSettingItem : NSObject

@property (nonatomic , strong) NSString * title;
@property (nonatomic , weak) UIViewController * nextController;
@property (nonatomic , strong) UIImage * iconImage;
@property (nonatomic , strong) UILabel * label;

+ (instancetype)itemWithTitle:(NSString *)title;
@end
