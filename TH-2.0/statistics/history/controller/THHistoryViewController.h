//
//  THHistoryViewController.h
//  TH-2.0
//
//  Created by Taro on 16/3/1.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THHistory <NSObject>

//@property (nonatomic , strong) NSString * name;

- (void)PresentsendValue :(NSUInteger)icontag nameList:(NSArray *)nameList;

@end



@interface THHistoryViewController : UIViewController
@property (nonatomic , copy) NSString * courseName;
@property (nonatomic , strong) NSNumber * courseId;
@property (nonatomic , weak) id<THHistory> delegate;

@end
