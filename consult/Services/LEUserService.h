//
//  LEUserService.h
//  consult
//
//  Created by Yuhui Zhang on 12/28/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseService.h"

@interface LEUserService : LEBaseService

+ (instancetype)sharedService;

- (void)getUsers:(NSArray*)userIds
          success:(void (^)(LEUserService *service, NSArray* users))success
          failure:(void (^)(LEUserService *service, NSString* error))failure;

@end
