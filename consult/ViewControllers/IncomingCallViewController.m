//
//  IncomingCallViewController.m
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 16.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

#import "IncomingCallViewController.h"

#import <QuickbloxWebRTC/QBRTCClientDelegate.h>
#import <QuickbloxWebRTC/QBRTCClient.h>
#import <QuickbloxWebRTC/QBRTCConfig.h>
#import <QuickbloxWebRTC/QBRTCSoundRouter.h>
#import <Quickblox/QBUUser.h>

#import "ChatManager.h"
#import "CornerView.h"
#import "QBButton.h"
#import "QMSoundManager.h"
#import "QBToolBar.h"
#import "QBButtonsFactory.h"
#import "LEAccountService.h"

@interface IncomingCallViewController () <QBRTCClientDelegate>

@property (weak, nonatomic) IBOutlet UITextView *callInfoTextView;
@property (weak, nonatomic) IBOutlet QBToolBar *toolbar;

@property (weak, nonatomic) NSTimer *dialignTimer;
@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) QBRTCSession *session;

@end

@implementation IncomingCallViewController

- (instancetype)initWithSessionAndUsers:(QBRTCSession*)session users:(NSArray*)users {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.session = session;
        self.users = users;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [QMSoundManager playRingtoneSound];
    
    [QBRTCClient.instance addDelegate:self];
    [self confiugreGUI];
    
    self.dialignTimer =
    [NSTimer scheduledTimerWithTimeInterval:[QBRTCConfig dialingTimeInterval]
                                     target:self
                                   selector:@selector(dialing:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)dialing:(NSTimer *)timer {
    [QMSoundManager playRingtoneSound];
}

- (void)dealloc {
    [QBRTCClient.instance addDelegate:self];
}

#pragma mark - Update GUI
- (void)confiugreGUI {
    [self defaultToolbarConfiguration];
    [self updateCallInfo];
}

- (void)defaultToolbarConfiguration {
    self.toolbar.backgroundColor = [UIColor clearColor];
    [self.toolbar addButton:[QBButtonsFactory circleDecline] action: ^(UIButton *sender) {
        [self cleanUp];
        [self.delegate incomingCallViewController:self didRejectSession:self.session];
    }];
    [self.toolbar addButton:[QBButtonsFactory answer] action: ^(UIButton *sender) {
        [self cleanUp];
        [self.delegate incomingCallViewController:self didAcceptSession:self.session];
    }];
    [self.toolbar updateItems];
}


- (void)updateCallInfo {
    NSMutableArray *info = [NSMutableArray array];
    for (QBUUser *user in self.users ) {
        if ([LEAccountService sharedService].account.user.ID != user.ID) {
            [info addObject:[NSString stringWithFormat:@"%@(%@)", user.fullName, @(user.ID)]];
        }
    }
    self.callInfoTextView.text = [info componentsJoinedByString:@", "];
    self.callInfoTextView.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:19];
    self.callInfoTextView.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Actions

- (void)cleanUp {
    [self.dialignTimer invalidate];
    self.dialignTimer = nil;
    [QBRTCClient.instance removeDelegate:self];
	[QBRTCSoundRouter.instance deinitialize];
    [[QMSoundManager instance] stopAllSounds];
}

- (void)sessionDidClose:(QBRTCSession *)session {
      [self cleanUp];
}

@end
