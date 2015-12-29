//
//  LELoginViewController.m
//  consult
//
//  Created by Yuhui Zhang on 12/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LELoginViewController.h"
#import "LEConstants.h"
#import "LEDefines.h"
#import "LEAccountService.h"
#import "LEMainViewController.h"
#import "NSString+Addition.h"
#import "ChatManager.h"
#import "Settings.h"
#import <QuickbloxWebRTC/QBRTCICEServer.h>
#import <QuickbloxWebRTC/QBRTCConfig.h>

@interface LELoginViewController ()
@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxtField;

-(IBAction)clickSignIn:(id)sender;

@end

@implementation LELoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LEAccountService* accountService = [LEAccountService sharedService];
    if (accountService.account) {
        self.usernameTextField.text = accountService.account.userName;
        self.passwordTxtField.text = accountService.account.password;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)shake:(UIView *)view {
    const int MAX_SHAKES = 6;
    const CGFloat SHAKE_DURATION = 0.08;
    const CGFloat SHAKE_TRANSFORM = 10;
    
    CGFloat direction = 1;
    
    for (int i = 0; i <= MAX_SHAKES; i++) {
        [UIView animateWithDuration:SHAKE_DURATION
                              delay:SHAKE_DURATION * i
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             if (i >= MAX_SHAKES) {
                                 view.transform = CGAffineTransformIdentity;
                             } else {
                                 view.transform = CGAffineTransformMakeTranslation(SHAKE_TRANSFORM * direction, 0);
                             }
                         } completion:nil];
        
        direction *= -1;
    }
}

-(IBAction)clickSignIn:(id)sender {
    [self.signInButton setSelected:NO];
    NSString* username = self.usernameTextField.text;
    NSString* password = self.passwordTxtField.text;
    BOOL isValidate = true;
    
    if ([password isEmptyOrWhitespace]) {
        isValidate = false;
        [self shake:self.passwordTxtField];
        [self.passwordTxtField becomeFirstResponder];
    }
    
    if ([username isEmptyOrWhitespace]) {
        isValidate = false;
        [self shake:self.usernameTextField];
        [self.usernameTextField becomeFirstResponder];
    }
    
    if (isValidate) {
        [self.view endEditing:NO];
        [self showIndicatorView];
        [[LEAccountService sharedService] loginUser:username password:password success:^(LEAccountService *service, LEAccount *account) {
            [[ChatManager instance] logInWithUser:account.user completion:^(BOOL error) {
                [self hideIndicatorView];
                if (!error) {
                    [self applyConfiguration];
                    [self hideIndicatorView];
                    [self gotoNext];
                }
            } disconnectedBlock:^{
                [self hideIndicatorView];
                //[SVProgressHUD showWithStatus:NSLocalizedString(@"Chat disconnected. Attempting to reconnect", nil)];
            } reconnectedBlock:^{
                [self hideIndicatorView];
                //[SVProgressHUD showSuccessWithStatus:@"Chat reconnected"];
            }];
            
        } failure:^(LEAccountService *service, NSString *error) {
            [self hideIndicatorView];
            if (error != nil) {
                [self shake:self.usernameTextField];
                [self shake:self.passwordTxtField];
            }
        }];
    }
}

-(void)gotoNext {
    LEMainViewController* mainViewController = [[LEMainViewController alloc] initWithNibName:nil bundle:nil];
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:mainViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

#pragma UITapGestureRecognizer
- (IBAction)viewTapRecognizer:(UITapGestureRecognizer *)recognizer {
    [self.passwordTxtField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
}

- (void)applyConfiguration {
    
    NSMutableArray *iceServers = [NSMutableArray array];
    
    Settings *settings = Settings.instance;
    for (NSString *url in settings.stunServers) {
        QBRTCICEServer *server = [QBRTCICEServer serverWithURL:url username:@"" password:@""];
        [iceServers addObject:server];
    }
    
    [iceServers addObjectsFromArray:[self quickbloxICE]];
    
    [QBRTCConfig setICEServers:iceServers];
    [QBRTCConfig setMediaStreamConfiguration:settings.mediaConfiguration];
    [QBRTCConfig setStatsReportTimeInterval:1.f];
}

- (NSArray *)quickbloxICE {
    
    NSString *password = @"baccb97ba2d92d71e26eb9886da5f1e0";
    NSString *userName = @"quickblox";
    
    QBRTCICEServer * stunServer = [QBRTCICEServer serverWithURL:@"stun:turn.quickblox.com"
                                                       username:userName
                                                       password:password];
    
    QBRTCICEServer * turnUDPServer = [QBRTCICEServer serverWithURL:@"turn:turn.quickblox.com:3478?transport=udp"
                                                          username:userName
                                                          password:password];
    
    QBRTCICEServer * turnTCPServer = [QBRTCICEServer serverWithURL:@"turn:turn.quickblox.com:3478?transport=tcp"
                                                          username:userName
                                                          password:password];
    
    
    return@[stunServer, turnTCPServer, turnUDPServer];
}

@end
