//
//  AppDelegate.m
//  consult
//
//  Created by Yuhui Zhang on 8/11/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAppDelegate.h"
#import "LEMainViewController.h"
#import "LEConstants.h"
#import "AFNetworkReachabilityManager.h"
#import "LESplashViewController.h"
#import "LELoginViewController.h"
#import "VideoCallViewController.h"
#import "LEAccountService.h"
#import "LEConfigurationLoader.h"
#import "IncomingCallViewController.h"
#import <Quickblox/QBApplication.h>
#import <Quickblox/QBSettings.h>
#import <QuickbloxWebRTC/QBRTCConfig.h>
#import <QuickbloxWebRTC/QBRTCClient.h>
#import <QuickbloxWebRTC/QBRTCICEServer.h>

const CGFloat kQBRingThickness = 1.f;
const NSTimeInterval kQBAnswerTimeInterval = 60.f;
const NSTimeInterval kQBRTCDisconnectTimeInterval = 30.f;
const NSTimeInterval kQBDialingTimeInterval = 5.f;


@interface LEAppDelegate () <UINavigationControllerDelegate>

@end

@implementation LEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [self.window makeKeyAndVisible] ;
    
    // QB Settings
    LEConfigurationLoader* configuration = [[LEConfigurationLoader alloc] init];
    [QBSettings setApplicationID:[configuration intForKey:kLEConfigurationApplicationId]];
    [QBSettings setAuthKey:[configuration stringForKey:kLEConfigurationAuthKey]];
    [QBSettings setAuthSecret:[configuration stringForKey:kLEConfigurationAuthSecret]];
    [QBSettings setAccountKey:[configuration stringForKey:kLEConfigurationAccountKey]];
    [QBSettings setLogLevel:QBLogLevelDebug];
    [QBSettings setAutoReconnectEnabled:YES];
    [QBRTCClient initializeRTC];
    
    //LESplashViewController* splashViewController = [[LESplashViewController alloc] initWithNibName:nil bundle:nil];
    //[self.navigationController pushViewController:splashViewController animated:NO];
    
    /*LEAccountService* accountService = [LEAccountService sharedService];
    if (accountService.account) {
        LEMainViewController* mainViewController = [[LEMainViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:mainViewController animated:NO];
    } else {
        LELoginViewController* loginViewController = [[LELoginViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:loginViewController animated:NO];
    }*/
    
    LELoginViewController* loginViewController = [[LELoginViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:NO];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //Services
//    if ([LEAccountService sharedService].account) {
//        [[LECourseService sharedService] persistent];
//    }
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification postNotificationName:kLENotificationApplicationWillResignActive object:nil userInfo:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification postNotificationName:kLENotificationApplicationDidBecomeActive object:nil userInfo:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //Services
    //[[LECourseService sharedService] stopAllDownloads];
    //[[LECourseService sharedService] persistent];
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    NSArray *viewControllers = [navigationController viewControllers];
    UIViewController* rootViewController = [viewControllers objectAtIndex:0];
    if ([rootViewController isKindOfClass:[LESplashViewController class]] && [viewControllers count] > 1){
        if ([rootViewController respondsToSelector:@selector(removeFromParentViewController)]){
            [rootViewController removeFromParentViewController];
        }else{
            NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
            [viewControllers removeObjectAtIndex:0];
            self.navigationController.viewControllers = viewControllers;
        }
    }
    
    if ([viewController isKindOfClass:[VideoCallViewController class]] && [viewControllers count] > 1){
        UIViewController* incommingCallViewControler = [viewControllers objectAtIndex:[viewControllers count] - 2];
        if ([incommingCallViewControler isKindOfClass:[IncomingCallViewController class]]) {
            if ([incommingCallViewControler respondsToSelector:@selector(removeFromParentViewController)]){
                [incommingCallViewControler removeFromParentViewController];
            }else{
                NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
                [viewControllers removeObjectAtIndex:[viewControllers count] - 2];
                self.navigationController.viewControllers = viewControllers;
            }
        }
    }
}

@end
