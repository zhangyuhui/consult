//
//  LEMainViewControllerTableViewCell.h
//  consult
//
//  Created by Yuhui Zhang on 12/28/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEAppointment.h"
#import <Quickblox/QBUUser.h>

@class LEMainViewControllerTableViewCell;

@protocol LEMainViewControllerTableViewCellDelegate <NSObject>
@optional
- (void)mainViewControllerTableViewCell:(LEMainViewControllerTableViewCell*)cellView startVideoCall:(QBUUser*)user;
@end

@interface LEMainViewControllerTableViewCell : UITableViewCell

+ (instancetype)mainViewControllerTableViewCell;

@property (strong, nonatomic) LEAppointment* appointment;

@property (assign, nonatomic) id<LEMainViewControllerTableViewCellDelegate> delegate;

@end
