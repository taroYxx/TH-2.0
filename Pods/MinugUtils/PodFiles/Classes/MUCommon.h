//
//  MUCommon.h
//  MinugUtils
//
//  Created by minug on 15/11/22.
//
//

#ifndef MUCommon_h
#define MUCommon_h

#import <Masonry/Masonry.h>

#define APP_DELEGATE            ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define App_Frame_Width         ([[UIScreen mainScreen] applicationFrame].size.width)
#define App_Frame_Height        ([[UIScreen mainScreen] applicationFrame].size.height) //不包括状态栏
#define App_Status_Height       ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define App_TabBar_Height       40
#define App_UINavigationBar_Height44 44

#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...)
#endif

#define navigationBarHeight (self.navigationController.navigationBar.frame.size.height+20)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define screenwidth [UIScreen mainScreen].bounds.size.width
#define screenheight [UIScreen mainScreen].bounds.size.height

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define CurrentDeviceVersion ([[UIDevice currentDevice] model])
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define IS_IPHONE_4S ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )960 ) < DBL_EPSILON )
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define scaleFactor (App_Frame_Width/320)

#define deviceScale (([[UIScreen mainScreen] applicationFrame].size.height)<=667.0?1.0:1.5)
#define XColor(r,g,b ,a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(a/1.0)]
#define WEAKSELF     __weak __typeof(self) weakSelf = self;

typedef void (^NetWorkSuccessBlock)(id responseObject) ;
typedef void (^NetWorkFailureBlock)( NSError *  error) ;

#endif /* MUCommon_h */
