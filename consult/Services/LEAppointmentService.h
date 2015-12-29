//
//  LEAppointmentService.h
//  consult
//
//  Created by Yuhui Zhang on 12/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseService.h"

@interface LEAppointmentService : LEBaseService

+ (instancetype)sharedService;

@property (strong, nonatomic) NSArray* appointments;

- (void)getAppointments:(void (^)(LEAppointmentService *service, NSArray* appointments))success
                failure:(void (^)(LEAppointmentService *service, NSString* error))failure;

@end
