//
//  StoryCell.h
//  menu
//
//  Created by Andrew Boryk on 4/1/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *sImage;
@property (strong, nonatomic) IBOutlet UILabel *sTitle;
@property (strong, nonatomic) IBOutlet UITextView *sSubtitle;
@property (strong, nonatomic) IBOutlet UILabel *sDate;
@property (strong, nonatomic) IBOutlet UIView *moreView;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;
@property (strong, nonatomic) IBOutlet UILabel *sAuthor;
@property (strong, nonatomic) IBOutlet UIView *sAutDatHolder;

@end
