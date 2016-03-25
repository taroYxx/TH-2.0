//
//  THSetSubAccountViewController.m
//  Teacher-Help
//
//  Created by Taro on 15/11/20.
//  Copyright © 2015年 Taro. All rights reserved.
//

#import "THSetSubAccountViewController.h"
#import <AFNetworking/AFNetworking.h>



@interface THSetSubAccountViewController ()
@property (nonatomic , weak) UITextField * username;
@property (nonatomic , weak) UITextField * password;
@property (nonatomic , weak) UITextField * pwd;
@property (nonatomic , weak) UITextField * remarks;
@property (nonatomic , weak) UIButton * btn;

@end

@implementation THSetSubAccountViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addview];

}

- (void)addview{
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenW, 44)];
    titleView.text = @"开通子账号";
    titleView.backgroundColor = YColor(228, 228, 228, 1);
    titleView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleView];
    
    UITextField *username = [[UITextField alloc] initWithFrame:CGRectMake(5, 60+80, screenW-10, 40)];
    self.username = username;
    UITextField *password = [[UITextField alloc] initWithFrame:CGRectMake(5, 60+74*2, screenW-10, 40)];
    self.password = password;
    UITextField *pwd = [[UITextField alloc] initWithFrame:CGRectMake(5, 60+74*3, screenW-10, 40)];
    self.pwd = pwd;
    UITextField *remarks = [[UITextField alloc] initWithFrame:CGRectMake(5, 60+74*4, screenW-10, 40)];
    self.remarks = remarks;
    self.password.secureTextEntry = YES;
    self.pwd.secureTextEntry = YES;
    [username setBorderStyle:UITextBorderStyleRoundedRect];
    [password setBorderStyle:UITextBorderStyleRoundedRect];
    [pwd setBorderStyle:UITextBorderStyleRoundedRect];
    [remarks setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:username];
    [self.view addSubview:password];
    [self.view addSubview:pwd];
    [self.view addSubview:remarks];
    NSArray *labletitle = @[@"用户名：",@"密码:",@"确认密码:",@"备注"];
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13, 60+44+i*70, screenW, 40)];
        label.text = labletitle[i];
        [self.view addSubview:label];
//        UITextField *textfied = [[UITextField alloc] initWithFrame:CGRectMake(5, 64+88+88*i, screenW-10, 44)];
//        textfied.tag = i;
//        [textfied setBorderStyle:UITextBorderStyleRoundedRect];
//        textfied.backgroundColor = XColor(228, 228, 228, 1);
//        [self.view addSubview:textfied];
        
    }
    
    
    

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 64+44*7+30, screenW-20, 44)];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.backgroundColor = YColor(208, 86, 90, 1);
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    _btn = btn;

}






- (void)submit{
    if ([self.password.text isEqualToString:self.pwd.text]) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@/%@/add_assistant/",host,version];
        NSDictionary *dict = @{
                               @"username" : self.username.text,
                               @"password" : self.password.text,
                               @"remarks" : self.remarks.text
                               };
        
       [manager POST:url parameters:dict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
           THLog(@"%@statue",responseObject);
           NSNumber *statue = responseObject[@"status"];
           if (statue.intValue == 1) {
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交成功！" preferredStyle:UIAlertControllerStyleAlert];
               UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   [self.navigationController popToRootViewControllerAnimated:YES];
               }];
               [alert addAction:confirm];
               [self presentViewController:alert animated:YES completion:nil]; 
           }

       } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
           THLog(@"%@",error);
           UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"系统信息" message:@"网络连接有问题" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
           [alertView show];

       }];
      
    }else{
        
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"系统信息" message:@"前后密码不一致" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        
    }
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
