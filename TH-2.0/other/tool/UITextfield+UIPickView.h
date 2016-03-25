//
//  UITextfield+UIPickView.h
//  TH-2.0
//
//  Created by Taro on 16/3/3.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextfield_UIPickView : UITextField<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic , weak) UIPickerView * pickview;
@property (nonatomic , strong) NSArray * pickdata;
@property (nonatomic , strong) NSArray * subdataArray;
@property (nonatomic , strong) NSNumber * subdata;


- (instancetype)initWithFrame:(CGRect)frame :(NSArray *)pickdata :(NSArray *)subdataArray;

@end
