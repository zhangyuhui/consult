//
//  LEAppointmentService.m
//  consult
//
//  Created by Yuhui Zhang on 12/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAppointmentService.h"
#import "LEAppointment.h"
#import <Quickblox/QBRequest+QBCustomObjects.h>
#import <Quickblox/QBResponse.h>
#import <Quickblox/QBUUser.h>
#import <Quickblox/QBError.h>


@interface LEAppointmentService ()

- (void)handleGetAppointmentsFailure:(NSString*)error failure:(void (^)(LEAppointmentService *service, NSString* error))failure;
- (void)handleGetAppointmentsSuccess:(NSArray*)appointments success:(void (^)(LEAppointmentService *service, NSArray* appointments))success;

@end

@implementation LEAppointmentService

+ (instancetype)sharedService {
    static LEAppointmentService *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[super allocWithZone:NULL] init];
        [sharedService restore];
    });
    return sharedService;
}

+ (instancetype)allocWithZone:(NSZone *)zone{
    NSString *reason = [NSString stringWithFormat:@"Attempt to allocate a second instance of the singleton %@", [self class]];
    NSException *exception = [NSException exceptionWithName:@"Multiple singletons" reason:reason userInfo:nil];
    [exception raise];
    return nil;
}

- (void)getAppointments:(void (^)(LEAppointmentService *service, NSArray* appointments))success
                failure:(void (^)(LEAppointmentService *service, NSString* error))failure {
    
    [QBRequest objectsWithClassName:@"Appointment" successBlock:^(QBResponse * response, NSArray * objects) {
        NSDictionary* responseData = (NSDictionary*)response.data;
        NSArray* responseItems = [responseData objectForKey:@"items"];
        NSMutableArray* appointments = [NSMutableArray arrayWithCapacity:[responseItems count]];
        [responseItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            NSError* error = nil;
            LEAppointment* appointment = [[LEAppointment alloc] initWithDictionary:obj error:&error];
            if (!error) {
                [appointments addObject:appointment];
            }
        }];
        self.appointments = appointments;
        [self handleGetAppointmentsSuccess:appointments success:success];
    } errorBlock:^(QBResponse * response) {
        [self handleGetAppointmentsFailure:[response.error description] failure:failure];
    }];
}

- (void)handleGetAppointmentsFailure:(NSString*)error failure:(void (^)(LEAppointmentService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleGetAppointmentsSuccess:(NSArray*)appointments success:(void (^)(LEAppointmentService *service, NSArray* appointments))success {
    success(self, appointments);
}

@end
