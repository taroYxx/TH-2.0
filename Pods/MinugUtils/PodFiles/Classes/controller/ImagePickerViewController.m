//
//  ImagePickerViewController.m
//  ShoesSeller
//
//  Created by minug on 15/11/21.
//  Copyright © 2015年 minug. All rights reserved.
//

#import "ImagePickerViewController.h"

@interface ImagePickerViewController ()<UIImagePickerControllerDelegate ,UINavigationControllerDelegate , UIActionSheetDelegate>

@end

@implementation ImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.delegate = self;
    self.allowsEditing = YES;
}

+(NSString *)imagePickerNotification{
    return @"imagePickerNotification";
}

-(void)actionSheetShowInView:(UIView *)view{
    UIActionSheet *sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [sheet showInView:view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 判断是否支持相机
    switch (buttonIndex) {
        case 0://相机
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1://相册
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        case 2:
            return;
            
    }
    
    [self showWithSourceType:sourceType];
    
}


-(void)showWithSourceType:(NSUInteger)sourceType{
    self.sourceType = sourceType;
    
    UIViewController *controller ;
    
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *window;
    for (UIWindow *_window in windows) {
        if (_window.windowLevel == UIWindowLevelNormal) {
            window = _window;
            break;
        }
    }
    
    controller = window.rootViewController;
    while (controller.presentedViewController) {
        if ([controller class] == [UIAlertController class]) {
            break;
        }
        controller = controller.presentedViewController;
    }
    [controller presentViewController:self animated:YES
                           completion:nil];
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[ImagePickerViewController imagePickerNotification] object:nil userInfo:info];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
