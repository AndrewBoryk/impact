//
//  ViewController.h
//  menu
//
//  Created by Andrew Boryk on 3/2/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "StoryController.h"
#import "StoryCell.h"
#import <QuartzCore/QuartzCore.h>
#import "XMLDictionary.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, NSXMLParserDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSString *cat;
@property BOOL newCat;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (strong, nonatomic) UIActivityIndicatorView *loading;
@property (strong, nonatomic) IBOutlet UICollectionView *feedTable;

@end
