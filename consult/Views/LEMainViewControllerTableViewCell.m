//
//  LEMainViewControllerTableViewCell.m
//  consult
//
//  Created by Yuhui Zhang on 12/28/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEMainViewControllerTableViewCell.h"
#import "LEDefines.h"

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

@end
