//
//  LEAccountService.h
//  consult
//
//  Created by Yuhui Zhang on 12/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseService.h"
#import "LEAccount.h"

@interface LEAccountService : LEBaseService

+ (instancetype)sharedService;

@property (strong, nonatomic) LEAccount* account;

- (void)loginUser:(NSString*)userName
         password:(NSString*)password
          success:(void (^)(LEAccountService *service, LEAccount* account))success
          failure:(void (^)(LEAccountService *service, NSString* error))failure;

@end
