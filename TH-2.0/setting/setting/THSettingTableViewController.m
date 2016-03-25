//
//  THSettingTableViewController.m
//  Teacher-Help
//
//  Created by Taro on 15/11/20.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import "THSettingTableViewController.h"
#import "THSettingItem.h"
#import "THSettingGroup.h"
#import "THSetNoticeViewController.h"
#import "THSetStaticViewController.h"
#import "THSetSubAccountViewController.h"
#import "THLoginViewController.h"
#import "THFDYViewController.h"



@interface THSettingTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) NSMutableArray * groups;

@end

@implementation THSettingTableViewController


- (NSMutableArray *)groups{
    if (!_groups) {
        _groups = [NSMutableArray array];
        
    }
    return _groups;
}

- (instancetype)init{
    return [self initWithStyle:UITableViewStyleGrouped];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self setGroup1];
    [self setGroup2];
    [self setgroup3];
    
 
    
    
    UIBarButtonItem *logoff = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleDone target:self action:@selector(logOff)];
    logoff.tintColor = YColor(208, 85, 90, 1);
    self.navigationItem.rightBarButtonItem = logoff;

}


- (void)logOff{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    THLoginViewController *login = [[THLoginViewController alloc] init];
    window.rootViewController = login;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"teacherNo"];
    
}

- (void)setGroup1{
    THSettingGroup *group = [[THSettingGroup alloc] init];
    group.headerTitle = @"个人设置";
    self.name = [[NSUserDefaults standardUserDefaults] valueForKey:@"name"];
    self.teacherNO = [[NSUserDefaults standardUserDefaults] valueForKey:@"teacherNo"];
    THSettingItem *item = [THSettingItem itemWithTitle:[NSString stringWithFormat:@"%@    %@",self.name,self.teacherNO]];
    item.iconImage = [UIImage imageNamed:@"acount"];
    group.items = @[item];
    [self.groups addObject:group];
}

- (void)setGroup2{
    THSettingGroup *group = [[THSettingGroup alloc] init];
    group.headerTitle = @"功能设置";
    THSettingItem *item = [THSettingItem itemWithTitle:@"消息通知"];
    THSettingItem *item1 = [THSettingItem itemWithTitle:@"开通子账号"];
    THSettingItem *item2 = [THSettingItem itemWithTitle:@"设置统计百分比"];
    THSettingItem *item3 = [THSettingItem itemWithTitle:@"辅导员选项"];
//    item.nextController = [[THSetNoticeViewController alloc] init];
    THSetNoticeViewController *notice = [[THSetNoticeViewController alloc] init];
    item.nextController = notice;
//    notice.noticeData = self.noticeData;
    item1.nextController = [[THSetSubAccountViewController alloc] init];
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor redColor];
    label.frame = CGRectMake(screenW-60, 11, 20, 20);
    [label.layer setCornerRadius:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.masksToBounds = YES;
    label.text = [NSString stringWithFormat:@"%ld",self.noticeData.count];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextColor:[UIColor whiteColor]];
    if (self.noticeData.count != 0) {
        item.label = label;
    }
    
//    [cell addSubview:label];
    THSetStaticViewController *statice = [[THSetStaticViewController alloc] init];
    statice.classlist = self.classlist;
    item2.nextController = statice;
    item.iconImage = [UIImage imageNamed:@"msg"];
    item1.iconImage = [UIImage imageNamed:@"assistant"];
    item2.iconImage = [UIImage imageNamed:@"per"];
    
    // 辅导员图标没设置
    item3.iconImage = [UIImage imageNamed:@"eye"];
    
    THFDYViewController *fdy = [[THFDYViewController alloc] init];
    item3.nextController = fdy;
    
    group.items = @[item,item1,item2,item3];
    [self.groups addObject:group];
    
   
}



- (void)setgroup3{
    THSettingGroup *group = [[THSettingGroup alloc] init];
    group.headerTitle = @"支持";
    THSettingItem *item = [THSettingItem itemWithTitle:@"评分"];
    THSettingItem *item1 = [THSettingItem itemWithTitle:@"关于"];
    item.iconImage = [UIImage imageNamed:@"mark"];
    item1.iconImage = [UIImage imageNamed:@"about"];
    group.items = @[
                    item,
                    ];
    [self.groups addObject:group];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    THSettingGroup *group = self.groups[section];
    return group.items.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    THSettingGroup *group =self.groups[indexPath.section];
    THSettingItem *item = group.items[indexPath.row];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        [cell addSubview:item.label];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = item.title;
    cell.imageView.image = item.iconImage;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    THSettingGroup *group = self.groups[indexPath.section];
    THSettingItem *item = group.items[indexPath.row];

    if(item.nextController){
        [self.navigationController pushViewController:item.nextController animated:YES];
        item.label.hidden = YES;
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    [self.navigationController.navigationBar setTintColor:YColor(209, 84, 87, 1)];
    self.navigationItem.backBarButtonItem = backItem;
    
    if (indexPath.row == 0 && indexPath.section == 2) {
        
        NSString *appid = @"1068467929";
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", appid];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        //1068467929
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    THSettingGroup *group = self.groups[section];
    return group.headerTitle;
}




@end
