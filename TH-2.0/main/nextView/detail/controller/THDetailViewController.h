//
//  THDetailViewController.h
//  TH-2.0
//
//  Created by Taro on 16/2/28.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THDetailViewController : UIViewController
@property (nonatomic , strong) NSNumber * courseId;
@property (nonatomic , strong) NSNumber * weekOrdinal;
@property (nonatomic , copy) NSString * Navtitle;
@property (nonatomic , strong) NSArray * totalModel;
@property (nonatomic , strong) NSArray * tableviewData;
@property (nonatomic , strong) NSArray * slices;
@end
