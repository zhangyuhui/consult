//
//  LEDefines.h
//  consult
//
//  Created by Yuhui Zhang on 8/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromARGB(argbValue) [UIColor \
colorWithRed:((float)((argbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((argbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(argbValue & 0xFF))/255.0 \
alpha:((float)(argbValue & 0xFF000000))/255.0]

#define ScreenHeight            [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth             [[UIScreen mainScreen] bounds].size.width
#define ScreenStateBarHeight    ScreenHeight > 480 ? 20 : 0
#define ScreenContentHeight     (ScreenHeight - ScreenStateBarHeight)
#define ScreenContentWidth      ScreenWidth

