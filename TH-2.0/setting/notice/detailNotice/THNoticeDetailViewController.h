//
//  THNoticeDetailViewController.h
//  TH-2.0
//
//  Created by Taro on 16/3/2.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THAbsenceMessage.h"

@interface THNoticeDetailViewController : UIViewController


@property (nonatomic , strong) THAbsenceMessage * absenceMessage;
@property (nonatomic , strong) NSNumber * messageId;

@end
