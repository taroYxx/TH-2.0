//
//  THNoticeCellTableViewCell.m
//  TH-2.0
//
//  Created by Taro on 16/3/13.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THNoticeCellTableViewCell.h"

@implementation THNoticeCellTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        UIView *bottomline = [[UIView alloc] init];
//        bottomline.backgroundColor = [UIColor blackColor];
//        [self addSubview:bottomline];
//        [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(@2);
//            make.right.equalTo(@0);
//            make.left.equalTo(@0);
//            make.height.equalTo(@2);
//        }];
        
        UILabel *name = [[UILabel alloc] init];
        UILabel *major = [[UILabel alloc] init];
        UILabel *studentNo = [[UILabel alloc] init];
        UILabel *classNo = [[UILabel alloc] init];
        UILabel *record = [[UILabel alloc] init];
        UILabel *state = [[UILabel alloc] init];
//        name.text = @"jack";
//        major.text = @"专业:通信工程原理";
//        studentNo.text = @"学号:11084229";
//        classNo.text = @"班级:11083612";
//        record.text = @"213147908\n123798123\n123698\n";
//        state.text = @"未处理";
      
        
        
        [state setTextColor:YColor(207, 85, 89, 1)];
        
        [self addSubview:name];
        [self addSubview:major];
        [self addSubview:studentNo];
        [self addSubview:record];
        [self addSubview:classNo];
        [self addSubview:state];
        
        name.frame = CGRectMake(5, 1, screenW/3-15, 100);
        studentNo.frame = CGRectMake(screenW/3-5, 1, screenW/3, 50);
        classNo.frame = CGRectMake(screenW*2/3-5, 1, screenW/3, 50);
        major.frame = CGRectMake(screenW/3-5, 51, screenW/2, 50);
        state.frame = CGRectMake(screenW*5/6-5, 51, screenW/6, 50);
        record.frame = CGRectMake(5, 105, screenW-10, 90);
        
        [self setlabelBorderColor:name];
        [self setlabelBorderColor:studentNo];
        [self setlabelBorderColor:classNo];
        [self setlabelBorderColor:major];
        [self setlabelBorderColor:state];
        [self setlabelBorderColor:record];
        
        record.numberOfLines = 6;
//        NSString *str = @"xxxxxxxx";
//        label.text = str;
//        CGSize size = [self sizeThatFits:CGSizeMake(record.frame.size.height, MAXFLOAT)];
//        CGRect frame = record.frame;
//        frame.size.height = size.height;
//        [record setFrame:frame];;
        
        
        
//        [major mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo
//        }]
        self.name = name;
        self.classNo = classNo;
        self.studentNo = studentNo;
        self.major = major;
        self.record = record;
        self.state = state;
        
    }
    return self;
}

- (void)setlabelBorderColor :(UILabel *)label{
    label.layer.borderColor = [[UIColor blackColor]CGColor];
    label.layer.borderWidth = 0.5f;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
}
- (void)setlableTextname :(NSString *)name studentmajor:(NSString *)studentmajor classNo:(NSString *)classNo studentNo:(NSString *)studentNo record:(NSString *)record{
    
    self.name.text = name;
    self.studentNo.text = [NSString stringWithFormat:@"学号：%@",studentNo];
    self.major.text =  [NSString stringWithFormat:@"专业：%@",studentmajor];
    self.classNo.text= [NSString stringWithFormat:@"班级：%@",studentNo];
    self.record.text = record;
}

- (void)setStateText:(NSString *)string{
    self.state.text = string;
}

@end
