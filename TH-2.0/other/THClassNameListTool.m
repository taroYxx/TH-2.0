//
//  THClassNameListTool.m
//  TH-2.0
//
//  Created by Taro on 16/3/2.
//  Copyright © 2016年 Taro. All rights reserved.
//

#import "THClassNameListTool.h"
#import "THClass.h"

@implementation THClassNameListTool
static FMDatabase *_db;

+ (void)initialize
{
    // 1.打开数据库
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"student.sqlite"];
    _db = [[FMDatabase alloc] initWithPath:path];
    [_db open];

}

//+ (void)addShop:(HMShop *)shop
//{
//    [_db executeUpdateWithFormat:@"INSERT INTO t_shop(name, price) VALUES (%@, %f);", shop.name, shop.price];
//}
//
//+ (NSArray *)shops
//{// 得到结果集
//    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_shop;"];
//    
//    // 不断往下取数据
//    NSMutableArray *shops = [NSMutableArray array];
//    while (set.next) {
//        // 获得当前所指向的数据
//        HMShop *shop = [[HMShop alloc] init];
//        shop.name = [set stringForColumn:@"name"];
//        shop.price = [set doubleForColumn:@"price"];
//        [shops addObject:shop];
//    }
//    return shops;
//}



+ (NSArray *)getDataFromDatabase{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM allclass ;"];
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        NSDictionary *dict = @{@"courseName": [set stringForColumn:@"coursename"],
                               @"courseNo": [set stringForColumn:@"courseno"],
                               @"courseId": [set stringForColumn:@"courseid"],
                               @"venue": [set stringForColumn:@"venue"],
                               @"lessonPeriod": [set stringForColumn:@"lessonperiod"]
                               };
        THClass *allclass = [THClass classWithDic:dict];
        [array addObject:allclass];
    }
    return array;
  
}

@end
