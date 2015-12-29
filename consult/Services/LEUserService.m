//
//  LEUserService.m
//  consult
//
//  Created by Yuhui Zhang on 12/28/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEUserService.h"
#import "LEConstants.h"
#import <Quickblox/QBRequest+QBUsers.h>
#import <Quickblox/QBResponse.h>
#import <Quickblox/QBGeneralResponsePage.h>
#import <Quickblox/QBUUser.h>
#import <Quickblox/QBError.h>

@interface LEUserService ()
- (void)handleGetUsersFailure:(NSString*)error failure:(void (^)(LEUserService *service, NSString* error)) failure;
- (void)handleGetUsersSuccess:(NSArray*)users success:(void (^)(LEUserService *service, NSArray* users))success;
@end

@implementation LEUserService

+ (instancetype)sharedService {
    static LEUserService *sharedService = nil;
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

- (void)getUsers:(NSArray*)userIds
         success:(void (^)(LEUserService *service, NSArray* users))success
         failure:(void (^)(LEUserService *service, NSString* error))failure {
    
    QBGeneralResponsePage* responsePage = [QBGeneralResponsePage responsePageWithCurrentPage:0 perPage:1000];
    
    [QBRequest usersWithIDs:userIds page:responsePage successBlock:^(QBResponse * _Nonnull response, QBGeneralResponsePage * page, NSArray<QBUUser *> * users) {
        [self handleGetUsersSuccess:users success:success];
    } errorBlock:^(QBResponse * response) {
        [self handleGetUsersFailure:[response.error description] failure:failure];
    }];
}

- (void)handleGetUsersFailure:(NSString*)error failure:(void (^)(LEUserService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleGetUsersSuccess:(NSArray*)users success:(void (^)(LEUserService *service, NSArray* users))success {
    success(self, users);
}


@end
