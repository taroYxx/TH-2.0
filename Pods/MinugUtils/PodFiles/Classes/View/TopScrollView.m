//
//  TopScrollView.m
//  HXD
//
//  Created by minug on 15/4/3.
//  Copyright (c) 2015年 minug. All rights reserved.
//

#import "TopScrollView.h"

#define btnColor XColor(203, 43, 61, 1.0)
#define btnWidth 100
#define bottomLineH 2
#define padding (0.6 * btnWidth)
#define MaxBtnCount 4

@interface TopScrollView ()

@property (nonatomic , weak) UIView * bottomLine ;
@property (nonatomic , strong) NSMutableArray *btnArray;
@property (nonatomic , weak) UIButton * currentBtn ;
@property (nonatomic , assign) CGFloat btnW ;

@end

@implementation TopScrollView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame ]) {
        [self setup];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = XColor(246, 246, 246 , 1);
}

-(void)setListArray:(NSArray *)listArray{
    _listArray = listArray;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *bottomLine = [[UIView alloc] init];
    self.bottomLine = bottomLine;
    bottomLine.backgroundColor = btnColor;
    [self addSubview:bottomLine];
    
    for (int i = 0;i<listArray.count ; i++) {
        UIButton *btn = [self navlistBtnWithName:listArray[i]];
        [self addSubview:btn];
        [self.btnArray addObject:btn];
        btn.tag = i;
        
        if (i == 0) {
            self.currentBtn = btn;
        }
    }
    
    CGRect frame = self.frame;
    
    
    NSInteger btncount = self.btnArray.count;
    CGFloat btnY = 0;
    CGFloat btnW = frame.size.width / btncount ;
    CGFloat btnH = frame.size.height - bottomLineH;
    if (btncount > MaxBtnCount ) {
        btnW = btnWidth;
        self.btnW = btnW;
        self.scrollEnabled = YES;
        self.contentSize = CGSizeMake(MAX(frame.size.width, btnWidth * btncount), frame.size.height);
    }else{
        self.btnW = btnW;
        self.scrollEnabled = NO;
    }
    for (int i = 0; i<btncount; i++) {
        UIButton *btn = self.btnArray[i];
        btn.frame = CGRectMake(btnW * i, 0, btnW, btnH);
    }
    self.bottomLine.frame = CGRectMake(0, btnY + btnH , btnW, bottomLineH);
    
}

-(void)btnDidTouch:(UIButton *)btn{
    self.currentBtn = btn;
    _selectNum = btn.tag;
    if ([self.listDelegate respondsToSelector:@selector(topScrollViewBtnDidChange:)]) {
        [self.listDelegate topScrollViewBtnDidChange:(int)btn.tag ];
    }
}

-(void)setCurrentBtn:(UIButton *)currentBtn{
    _currentBtn.selected = NO;
    _currentBtn = currentBtn;
    _currentBtn.selected = YES;
}

-(void)moveLineToCurrentBtn{
    if (!self.bottomLine) {
        return;
    }
    
    BOOL left = self.bottomLine.frame.origin.x >= self.contentOffset.x;
    BOOL right = (CGRectGetMaxX(self.bottomLine.frame)) <= (self.contentOffset.x +SCREEN_WIDTH);
    if (!self.scrollEnabled){
        return;
    }
    if (!right) {
        CGFloat rightX = CGRectGetMaxX(self.bottomLine.frame) - (self.contentOffset.x +SCREEN_WIDTH) + padding;
        CGFloat pad = self.contentOffset.x + rightX ;
        
        //解决超界的问题
        if (CGRectGetMaxX(self.bottomLine.frame)+rightX>self.contentSize.width) {
            pad = self.contentSize.width - SCREEN_WIDTH;
        }
        
        [self setContentOffset:CGPointMake(pad , self.contentOffset.y) animated:YES];
        return;
    }else if (!left){
        CGFloat leftX = self.contentOffset.x - self.bottomLine.frame.origin.x + padding;
        CGFloat pad = self.contentOffset.x -leftX;
        if (pad<0) {
            pad = 0;
        }
        [self setContentOffset:CGPointMake(pad, self.contentOffset.y) animated:YES];
        return;
    }
}

-(void)moveLineWithBtnNum:(int)num{
    if (!self.bottomLine) {
        return;
    }
    CGRect f = self.bottomLine.frame;
    f.origin.x = num * self.btnW;
    self.bottomLine.frame = f;
}


-(void)moveLineWithScollView:(UIScrollView *)scrollView{
    if (!self.bottomLine) {
        return;
    }
    CGFloat lineWidth = self.bottomLine.frame.size.width;
    CGFloat lineX = scrollView.contentOffset.x / scrollView.contentSize.width *self.btnArray.count;
    self.bottomLine.transform = CGAffineTransformMakeTranslation(lineWidth * lineX,0);
}
-(void)changeBtnWithNum:(int)number{
    self.currentBtn.selected = NO;
    UIButton *btn = self.btnArray[number];
    _selectNum = number;
    self.currentBtn = btn;
    btn.selected = YES;
}

-(void)setTitleColor:(UIColor*)color backColor:(UIColor *)backColor{
    self.backgroundColor = backColor;
    self.bottomLine.backgroundColor = color;
    for (UIButton *btn in self.btnArray) {
        [btn setTitleColor:color forState:UIControlStateSelected];
    }
}

-(NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

-(UIButton *)navlistBtnWithName:(NSString *)name{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:btnColor forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(btnDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)hideBottomLine{
    [self.bottomLine removeFromSuperview];
}

@end
