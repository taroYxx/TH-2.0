//
//  THLoginViewController.m
//  TH-2.0
//
//  Created by Taro on 16/2/25.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THLoginViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUD+YXX.h"
#import "THMainViewController.h"
#import "THTabBarViewController.h"
#import <FMDB/FMDatabase.h>
#import "UMessage.h"

@interface THLoginViewController ()<UITextFieldDelegate>
@property (nonatomic , strong) UIImageView * icon;
@property (nonatomic , weak) UITextField *username;
@property (nonatomic , weak) UITextField *password;
@property (nonatomic , weak) UIButton *loginbtn;
@property (nonatomic , weak) UIView *iconbg;
@property (nonatomic , weak) UIView *textbg;
@property (nonatomic , strong) FMDatabase * db;
@property (nonatomic , strong) NSNumber * status;
@property (nonatomic , weak) UILabel * label;
@end

@implementation THLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addIconImage];
    [self addTextField];
    
    
}

- (void)addIconImage{
    UIImage *iconImage = [UIImage imageNamed:@"HDUIcon2-1"];
    UIImageView *icon = [[UIImageView alloc] initWithImage:iconImage];
    [self.view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@50);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    self.icon = icon;
}

- (void)addTextField{
    UITextField *username = [[UITextField alloc] init];
    username.delegate = self;
    username.placeholder = @"学工号";
    username.borderStyle = UITextBorderStyleRoundedRect;
    username.clearButtonMode = UITextFieldViewModeAlways;
    username.returnKeyType = UIReturnKeyNext;
    self.username = username;
    UITextField *password = [[UITextField alloc] init];
    password.placeholder = @"数字杭电密码";
    password.delegate = self;
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.clearButtonMode = UITextFieldViewModeAlways;
    password.secureTextEntry = YES;
    self.password = password;
    [self.view addSubview:self.username];
    [self.view addSubview:password];
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon).with.offset(220);
        make.centerX.equalTo(self.view);
        make.left.equalTo(@20);
        make.height.equalTo(@50);
    }];
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.username).with.offset(60);
        make.centerX.equalTo(self.view);
        make.left.equalTo(@20);
        make.height.equalTo(@50);
    }];
    
    UIButton *loginbtn = [[UIButton alloc] init];
    [loginbtn setTitle:@"登入" forState:UIControlStateNormal];
    [loginbtn.layer setCornerRadius:10.0];
    loginbtn.backgroundColor = YColor(207, 85, 89, 1);
    [loginbtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbtn];
    loginbtn.enabled = NO;
    self.loginbtn = loginbtn;
    [self.view addSubview:self.loginbtn];
    [self.loginbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.password).with.offset(60);
        make.centerX.equalTo(self.view);
        make.left.equalTo(@20);
        make.height.equalTo(@50);
    }];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //    [center addObserver:self selector:@selector(keyboardStartMove:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [center addObserver:self selector:@selector(btnchange) name:UITextFieldTextDidChangeNotification object:self.username];
    [center addObserver:self selector:@selector(btnchange) name:UITextFieldTextDidChangeNotification object:self.password];
    
    
    
}
- (void)login{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [MBProgressHUD showMessage:@"正在登入" toView:self.view];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        
//    });
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSDictionary* bodyParameters = @{
                                     @"username":self.username.text,
                                     @"password":self.password.text,
                                     
                                     };
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/teacher_login/",host,version];
    [manager POST:urlStr parameters:bodyParameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        THLog(@"%@",responseObject);
//        THLog(@"%@",[operation.response allHeaderFields][@"set-Cookie"]);
        NSNumber *status = responseObject[@"status"];
//        NSNumber *status = @3;
       
        
        if (status.intValue == 1) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            THTabBarViewController *tab = [[THTabBarViewController alloc] init];
            THMainViewController *main = [[THMainViewController alloc] init];
            UINavigationController *nav = [tab.viewControllers objectAtIndex:0];
            main = [nav.viewControllers objectAtIndex:0];
            main.cookie = [operation.response allHeaderFields][@"set-Cookie"];
            window.rootViewController = tab;
                        NSString *messtype = [NSString stringWithFormat:@"%@",self.username.text];
                        [UMessage addAlias:messtype type:@"username" response:^(id responseObject, NSError *error) {
                            if(responseObject)
                            {
                                THLog(@"%@",responseObject);
                            }
                            else
                            {
                                THLog(@"%@",error);
                            }
            
                        }];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:responseObject[@"name"] forKey:@"name"];
                [defaults setValue:responseObject[@"teacherNo"] forKey:@"teacherNo"];

#pragma mark -- 改groupname
            if([responseObject valueForKey:@"groupName"]){
            [defaults setValue:responseObject[@"groupName"] forKey:@"groupName"];
            }
        }else if (status.intValue == 3){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            //判断是否是第一次登陆，初始化数据
            if (![[NSUserDefaults standardUserDefaults] valueForKey:@"loginFirst"]) {
                [[NSUserDefaults standardUserDefaults] setValue:@1 forKey:@"loginFirst"];
                [MBProgressHUD showMessage:@"正在初始化数据,请耐心等待" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                    
                    [self login];
                }
                               );
            }else//第一次登陆还未爬成功 提醒再次登陆
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"系统信息" message:@"获取数据失败,请再次重新登入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginFirst"];
                [alertView show];

            }
            
            

            
        }else if (status.intValue == 2){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"系统信息" message:@"密码输入有误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alertView show];
            
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"系统信息" message:@"数字校园账号密码有误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alertView show];
        }
        
//        else{
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"系统信息" message:@"网络连接错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [alertView show];
//        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"系统信息" message:@"网络连接错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    }];

}





- (void)btnchange{
    self.loginbtn.enabled = (self.username.text.length && self.password.text.length);
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getClassTable:(void(^)( NSArray *array))success{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/course_names/",host,version];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *result = responseObject[@"courses"];
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
