//
//  THTabBarViewController.m
//  TH-2.0
//
//  Created by Taro on 16/1/13.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THTabBarViewController.h"
#import "THMainViewController.h"
#import "THSettingTableViewController.h"
#import "THStatisticsViewController.h"

@interface THTabBarViewController ()

@end

@implementation THTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    THMainViewController *main = [[THMainViewController alloc] init];
    [self addchildVc:main title:@"课堂点名" image:@"class" selectedImage:@"class_select" badgeValue:nil];
    THStatisticsViewController *statistics = [[THStatisticsViewController alloc] init];
    [self addchildVc:statistics title:@"统计成绩" image:@"statistics" selectedImage:@"statistics_select" badgeValue:nil];
   
    
    THSettingTableViewController *setting = [[THSettingTableViewController alloc] init];
    [self addchildVc:setting title:@"个人设置" image:@"setting" selectedImage:@"setting_select" badgeValue:nil];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"辅导员"] || [[NSUserDefaults standardUserDefaults] valueForKey:@"教务处"] ) {
        [self GetMessage:^(NSArray *array) {
            setting.noticeData = array;
            if (array.count != 0) {
                setting.tabBarItem.badgeValue  = [NSString stringWithFormat:@"%ld",array.count];
            }
            
        }];
    }
    
   
}

- (void)addchildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectImage badgeValue:(NSString *)badgeValue{
    if (!selectImage) {
        selectImage = image;
    }
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.badgeValue = badgeValue;
    //使用原图，不渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:YColor(209, 84, 87, 1)} forState:UIControlStateSelected];
    //    [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:childVc]];
    //    self.navigationController.navigationBar.barTintColor = XColor(64, 185, 216, 1);
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YColor(209, 84, 87, 1),NSForegroundColorAttributeName,nil]];
    [nav.navigationBar setTintColor:YColor(209, 84, 87, 1)];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//    backItem.title = @"返回";
//    nav.navigationItem.backBarButtonItem = backItem;
    [self addChildViewController:nav];
}

- (void)GetMessage:(void(^)( NSArray *array))success{
    NSString *url = [NSString stringWithFormat:@"%@/%@/messages/",host,version];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *result = responseObject[@"absence_messages"];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(result);
            }
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
    }];
    
}



@end
