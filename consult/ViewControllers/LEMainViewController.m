//
//  LEMainViewController.m
//  consult
//
//  Created by Yuhui Zhang on 8/27/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEMainViewController.h"
#import "LEBaseTableView.h"
#import "LEDefines.h"
#import "LEAppointment.h"
#import "LEAppointmentService.h"
#import "LEUserService.h"
#import "LEMainViewControllerTableViewCell.h"
#import "VideoCallViewController.h"
#import "ChatManager.h"
#import "Settings.h"
#import "LEAccountService.h"
#import "LEUserService.h"
#import "IncomingCallViewController.h"

#import <QuickbloxWebRTC/QBRTCICEServer.h>
#import <QuickbloxWebRTC/QBRTCConfig.h>
#import <QuickbloxWebRTC/QBRTCClientDelegate.h>
#import <QuickbloxWebRTC/QBRTCClient.h>
#import <QuickbloxWebRTC/QBRTCSession.h>


NSString *const kSettingsCallSegueIdentifier = @"SettingsCallSegue";

@interface LEMainViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, LEMainViewControllerTableViewCellDelegate, QBRTCClientDelegate, IncomingCallViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *appointments;
@end

@implementation LEMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.backgroundImage = [UIImage new];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [[LEAppointmentService sharedService] getAppointments:^(LEAppointmentService *service, NSArray *appointments) {
        self.appointments = appointments;
        
        NSMutableArray* userIds = [NSMutableArray array];
        [appointments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            LEAppointment* appointment = obj;
            NSNumber* userId = [NSNumber numberWithInt:appointment.inviteeUserId];
            if (![userIds containsObject:userId]) {
                [userIds addObject:userId];
            }
        }];
        
        [[LEUserService sharedService] getUsers:userIds success:^(LEUserService *service, NSArray *users) {
            NSMutableDictionary* inviteesDict = [NSMutableDictionary dictionary];
            [users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
                QBUUser* user = obj;
                [inviteesDict setObject:user forKey:[NSNumber numberWithInt:(int)user.ID]];
            }];
            
            [self.appointments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
                LEAppointment* appointment = obj;
                appointment.inviteeUser = [inviteesDict objectForKey:[NSNumber numberWithInt:appointment.inviteeUserId]];
            }];
            
            [self.tableView reloadData];
        } failure:^(LEUserService *service, NSString *error) {
            [self.tableView reloadData];
        }];
    } failure:^(LEAppointmentService *service, NSString *error) {
        self.appointments = nil;
        [self.tableView reloadData];
    }];
    
    [QBRTCClient.instance addDelegate:self];
    
}

#pragma UITapGestureRecognizer
- (IBAction)viewTapRecognizer:(UITapGestureRecognizer *)recognizer {
    [self.searchBar resignFirstResponder];
}


#pragma UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.appointments) {
        return [self.appointments count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LEAppointment* appointment = [self.appointments objectAtIndex:indexPath.row];
    LEMainViewControllerTableViewCell *cell = [LEMainViewControllerTableViewCell mainViewControllerTableViewCell];
    cell.appointment = appointment;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
}

#pragma mark - QBRTCClientDelegate
- (void)didReceiveNewSession:(QBRTCSession *)session userInfo:(NSDictionary *)userInfo {
    [self showIndicatorView];
    
    NSMutableArray* userIds = [NSMutableArray array];
    [session.opponentsIDs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        NSNumber* userId = obj;
        [userIds addObject:userId];
    }];
    [userIds addObject:session.initiatorID];
    
    [[LEUserService sharedService] getUsers:userIds success:^(LEUserService *service, NSArray *users) {
        [self hideIndicatorView];
        IncomingCallViewController* viewController = [[IncomingCallViewController alloc] initWithSessionAndUsers:session users:users];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
    } failure:^(LEUserService *service, NSString *error) {
        [self hideIndicatorView];
    }];
}


#pragma mark - LEMainViewControllerTableViewCellDelegate
- (void)mainViewControllerTableViewCell:(LEMainViewControllerTableViewCell*)cellView startVideoCall:(QBUUser*)user {
    NSArray* opponentsIDs = [NSArray arrayWithObject:[NSNumber numberWithInt:(int)user.ID]];
    QBRTCSession* session = [QBRTCClient.instance createNewSessionWithOpponents:opponentsIDs withConferenceType:QBRTCConferenceTypeVideo];
    VideoCallViewController* viewController = [[VideoCallViewController alloc] initWithSesstionsAndOpponentUsers:session opponentUsers:[NSArray arrayWithObject:user]];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - IncomingCallViewControllerDelegate
- (void)incomingCallViewController:(IncomingCallViewController *)vc didAcceptSession:(QBRTCSession *)session {
    [self showIndicatorView];
    NSMutableArray* userIds = [NSMutableArray array];
    [session.opponentsIDs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        NSNumber* userId = obj;
        if ([LEAccountService sharedService].account.user.ID != [userId intValue]) {
            [userIds addObject:userId];
        }
    }];
    [userIds addObject:session.initiatorID];
    
    [[LEUserService sharedService] getUsers:userIds success:^(LEUserService *service, NSArray *users) {
        [self hideIndicatorView];
        VideoCallViewController* viewController = [[VideoCallViewController alloc] initWithSesstionsAndOpponentUsers:session opponentUsers:users];
        [self.navigationController pushViewController:viewController animated:YES];
    } failure:^(LEUserService *service, NSString *error) {
        [self hideIndicatorView];
    }];
}

- (void)incomingCallViewController:(IncomingCallViewController *)viewContoller didRejectSession:(QBRTCSession *)session {
    [viewContoller.navigationController popViewControllerAnimated:YES];
}
@end
