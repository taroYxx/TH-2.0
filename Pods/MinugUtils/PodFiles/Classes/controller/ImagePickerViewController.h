//
//  ImagePickerViewController.h
//  ShoesSeller
//
//  Created by minug on 15/11/21.
//  Copyright © 2015年 minug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUCommon.h"

@interface ImagePickerViewController : UIImagePickerController 


+(NSString *)imagePickerNotification;

-(void)showWithSourceType:(NSUInteger)sourceType;

-(void)actionSheetShowInView:(UIView *)view;

@end
