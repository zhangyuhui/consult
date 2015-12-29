//
//  LEMainViewControllerTableViewCell.m
//  consult
//
//  Created by Yuhui Zhang on 12/28/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEMainViewControllerTableViewCell.h"
#import "LEDefines.h"
#import "NSDate+Addition.h"

#define TIMESTAMP_DATA_FORMAT @"yyyy-MM-dd"

@interface LEMainViewControllerTableViewCell ()
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *specialtyLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;

@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@end

@implementation LEMainViewControllerTableViewCell

- (void)awakeFromNib {
    self.iconImageView.layer.cornerRadius = 35;
    self.iconImageView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.iconImageView.layer.borderWidth = 1.0f;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.overlayView.layer.borderWidth = 1.0;
    self.overlayView.layer.borderColor = UIColorFromRGB(0xb4b22f).CGColor;
    
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.colors = [NSArray arrayWithObjects:(id)UIColorFromRGB(0x091c2d).CGColor, (id)UIColorFromRGB(0x82a3cc).CGColor, nil];
    
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.bounds;
    frame.size.height -= 20;
    self.gradientLayer.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAppointment:(LEAppointment *)appointment {
    if (_appointment != appointment) {
        _appointment = appointment;
        
        self.nameLabel.text = self.appointment.inviteeUser.fullName;
        self.priceLabel.text = [NSString stringWithFormat:@"$%.2f", self.appointment.pay];
        [self updateStatusDisplay:self.appointment.status start:self.appointment.timeStart end:self.appointment.timeEnd];
    }
}

+ (instancetype)mainViewControllerTableViewCell {
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LEMainViewControllerTableViewCell"
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
}

- (IBAction)clickActionButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(mainViewControllerTableViewCell:startVideoCall:)]) {
        [self.delegate mainViewControllerTableViewCell:self startVideoCall:self.appointment.inviteeUser];
    }
}

- (void)updateStatusDisplay:(LEAppointmentStatus)status start:(NSDate*)start end:(NSDate*)end {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:TIMESTAMP_DATA_FORMAT];
    NSString *dateString = [dateFormatter stringFromDate:start];
    
    NSDate *current = [NSDate date];
    if ([current earlierDate:start]) {
        self.statusLabel.text = [NSString stringWithFormat:@"%@ Upcomming", dateString];
    } else if ([current laterDate:start]) {
        self.statusLabel.text = [NSString stringWithFormat:@"%@ Passed", dateString];;
    } else {
        self.statusLabel.text = [NSString stringWithFormat:@"%@ Now", dateString];
    }
    
    switch (status) {
        case LEAppointmentStatusReady: {
            if ([current earlierDate:start]) {
                [self.actionButton setTitle:@"Soon" forState:UIControlStateNormal];
            } else if ([current laterDate:start]) {
                [self.actionButton setTitle:@"Passed" forState:UIControlStateNormal];
            } else {
                [self.actionButton setTitle:@"Call" forState:UIControlStateNormal];
            }
        }
            break;
        case LEAppointmentStatusCalling:
            self.statusLabel.text = @"Now";
            [self.actionButton setTitle:@"Calling" forState:UIControlStateNormal];
            break;
        case LEAppointmentStatusOngoing:
            [self.actionButton setTitle:@"Ongoing" forState:UIControlStateNormal];
            break;
        case LEAppointmentStatusFinished:
            [self.actionButton setTitle:@"Finished" forState:UIControlStateNormal];
            if (self.appointment.callStart && self.appointment.callEnd) {
                self.statusLabel.text = [NSDate stringFromTimeInterval:[self.appointment.callStart timeIntervalSince1970]];
            }
            break;
        case LEAppointmentStatusAccepted:
            [self.actionButton setTitle:@"Accepted" forState:UIControlStateNormal];
            break;
        case LEAppointmentStatusRejected:
            [self.actionButton setTitle:@"Rejected" forState:UIControlStateNormal];
            break;
        case LEAppointmentStatusIgnored:
            [self.actionButton setTitle:@"Ignored" forState:UIControlStateNormal];
            break;
        case LEAppointmentStatusCancelled:
            [self.actionButton setTitle:@"Cancelled" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

@end
