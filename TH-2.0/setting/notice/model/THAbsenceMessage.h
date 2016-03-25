//
//  THAbsenceMessage.h
//  
//
//  Created by Taro on 16/3/13.
//
//

#import <Foundation/Foundation.h>

@interface THAbsenceMessage : NSObject


@property (nonatomic , strong) NSNumber * messageId;
@property (nonatomic , strong) NSArray * absence_students;
@property (nonatomic , strong) NSString * time;

+ (instancetype)absenceMessageWithDic:(NSDictionary *)dic;
@end
