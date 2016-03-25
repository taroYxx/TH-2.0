//
//  THNamelistViewController.h
//  TH-2.0
//
//  Created by Taro on 16/3/22.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THNamelistControllerDelegate <NSObject>

//@property (nonatomic , strong) NSString * name;

- (void)sendValue:(NSUInteger )number;

@end

@interface THNamelistViewController : UIViewController


@property (nonatomic , strong) NSArray * studentModel;
@property (nonatomic , weak) id<THNamelistControllerDelegate> delegate;

@end
