//
//  UIViewController+DIYNavigationbarViewController.m
//  ShoesSeller
//
//  Created by minug on 11/12/15.
//  Copyright © 2015 minug. All rights reserved.
//

#import "UIViewController+DIYNavigationbarViewController.h"

@implementation UIViewController (DIYNavigationbarViewController)

-(UIView *)diyNavigationbar{
    UIView *navigationBar =[[UIView alloc] init];
    [self.view addSubview:navigationBar];
    [navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    return navigationBar;
}

@end
