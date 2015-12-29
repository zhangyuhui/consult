//
//  LEAppointment.h
//  consult
//
//  Created by Yuhui Zhang on 12/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <Quickblox/QBUUser.h>

@interface LEAppointment : JSONModel

@property (strong, nonatomic) NSString* identity;
@property (assign, nonatomic) int userId;
@property (assign, nonatomic) int inviteeUserId;
@property (assign, nonatomic) float pay;
@property (assign, nonatomic) int status;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSDate* timeStart;
@property (strong, nonatomic) NSDate* timeEnd;
@property (strong, nonatomic) NSDate<Optional>* createdAt;
@property (strong, nonatomic) NSDate<Optional>* updatedAt;
@property (strong, nonatomic) QBUUser<Optional>* inviteeUser;
@end
