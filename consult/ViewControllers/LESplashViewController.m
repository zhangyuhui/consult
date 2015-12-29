//
//  LESplashViewController.m
//  consult
//
//  Created by Yuhui Zhang on 12/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LESplashViewController.h"
#import "LEMainViewController.h"

@interface LESplashViewController ()

@end

@implementation LESplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma Actions
- (IBAction)clickSkip:(id)sender {
    LEMainViewController* mainViewController = [[LEMainViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:mainViewController animated:YES];
}

- (IBAction)clickTakeATour:(id)sender {
    
}
@end
