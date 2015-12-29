//
//  Settings.h
//  sample-videochat-webrtc
//
//  Created by Andrey Ivanov on 25.06.15.
//  Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <QuickbloxWebRTC/QBRTCVideoFormat.h>
#import <QuickbloxWebRTC/QBRTCMediaStreamConfiguration.h>
#import <QuickbloxWebRTC/QBRTCRemoteVideoView.h>

@interface Settings : NSObject

@property (strong, nonatomic) QBRTCVideoFormat *videoFormat;

@property (strong, nonatomic) QBRTCMediaStreamConfiguration *mediaConfiguration;

@property (assign, nonatomic) QBRendererType remoteVideoViewRendererType;

@property (assign, nonatomic) AVCaptureDevicePosition preferredCameraPostion;

@property (strong, nonatomic) NSArray *stunServers;

+ (instancetype)instance;

- (void)saveToDisk;

@end
