//
//  LEAccountService.m
//  consult
//
//  Created by Yuhui Zhang on 12/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAccountService.h"
#import "LEConstants.h"
#import <Quickblox/QBRequest+QBAuth.h>
#import <Quickblox/QBResponse.h>
#import <Quickblox/QBUUser.h>
#import <Quickblox/QBError.h>

@interface LEAccountService ()
- (void)handleLoginFailure:(NSString*)error failure:(void (^)(LEAccountService *service, NSString* error)) failure;
- (void)handleLoginSuccess:(LEAccount*)account success:(void (^)(LEAccountService *service, LEAccount* account))success;
@end

@implementation LEAccountService

+ (instancetype)sharedService {
    static LEAccountService *sharedService = nil;
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

- (void)loginUser:(NSString*)userName
         password:(NSString*)password
          success:(void (^)(LEAccountService *service, LEAccount* account))success
          failure:(void (^)(LEAccountService *service, NSString* error))failure {
    
    [QBRequest logInWithUserLogin:userName password:password successBlock:^(QBResponse * response, QBUUser * user) {
        LEAccount* account = [[LEAccount alloc] init];
        account.user = user;
        account.user.password = password;
        account.userId = (int)user.ID;
        account.userName = user.login;
        account.password = password;
        [self handleLoginSuccess:account success:success];
    } errorBlock:^(QBResponse * response) {
        [self handleLoginFailure:[response.error description] failure:failure];
    }];
}

- (void)logout {
    [super logout];
    self.account = nil;
}

- (void)handleLoginFailure:(NSString*)error failure:(void (^)(LEAccountService *service, NSString* error)) failure {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kLENetworkConnectionUserId];
    [userDefaults removeObjectForKey:kLENetworkConnectionUserName];
    [userDefaults removeObjectForKey:kLENetworkConnectionUserPassword];
    self.account = nil;
    failure(self, error);
}

- (void)handleLoginSuccess:(LEAccount*)account success:(void (^)(LEAccountService *service, LEAccount* account))success {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInt:account.userId] forKey:kLENetworkConnectionUserId];
    [userDefaults setObject:account.userName forKey:kLENetworkConnectionUserName];
    [userDefaults setObject:account.password forKey:kLENetworkConnectionUserPassword];
    self.account = account;
    
    [self persistent];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLENotificationAccountDidChange object:account];
    
    success(self, account);
}

- (void)persistentAccount {
    if (self.account) {
        NSData* data = [self.account toJSONData];
        [data writeToFile:[self dataPath] atomically:YES];
    } else {
        NSString* path = [self dataPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSError* error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
}

- (void)restoreAccount {
    NSData* data = [[NSFileManager defaultManager] contentsAtPath:[self dataPath]];
    NSError* error = nil;
    self.account = [[LEAccount alloc] initWithData:data error:&error];
}

- (void)persistent {
    [super persistent];
    [self persistentAccount];
}

- (void)restore {
    [super restore];
    [self restoreAccount];
}

@end
