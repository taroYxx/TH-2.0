//
//  UITextfield+UIPickView.m
//  TH-2.0
//
//  Created by Taro on 16/3/3.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "UITextfield+UIPickView.h"

@implementation UITextfield_UIPickView

- (instancetype)initWithFrame:(CGRect)frame :(NSArray *)pickdata :(NSArray *)subdataArray {
    if (self = [super initWithFrame:frame]) {
        self.pickdata = pickdata;
        self.subdataArray = subdataArray;
        self.borderStyle = UITextBorderStyleRoundedRect;
        UIPickerView *pickview = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, screenW, 150)];
        pickview.delegate = self;
        pickview.dataSource = self;
        pickview.backgroundColor = YColor(235, 235, 241, 1);
        self.inputView = pickview;
        self.pickview = pickview;
        UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, 44)];
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(toolbarDone)];
        done.tintColor = YColor(208, 86, 90, 1);
        UIBarButtonItem *Flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        doneToolbar.items = @[Flexible,done];
        self.inputAccessoryView = doneToolbar;
        self.delegate = self;
        self.text = self.pickdata[0];
        
        
    }
    return self;
}
- (void)toolbarDone{
    [self endEditing:YES];
    THLog(@"%@",self.subdata);
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    self.text = self.pickdata[0];
//    
//}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickdata.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.pickdata[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.text = self.pickdata[row];
    self.subdata = self.subdataArray[row];
}

@end
