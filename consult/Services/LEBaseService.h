//
//  LEBaseService.h
//  consult
//
//  Created by Yuhui Zhang on 9/4/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEBaseService : NSObject

- (void)logout;

- (void)persistent;
- (void)restore;
- (void)reset;

- (NSString*)dataPath;
- (NSString*)dataPath:category;

+ (NSString*)rootDataPath;

@end
