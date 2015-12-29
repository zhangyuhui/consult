//
//  LENavigationController.m
//  consult
//
//  Created by Yuhui Zhang on 8/29/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LENavigationController.h"

@interface LENavigationController () <UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView* backgroundView;


@end

@implementation LENavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarHidden:YES animated:NO];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LaunchImage"]];
    [self.backgroundView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [self.view addSubview:self.backgroundView];
    [self.view sendSubviewToBack:self.backgroundView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    
}

@end
