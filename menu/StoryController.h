//
//  StoryController.h
//  menu
//
//  Created by Andrew Boryk on 3/8/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryController : UIViewController <UIWebViewDelegate> 

@property (strong, nonatomic) UIActivityIndicatorView *activity;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UITextView *storySum;


@end
