//
//  LEBrowserViewController.m
//  consult
//
//  Created by Ulearning on 15/11/17.
//  Copyright © 2015年 Yuhui Zhang. All rights reserved.
//

#import "LEBrowserViewController.h"
#import "LEDefines.h"
#import "LEAppDelegate.h"
#import <UIKit/UIKit.h>

@interface LEBrowserViewController() <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView* webView;
@end

@implementation LEBrowserViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self showIndicatorView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

#pragma mark -UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideIndicatorView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [self hideIndicatorView];
}

@end
