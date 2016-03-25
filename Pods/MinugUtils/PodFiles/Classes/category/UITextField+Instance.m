//
//  UITextField+KeyBoard.m
//  ShoesSeller
//
//  Created by minug on 15/11/7.
//  Copyright © 2015年 minug. All rights reserved.
//

#import "UITextField+Instance.h"

@implementation UITextField (Instance)

-(UIKeyboardType)keyBoardType{
    return [self keyboardType];
}

-(void)setKeyBoardType:(UIKeyboardType)keyBoardType{
    self.keyboardType = keyBoardType;
}

-(void)setSecuretextEntry:(BOOL)securetextEntry{
    self.secureTextEntry = securetextEntry;
}

-(BOOL)securetextEntry{
    return [self isSecureTextEntry];
}

@end
