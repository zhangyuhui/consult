//
//  LEAppointment.m
//  consult
//
//  Created by Yuhui Zhang on 12/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAppointment.h"

#define APIDateFormat @"yyyy-MM-dd HH:mm"

@implementation JSONValueTransformer (CustomTransformer)

- (NSDate *)NSDateFromNSString:(NSString*)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:APIDateFormat];
    return [formatter dateFromString:string];
}

- (NSString *)JSONObjectFromNSDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:APIDateFormat];
    return [formatter stringFromDate:date];
}

@end

@implementation LEAppointment

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"_id": @"identity",
                                                       @"user_id": @"userId",
                                                       @"invitee_user_id": @"inviteeUserId",
                                                       @"full_name": @"userDisplayName",
                                                       @"website": @"webSite",
                                                       @"created_at": @"createdAt",
                                                       @"updated_at": @"updatedAt",
                                                       @"time_end": @"timeEnd",
                                                       @"time_start": @"timeStart"
                                                       }];
}

@end
