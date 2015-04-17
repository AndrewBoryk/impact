//
//  StoryController.m
//  menu
//
//  Created by Andrew Boryk on 3/8/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import "StoryController.h"

@interface StoryController ()

@end

@implementation StoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.webview.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSURL *url = self.url;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webview.delegate = self;
    [self.webview loadRequest:request];
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activity];
    [self navigationItem].rightBarButtonItem = barButton;
    self.activity.hidesWhenStopped = YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activity startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activity stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.activity stopAnimating];
}

@end
