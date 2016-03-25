//
//  THClassNameListTool.h
//  TH-2.0
//
//  Created by Taro on 16/3/2.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDatabase.h>

@interface THClassNameListTool : NSObject
//@property (nonatomic , strong) FMDatabase * db;
+ (NSArray *)getDataFromDatabase;
@end
