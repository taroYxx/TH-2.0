//
//  THTopView.m
//  TH-2.0
//
//  Created by Taro on 16/2/26.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THTopView.h"

@implementation THTopView



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.frame = frame;
    [self addScrollview];
    [self addHeadline];
    return self;
}

- (void)addScrollview{
    if (!self.scrollview) {
        UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,43, self.frame.size.width, self.frame.size.height-43)];
        scrollview.backgroundColor = YColor(241, 241, 241, 1);
//        scrollview.backgroundColor = [UIColor blueColor];
        scrollview.pagingEnabled = YES;
        scrollview.contentSize = CGSizeMake(7*screenW, 0);
        scrollview.delegate = self;
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.bounces = NO;
        //        [scrollview setContentOffset:CGPointMake(scrollview, 0)];
        self.scrollview = scrollview;
        [self addSubview:self.scrollview];
    
    }
}


- (void)addHeadline{
    if (!self.SelectView) {
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW/7, 43)];
        selectView.layer.cornerRadius = 10;
        selectView.backgroundColor = YColor(188, 188, 188, 1);
        self.SelectView = selectView;
        [self addSubview:self.SelectView];
        NSArray *btnTitle = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
        for (int i = 0; i < 7; i++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = i;
            btn.frame = CGRectMake(i*screenW/7, 0, screenW/7, 43);
            btn.backgroundColor = YColor(226, 226, 226, 0.6);
            [btn setTitle:btnTitle[i] forState:UIControlStateNormal];
            [btn setTitleColor:YColor(209, 84, 87, 1) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnToScrollView:) forControlEvents:UIControlEventTouchUpInside];
            self.headBtn = btn;
            [self addSubview:self.headBtn];
            
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat transX = self.scrollview.contentOffset.x / self.scrollview.contentSize.width * screenW;
    [UIView animateWithDuration:0.1 animations:^{
        self.SelectView.transform = CGAffineTransformMakeTranslation(transX, 0);
    }];
}

- (void)btnToScrollView:(UIButton *)sender{
    CGFloat x = sender.tag*screenW;
    [self.scrollview setContentOffset:CGPointMake(x, 0)];
    [UIView animateWithDuration:0.1 animations:^{
        self.SelectView.transform = CGAffineTransformMakeTranslation(screenW/7*sender.tag, 0);
        
    }];
}
@end
