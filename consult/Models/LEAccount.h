//
//  LEAccount.h
//  consult
//
//  Created by Yuhui Zhang on 12/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <Quickblox/QBUUser.h>

@interface LEAccount : JSONModel

@property (strong, nonatomic) QBUUser<Ignore>* user;

@property (assign, nonatomic) int userId;
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* password;

@end
