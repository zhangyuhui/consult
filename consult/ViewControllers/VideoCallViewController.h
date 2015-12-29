//
//  VideoCallViewController.h
//  consult
//
//  Created by Yuhui Zhang on 12/28/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseViewController.h"
#import <QuickbloxWebRTC/QBRTCSession.h>

@interface VideoCallViewController : LEBaseViewController
-(instancetype)initWithSesstionsAndOpponentUsers:(QBRTCSession*)session opponentUsers:(NSArray*)opponentUsers;
@end
