//
//  NavigationViewController.m
//  menu
//
//  Created by Andrew Boryk on 3/2/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

UIActivityIndicatorView *spinner;

@implementation NavigationViewController{
    NSArray *menu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    menu = @[@"First", @"Second", @"Third", @"Fourth", @"Fifth", @"Sixth", @"Seventh", @"Eighth", @"Nineth", @"Tenth"];
    self.view.backgroundColor = [UIColor colorWithRed:68.0f/255.0f green:108.0f/255.0f blue:179.0f/255.0f alpha:1.0f];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [spinner stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [menu count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell.textLabel setFont:[UIFont fontWithName:@"FineSerif" size:25.0f]];
    }
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.theimpactnews.com"]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
    
    swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController *svc, UIViewController *dvc){
        
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers:@[dvc] animated:YES];
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    };
    NSURL *tempUrl;
    NSString *cat;
    if ([[segue identifier] isEqualToString:@"showNews"]) {
        cat = @"News";
        tempUrl = [NSURL URLWithString:@"http://theimpactnews.com/category/news/feed/"];
    }
    else if ([[segue identifier] isEqualToString:@"showSports"]){
        cat = @"Sports";
        tempUrl = [NSURL URLWithString:@"http://theimpactnews.com/category/sports/feed/"];
    }
    else if ([[segue identifier] isEqualToString:@"showEnt"]){
        cat = @"Entertainment";
        tempUrl = [NSURL URLWithString:@"http://theimpactnews.com/category/entertainment/feed/"];
    }
    else if ([[segue identifier] isEqualToString:@"showOpinion"]){
        cat = @"Opinion";
        tempUrl = [NSURL URLWithString:@"http://theimpactnews.com/category/opinion/feed/"];
    }
    else if ([[segue identifier] isEqualToString:@"showProfiles"]){
        cat = @"Profiles";
        tempUrl = [NSURL URLWithString:@"http://theimpactnews.com/category/profiles/feed/"];
    }
    else if ([[segue identifier] isEqualToString:@"showColumnists"]){
        cat = @"Columnists";
        tempUrl = [NSURL URLWithString:@"http://theimpactnews.com/category/columnists/feed/"];
    }
    else if ([[segue identifier] isEqualToString:@"showTilt"]){
        cat = @"TILT";
        tempUrl = [NSURL URLWithString:@"http://theimpactnews.com/category/tilt/feed/"];
    }
    else if ([[segue identifier] isEqualToString:@"showImp"]){
        cat = @"Impact Now";
        tempUrl = [NSURL URLWithString:@"http://theimpactnews.com/category/impact-now/feed/"];
    }
    else{
        cat = @"Home";
        tempUrl = [NSURL URLWithString:@"http://theimpactnews.com/feed/"];
    }
    [[segue destinationViewController] setCat:cat];
    [[segue destinationViewController] setNewCat:true];
    [[segue destinationViewController] setUrl:tempUrl];
    
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


@end
