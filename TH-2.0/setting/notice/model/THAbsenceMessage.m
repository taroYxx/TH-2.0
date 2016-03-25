//
//  THAbsenceMessage.m
//  
//
//  Created by Taro on 16/3/13.
//
//

#import "THAbsenceMessage.h"

@implementation THAbsenceMessage
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.messageId = dic[@"messageId"];
        self.absence_students = dic[@"absence_students"];
        self.time = dic[@"time"];
    }
    return self;
}
+ (instancetype)absenceMessageWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}

@end
