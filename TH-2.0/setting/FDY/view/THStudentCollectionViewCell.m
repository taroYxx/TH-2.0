//
//  THStudentCollectionViewCell.m
//  TH-2.0
//
//  Created by Taro on 16/3/23.
//  Copyright © 2016年 Taro. All rights reserved.
//
#define Cwidth self.frame.size.width
#define Cheight self.frame.size.height
#import "THStudentCollectionViewCell.h"
#import "THRecord.h"



@implementation THStudentCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [YColor(207, 85, 89, 1) CGColor];
        self.layer.borderWidth = 2.0f;
        self.studentName = [[IconText alloc] initWithFrame:CGRectMake(10, 10,(Cwidth-20-10)/2,30)];
        
        self.studentName.imageView.image = [UIImage imageNamed:@"name"];
        [self addSubview:self.studentName];
        
        self.classNo = [[IconText alloc] initWithFrame:CGRectMake(10+(Cwidth-20-10)/2+10, 10, (Cwidth-20-10)/2, 30)];
        self.classNo.imageView.image = [UIImage imageNamed:@"classId"];
        [self addSubview:self.classNo];
        
        self.studentNo = [[IconText alloc] initWithFrame:CGRectMake(10, 45, (Cwidth-20-10)/2, 30)];
        self.studentNo.imageView.image = [UIImage imageNamed:@"studentId"];
        [self addSubview:self.studentNo];
        
        self.major = [[IconText alloc] initWithFrame:CGRectMake(10+(Cwidth-20-10)/2+10, 45, (Cwidth-20-10)/2, 30)];
        self.major.imageView.image = [UIImage imageNamed:@"major"];
        [self addSubview:self.major];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 80, Cwidth-20, Cheight - 80-5)];
        self.tableView.layer.borderWidth = 2;
        self.tableView.layer.borderColor = [YColor(207, 85, 89, 1) CGColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        
        [self addSubview:self.tableView];
        
//        THLog(@"%f,%ff",self.studentName.frame.size.width,self.classNo.frame.size.width);
        
    }
 
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    THLog(@"%ld",self.tableViewData.count);
    return self.tableViewData.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *courseName = [[UILabel alloc] init];
        courseName.font = [UIFont systemFontOfSize:19];
        courseName.frame = CGRectMake(10, 5, screenW-40+5, 30);
        //    courseName.backgroundColor = [UIColor orangeColor];
        
        UILabel *teacherName = [[UILabel alloc] init];
        teacherName.frame = CGRectMake(150, 40, 100, 30);
        self.teacherName = teacherName;
        //    teacherName.backgroundColor = [UIColor orangeColor];
        
        UILabel *courseNo = [[UILabel alloc] init];
        courseNo.frame = CGRectMake(10, 40, 100, 30);
        self.courseNo = courseNo;
        
        UILabel *time = [[UILabel alloc] init];
        time.frame = CGRectMake(150, 75, 100, 20);
        //    time.backgroundColor = [UIColor orangeColor];
        time.adjustsFontSizeToFitWidth = YES;
        self.time = time;
        [cell addSubview:teacherName];
        [cell addSubview:courseName];
        [cell addSubview:time];
//        [cell addSubview:courseNo];
        
    }
    THRecord *recode = self.tableViewData[indexPath.row];
    self.courseName.text = recode.courseName;
    self.teacherName.text = recode.courseTeacher;
//    courseNo.text = recode.courseNo;
    NSRange range = NSMakeRange(0,10);
    self.time.text = [NSString stringWithFormat:@"第%@周   %@",recode.week,[recode.ctime substringWithRange:range]] ;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

@end
