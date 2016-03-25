//
//  THPresentTableViewController.h
//  TH-2.0
//
//  Created by Taro on 16/3/24.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol THPresentDelegate <NSObject>

//@property (nonatomic , strong) NSString * name;

- (void)PresentsendValue:(NSUInteger)number;

@end
@interface THPresentTableViewController : UITableViewController

@property (nonatomic , strong) NSArray * tableViewData;
@property (nonatomic , weak) id<THPresentDelegate> delegate;
@end
