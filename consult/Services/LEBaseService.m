//
//  LEBaseService.m
//  consult
//
//  Created by Yuhui Zhang on 9/4/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseService.h"
#import "NSString+Addition.h"
#import "LEConstants.h"

@implementation LEBaseService

+ (NSString*)rootDataPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    if (userId) {
        NSString * path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[userId stringValue]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSError* error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        }
        return path;
    } else {
        return [paths objectAtIndex:0];
    }
}

- (void)persistent {
}

- (void)restore {
}

- (void)reset {
}

- (void)logout {
    [self persistent];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    if (userId) {
        [userDefaults removeObjectForKey:kLENetworkConnectionUserId];
    }
}

- (NSString*)classPath {
    NSString* className = NSStringFromClass([self class]);
    NSString *prefix = @"LE";
    if ([className hasPrefix:prefix]) {
        className = [className substringFromIndex:[prefix length]];
    }
    return className;
}

- (NSString*)dataPath {
    NSString* className = [self classPath];
    NSString* rootPath = [LEBaseService rootDataPath];
    return [rootPath stringByAppendingPathComponent:[[className dasherize] stringByAppendingString:@"_objects"]];
}

- (NSString*)dataPath:category {
    NSString* className = [self classPath];
    NSString* path = [NSString stringWithFormat:@"_%@_objects", category];
    NSString* rootPath = [LEBaseService rootDataPath];
    return [rootPath stringByAppendingPathComponent:[[className dasherize] stringByAppendingString:path]];
}

@end
