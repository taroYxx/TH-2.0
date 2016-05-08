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
@property (nonatomic , weak) UITextField * remarks;
@property (nonatomic , weak) UIButton * btn;
@property (nonatomic , weak) UIButton * deletBtn;

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
    self.username.placeholder = @"请输入6-15位数字或字母";
    UITextField *password = [[UITextField alloc] initWithFrame:CGRectMake(5, 60+74*2, screenW-10, 40)];
    self.password = password;

    UITextField *remarks = [[UITextField alloc] initWithFrame:CGRectMake(5, 60+74*3, screenW-10, 40)];
    self.remarks = remarks;
//    self.password.secureTextEntry = YES;
//    self.pwd.secureTextEntry = YES;
    [username setBorderStyle:UITextBorderStyleRoundedRect];
    [password setBorderStyle:UITextBorderStyleRoundedRect];
    
    [remarks setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:username];
    [self.view addSubview:password];

    [self.view addSubview:remarks];
    NSArray *labletitle = @[@"用户名：",@"密码:",@"备注"];
    for (int i = 0; i < 3; i++) {
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
    
    UIBarButtonItem *deletbtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deletAccount)];
    self.navigationItem.rightBarButtonItem = deletbtn;
    
    
    
    [self getAssistantInfo:^(NSDictionary *dict) {
        self.remarks.text = dict[@"remarks"];
        self.username.text = dict[@"username"];
        self.password.text = dict[@"password"];
    }];
    
}






- (void)submit{
    
    
    
    
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@/%@/add_assistant/",host,version];
        NSString *url1 = [NSString stringWithFormat:@"%@/%@/checkUsername/",host,version];
        NSDictionary *dict = @{
                               @"username" : self.username.text,
                               @"password" : self.password.text,
                               @"remarks" : self.remarks.text
                               };
    
    if (self.username.text.length <= 15 && self.username.text.length >= 6 ) {
        [manager POST:url1 parameters:@{@"username" : self.username.text} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            THLog(@"%@",responseObject);
            NSNumber *status = responseObject[@"status"];
            if (status.integerValue == 1 ) {
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统信息" message:@"用户名已存在！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
                [alert show];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            THLog(@"%@",error);
        }];

    }else if(self.username.text.length < 6){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统信息" message:@"用户名长度不能少于6！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统信息" message:@"用户名长度不能多于15！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
    }
    
    
    
    
    
    }

- (void)getAssistantInfo:(void(^)( NSDictionary *dict))success{
    NSString *url = [NSString stringWithFormat:@"%@/%@/getAssistantInfo/",host,version];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *result = responseObject[@"accounts"];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                success(result);
            }
        }];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        THLog(@"%@",error);
    }];
    
}


- (void)deletAccount{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"系统信息" message:@"确认删除子账号？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *url = [NSString stringWithFormat:@"%@/%@/deleteAssistant/",host,version];
        AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc] init];
        manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manger POST:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            THLog(@"%@",responseObject);
            [self getAssistantInfo:^(NSDictionary *dict) {
                self.remarks.text = dict[@"remarks"];
                self.username.text = dict[@"username"];
                self.password.text = dict[@"password"];
            }];
        
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            THLog(@"%@",error);
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [alert addAction:okAction];
                        
    [self presentViewController:alert animated:YES completion:nil];
   
}

@end
