//
//  THSettingGroup.h
//  Teacher-Help
//
//  Created by Taro on 15/11/20.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THSettingGroup : NSObject
@property (nonatomic , strong) NSString * headerTitle;
@property (nonatomic , strong) NSString * footerTitle;
@property (nonatomic , strong) NSArray * items;
@end
