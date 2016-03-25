//
//  HttpTool.m
//  ShoesSeller
//
//  Created by minug on 15/11/16.
//  Copyright © 2015年 minug. All rights reserved.
//

#import "HttpTool.h"

@implementation HttpTool

+(void)getWithURLString:(NSString *)urlString parameters:(NSDictionary *)paremeters success:(void(^)(id  _Nonnull responseObject))success failure:(void(^)(NSError * _Nonnull error))failure{
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@?",urlString];
    
    [str appendString:[self parametersStrWithparameters:paremeters]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str] cachePolicy:0 timeoutInterval:10.0f];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            DLog(@"%@",str);
            failure(connectionError);
            return ;
        }else{
            id obj = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            DLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            success(obj);
        }
    }];
    
    
}

+(void)normalRequestWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(NetWorkSuccessBlock)success failure:(NetWorkFailureBlock)failure{
    if (![urlString hasPrefix:@"http"]) {
        urlString = [NSString stringWithFormat:@"http://%@",urlString];
    }
    [HttpTool postWithURLString:urlString parameters:parameters success:^(id responseObject) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{success(responseObject);}];
    } failure:^(NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            failure(error);
        }];
    }];
}

+(void)postWithURLString:(NSString *)urlString parameters:(NSDictionary *)paremeters success:(void(^)(id  _Nonnull responseObject))success failure:(void(^)( NSError * _Nonnull error))failure{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:0 timeoutInterval:10.0f];
    request.HTTPMethod = @"POST";
    NSMutableString *str = [self parametersStrWithparameters:paremeters];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            failure(connectionError);
            return ;
        }
        DLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
        success(json);
    }];
    
    
}

+(NSMutableString *)parametersStrWithparameters:(NSDictionary *)paremeters{
    NSMutableString *str = [NSMutableString string];
    NSArray *keys = paremeters.allKeys;
    if (keys.count) {
        [str appendFormat:@"%@=%@",keys[0],paremeters[keys[0]]];
        for (int i = 1; i<keys.count; i++) {
            [str appendFormat:@"&%@=%@",keys[i],paremeters[keys[i]]];
        }
    }
    return str;
}

@end
