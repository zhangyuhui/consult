//
//  OpponentCollectionViewCell.h
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 11.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickbloxWebRTC/QBRTCTypes.h>

@class QBRTCVideoTrack;

@interface OpponentCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic)   UIView *videoView;
@property (assign, nonatomic) QBRTCConnectionState connectionState;
@property (assign, nonatomic) BOOL showConnectionState;
@end

