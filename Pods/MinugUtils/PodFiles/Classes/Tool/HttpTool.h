//
//  HttpTool.h
//  ShoesSeller
//
//  Created by minug on 15/11/16.
//  Copyright © 2015年 minug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUCommon.h"


@interface HttpTool : NSObject

+(void)getWithURLString:(NSString *)urlString parameters:(NSDictionary *)paremeters success:(NetWorkSuccessBlock)success failure:(NetWorkFailureBlock)failure;

+(void)postWithURLString:(NSString *)urlString parameters:(NSDictionary *)paremeters success:(NetWorkSuccessBlock)success failure:(NetWorkFailureBlock)failure;

+(void)normalRequestWithURLString:(NSString*)urlString parameters:(NSDictionary *)parameters success:(NetWorkSuccessBlock)success failure:(NetWorkFailureBlock)failure;

@end
