//
//  IncomingCallViewController.h
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 16.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

#import "LEBaseViewController.h"
#import <QuickbloxWebRTC/QBRTCSession.h>

@protocol IncomingCallViewControllerDelegate;

@interface IncomingCallViewController : LEBaseViewController
@property (weak, nonatomic) id <IncomingCallViewControllerDelegate> delegate;
-(instancetype)initWithSessionAndUsers:(QBRTCSession*)session users:(NSArray*)users;
@end

@protocol IncomingCallViewControllerDelegate <NSObject>
- (void)incomingCallViewController:(IncomingCallViewController *)vc didAcceptSession:(QBRTCSession *)session;
- (void)incomingCallViewController:(IncomingCallViewController *)vc didRejectSession:(QBRTCSession *)session;
@end
