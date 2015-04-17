//
//  ViewController.m
//  menu
//
//  Created by Andrew Boryk on 3/2/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *date;
    NSMutableString *description;
    NSString *cdImage;
    NSString *element;
    NSMutableArray *imageArray;
    NSMutableArray *dImageArray;
    int selectedC;
    NSDictionary *xmlDict;
    int arraySize;
    UIRefreshControl *refreshControl;
    NSUserDefaults *defaults;
    NSArray *actArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    arraySize = 0;
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    feeds = [[NSMutableArray alloc] init];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"FineSerif" size:21],
      NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:68.0f/255.0f green:108.0f/255.0f blue:179.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:68.0f/255.0f green:108.0f/255.0f blue:179.0f/255.0f alpha:1.0f];
    self.newCat = true;
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(startRefresh:)
             forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor colorWithRed:68.0f/255.0f green:108.0f/255.0f blue:179.0f/255.0f alpha:1.0f];
    [self.feedTable addSubview:refreshControl];
    self.feedTable.alwaysBounceVertical = YES;
    //[ViewController catMaker:@"Home"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.loading];
    [self navigationItem].rightBarButtonItem = barButton;
    [self.loading startAnimating];
//    NSLog(@"Did start animating");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSURL *url;
    if (self.url) {
        self.navigationController.navigationBar.topItem.title = self.cat;
        url = self.url;
    }
    else {
        self.cat = @"Home";
        self.navigationController.navigationBar.topItem.title = self.cat;
        url = [NSURL URLWithString:@"http://theimpactnews.com/feed/"];
    }
    if ([defaults objectForKey:self.cat]) {
        feeds = [[defaults objectForKey:self.cat] valueForKeyPath:@"channel.item"];
        //    NSLog(@"First Desc: %@", feeds);
        NSString *iCat = [NSString stringWithFormat:@"i%@", self.cat];
        if ([defaults objectForKey:iCat]) {
            NSLog(@"Cat: %@", iCat);
            imageArray = [[NSMutableArray alloc] init];
            for (NSData *dat in [defaults objectForKey:iCat]) {
                if ([dat isKindOfClass:[NSString class]]) {
                    [imageArray addObject:@"No"];
                }
                else{
                    UIImage *img = [UIImage imageWithData:dat];
                    if (img) {
                        [imageArray addObject:img];
                    }
                    else{
                        [imageArray addObject:@"No"];
                    }
                }
            }
            actArray = [[NSArray alloc] init];
            actArray = imageArray;
            arraySize = (int)[feeds count];
            [self.feedTable reloadData];
            [self.loading stopAnimating];
        }
        else{
            imageArray = [[NSMutableArray alloc] init];
            dImageArray = [[NSMutableArray alloc] init];
                for (NSDictionary *desc in feeds) {
                    cdImage = [self firstImgUrlString:[desc valueForKeyPath:@"description"]];
                        NSURL *urlDat = [NSURL URLWithString:cdImage];
                        NSData *dat = [NSData dataWithContentsOfURL:urlDat];
                        UIImage *img = [UIImage imageWithData:dat];
                        if (img) {
                            NSData *someImageData = UIImagePNGRepresentation(img);
                            [imageArray addObject:img];
                            [dImageArray addObject:someImageData];
                        }
                        else{
                            [imageArray addObject:@"No"];
                            [dImageArray addObject:@"No"];
                        }
                }
                NSString *iCat = [NSString stringWithFormat:@"i%@", self.cat];
                [defaults setObject:dImageArray forKey:iCat];
                [defaults synchronize];
            actArray = [[NSArray alloc] init];
            actArray = imageArray;
                arraySize = (int)[feeds count];
                [self.feedTable reloadData];
                [self.loading stopAnimating];
        }
    }
    else{
        dispatch_queue_t someQueue = dispatch_queue_create("cell background queue", NULL);
        dispatch_async(someQueue, ^(void){
            NSData *xData = [NSData dataWithContentsOfURL:url];
            xmlDict = [NSDictionary dictionaryWithXMLData:xData];
            [defaults setObject:xmlDict forKey:self.cat];
            feeds = [xmlDict valueForKeyPath:@"channel.item"];
            //    NSLog(@"First Desc: %@", feeds);
            imageArray = [[NSMutableArray alloc] init];
            dImageArray = [[NSMutableArray alloc] init];
                for (NSDictionary *desc in feeds) {
                cdImage = [self firstImgUrlString:[desc valueForKeyPath:@"description"]];
                    NSURL *urlDat = [NSURL URLWithString:cdImage];
                    NSData *dat = [NSData dataWithContentsOfURL:urlDat];
                    UIImage *img = [UIImage imageWithData:dat];
                    if (img) {
                        NSData *someImageData = UIImagePNGRepresentation(img);
                        [imageArray addObject:img];
                        [dImageArray addObject:someImageData];
                    }
                    else{
                        [imageArray addObject:@"No"];
                        [dImageArray addObject:@"No"];
                    }
                }
                NSString *iCat = [NSString stringWithFormat:@"i%@", self.cat];
                [defaults setObject:dImageArray forKey:iCat];
                [defaults synchronize];
            actArray = [[NSArray alloc] init];
            actArray = imageArray;
                arraySize = (int)[feeds count];
                [self.feedTable reloadData];
        });
    }

//    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
//    [parser setDelegate:self];
//    [parser setShouldResolveExternalEntities:NO];
//    
//    [parser parse];
}


#pragma mark - Collection View data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return arraySize;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    StoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    if (indexPath.row == [feeds count]) {
//        cell.moreLabel.font = [UIFont fontWithName:@"Serif72Beta-Bold" size:25];
//        cell.sSubtitle = nil;
//        cell.sImage = nil;
//        cell.sAutDatHolder = nil;
//        cell.moreView.hidden = 0;
//        if(self.cat){
//            if ([self.cat isEqualToString: @"Home"]) {
//                cell.moreLabel.text = [NSString stringWithFormat:@"More Stories"];
//            }
//            else{
//                cell.moreLabel.text = [NSString stringWithFormat:@"More %@", self.cat];
//            }
//        }
//    }
//    else{
        cell.moreView.hidden = 1;
        cell.sAutDatHolder.layer.borderWidth = .25f;
        cell.sAutDatHolder.layer.borderColor = [UIColor colorWithRed:20.0f/255.0f green:41.0f/255.0f blue:84.0f/255.0f alpha:1.0f].CGColor;
        NSString *trimmed = [[[feeds objectAtIndex:indexPath.row] valueForKeyPath:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        cell.sTitle.text = [NSString stringWithFormat:@"%@",trimmed];
        
        if (trimmed.length >= 35) {
            cell.sTitle.font = [UIFont fontWithName:@"Serif72Beta-Bold" size:17];
        }
        else{
            cell.sTitle.font = [UIFont fontWithName:@"Serif72Beta-Bold" size:20];
        }
        description = [[NSMutableString alloc]init];
        [description appendString:[[feeds objectAtIndex:indexPath.row] valueForKeyPath:@"description"]];
        NSMutableString *str = [[[[feeds objectAtIndex:indexPath.row] valueForKeyPath:@"description"] componentsSeparatedByString:@"</a>"] objectAtIndex:0];
        //NSLog(@"Str: %@", str);
        if ([str containsString:@"<a"]) {
            [description replaceOccurrencesOfString:str withString:@"" options:0 range:NSMakeRange(0, description.length)];
            [(NSMutableString *)description replaceOccurrencesOfString:@"</a>" withString:@"" options:0 range:NSMakeRange(0, description.length)];
            description = [description mutableCopy];
            [self checkForWierd];
            cell.sSubtitle.text = description;
        }
        else{
            //NSLog(@"Desc: %@", description);
            [self checkForWierd];
            cell.sSubtitle.text = description;
        }
        cell.sSubtitle.font = [UIFont fontWithName:@"Serif6Beta-Regular" size:16];
        cell.sSubtitle.textAlignment = NSTextAlignmentJustified;
        cell.sAuthor.font = [UIFont fontWithName:@"Serif6Beta-Italic" size:14];
        NSString *tempDate = [[feeds objectAtIndex:indexPath.row] valueForKeyPath:@"pubDate"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
        NSDate *dating = [dateFormatter dateFromString:tempDate];
        NSDateFormatter *oFormat = [[NSDateFormatter alloc] init];
        [oFormat setDateFormat:@"EEE, d MMM yyyy"];
        cell.sDate.font = [UIFont fontWithName:@"Serif6Beta-Italic" size:14];
        cell.sDate.text = [NSString stringWithFormat:@"%@", [oFormat stringFromDate:dating]];
        cell.sAuthor.text = [[feeds objectAtIndex:indexPath.row] valueForKeyPath:@"dc:creator"];
        if ([[actArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
            cell.sImage.image = nil;
        }
        else{
            cell.sImage.image = [actArray objectAtIndex:indexPath.row];
        }
        cell.sImage.layer.cornerRadius = 2.5f;
        cell.sImage.layer.borderColor = [UIColor colorWithRed:20.0f/255.0f green:41.0f/255.0f blue:84.0f/255.0f alpha:1.0f].CGColor;
        cell.sImage.layer.borderWidth = .5f;
        cell.layer.cornerRadius = 5.0f;
        cell.layer.borderWidth = .25f;
        cell.layer.borderColor = [UIColor colorWithRed:20.0f/255.0f green:41.0f/255.0f blue:84.0f/255.0f alpha:1.0f].CGColor;
//        
//    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    if (indexPath.row < feeds.count) {
        selectedC = (int)indexPath.row;
        [self performSegueWithIdentifier:@"showDetail" sender:self];
//    }
//    else{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.theimpactnews.com"]];
//    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize sizeOfCell;
    if (indexPath.row < feeds.count) {
        float cellWid = self.view.frame.size.width - 20;
        float cellHei = self.view.frame.size.height- 84;
        sizeOfCell = CGSizeMake(cellWid, cellHei);
    }
    else{
        float cellWid = self.view.frame.size.width - 20;
        float cellHei = 50;
        sizeOfCell = CGSizeMake(cellWid, cellHei);
    }
    
    return sizeOfCell;
}

-(void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == ((NSIndexPath*)[[collectionView indexPathsForVisibleItems] lastObject]).row){
        [self.loading stopAnimating];
        self.newCat = false;
    }
}

//-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
//    element = elementName;
//    if ([element isEqualToString:@"item"]) {
//        item = [[NSMutableDictionary alloc] init];
//        title = [[NSMutableString alloc] init];
//        link = [[NSMutableString alloc] init];
//        description = [[NSMutableString alloc] init];
//        date = [[NSMutableString alloc] init];
//    }
//}

//-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
//    if ([elementName isEqualToString:@"item"]) {
//        [item setObject:title forKey:@"title"];
//        [item setObject:link forKey:@"link"];
//        [item setObject:description forKey:@"description"];
//        [item setObject:date forKey:@"date"];
//        NSString *check = [self firstImgUrlString:cdImage];
//        if (check) {
//            NSURL *urlDat = [NSURL URLWithString:check];
//            NSData *dat = [NSData dataWithContentsOfURL:urlDat];
//            UIImage *img = [UIImage imageWithData:dat];
//           [item setObject:img forKey:@"img"];
//        }
//        [feeds addObject:[item mutableCopy]];
//    }
//}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    }
    else if ([element isEqualToString:@"link"]){
        [link appendString:string];
    }
    else if ([element isEqualToString:@"pudDate"]){
        [date appendString:string];
    }
    else if ([element isEqualToString:@"description"]){
        [description appendString:string];
        if ([description containsString:@"&#8217;"]) {
            [description replaceOccurrencesOfString:@"&#8217;" withString:@"'" options:0 range:NSMakeRange(0, [description length])];
        }
        
        if ([description containsString:@"&#8211;"]) {
            [description replaceOccurrencesOfString:@"&#8211;" withString:@"-" options:0 range:NSMakeRange(0, [description length])];
        }
        if ([description containsString:@"&#160; "]) {
            [description replaceOccurrencesOfString:@"&#160; " withString:@"" options:0 range:NSMakeRange(0, [description length])];
        }
        if ([description containsString:@" [&#8230;]"]) {
            [description replaceOccurrencesOfString:@" [&#8230;]" withString:@"..." options:0 range:NSMakeRange(0, [description length])];
        }
        if ([description containsString:@"•••"]) {
            [description replaceOccurrencesOfString:@"•••" withString:@"..." options:0 range:NSMakeRange(0, [description length])];
        }
        if ([description containsString:@"&#8220;"]) {
            [description replaceOccurrencesOfString:@"&#8220;" withString:@"\"" options:0 range:NSMakeRange(0, [description length])];
        }
        if ([description containsString:@"&#8221;"]) {
            [description replaceOccurrencesOfString:@"&#8221;" withString:@"\"" options:0 range:NSMakeRange(0, [description length])];
        }
        
    }
}

-(void)checkForWierd{
    if ([description containsString:@"&#8217;"]) {
        [description replaceOccurrencesOfString:@"&#8217;" withString:@"'" options:0 range:NSMakeRange(0, [description length])];
    }
    if ([description containsString:@"&#8211;"]) {
        [description replaceOccurrencesOfString:@"&#8211;" withString:@"-" options:0 range:NSMakeRange(0, [description length])];
    }
    if ([description containsString:@"&#160; "]) {
        [description replaceOccurrencesOfString:@"&#160; " withString:@"" options:0 range:NSMakeRange(0, [description length])];
    }
    if ([description containsString:@" [&#8230;]"]) {
        [description replaceOccurrencesOfString:@" [&#8230;]" withString:@"..." options:0 range:NSMakeRange(0, [description length])];
    }
    if ([description containsString:@"•••"]) {
        [description replaceOccurrencesOfString:@"•••" withString:@"..." options:0 range:NSMakeRange(0, [description length])];
    }
    if ([description containsString:@"&#8220;"]) {
        [description replaceOccurrencesOfString:@"&#8220;" withString:@"\"" options:0 range:NSMakeRange(0, [description length])];
    }
    if ([description containsString:@"&#8221;"]) {
        [description replaceOccurrencesOfString:@"&#8221;" withString:@"\"" options:0 range:NSMakeRange(0, [description length])];
    }
}

//-(void)parserDidEndDocument:(NSXMLParser *)parser{
//    [self.feedTable reloadData];
//    [self.loading stopAnimating];
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSString *string = [feeds[selectedC] valueForKeyPath:@"link"];
        NSURL *tempUrl = [NSURL URLWithString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [[segue destinationViewController] setUrl:tempUrl];
    }
}

-(IBAction)startRefresh:(id)sender{
    NSURL *url;
    if (self.url) {
        self.navigationController.navigationBar.topItem.title = self.cat;
        url = self.url;
    }
    else {
        self.navigationController.navigationBar.topItem.title = @"Home";
        url = [NSURL URLWithString:@"http://theimpactnews.com/feed/"];
    }
    dispatch_queue_t someQueue = dispatch_queue_create("cell background queue", NULL);
    dispatch_async(someQueue, ^(void){
        NSData *xData = [NSData dataWithContentsOfURL:url];
        xmlDict = [NSDictionary dictionaryWithXMLData:xData];
        [defaults setObject:xmlDict forKey:self.cat];
        feeds = [xmlDict valueForKeyPath:@"channel.item"];
        //    NSLog(@"First Desc: %@", feeds);
        imageArray = [[NSMutableArray alloc] init];
        dImageArray = [[NSMutableArray alloc] init];
            for (NSDictionary *desc in feeds) {
                cdImage = [self firstImgUrlString:[desc valueForKeyPath:@"description"]];
                NSURL *urlDat = [NSURL URLWithString:cdImage];
                NSData *dat = [NSData dataWithContentsOfURL:urlDat];
                UIImage *img = [UIImage imageWithData:dat];
                if (img) {
                    NSData *someImageData = UIImagePNGRepresentation(img);
                    [imageArray addObject:img];
                    [dImageArray addObject:someImageData];
                }
                else{
                    [imageArray addObject:@"No"];
                    [dImageArray addObject:@"No"];
                }
            }
            NSString *iCat = [NSString stringWithFormat:@"i%@", self.cat];
            [defaults setObject:dImageArray forKey:iCat];
            [defaults synchronize];
            arraySize = (int)[feeds count];
        actArray = [[NSArray alloc] init];
        actArray = imageArray;
            [self.feedTable reloadData];
            [refreshControl endRefreshing];
    });
}

//- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
//{
//    NSMutableString *comp = [[NSMutableString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
//    NSLog(@"CDImage: %@", comp);
//    if (![comp containsString:@"twttr_button"]) {
//        cdImage = [[NSMutableString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
//        [description appendString:cdImage];
//        NSMutableString *str = [[cdImage componentsSeparatedByString:@"</a>"] objectAtIndex:0];
//        if (str) {
//            [description replaceOccurrencesOfString:str withString:@"" options:0 range:NSMakeRange(0, description.length)];
//            [(NSMutableString *)description replaceOccurrencesOfString:@"</a>" withString:@"" options:0 range:NSMakeRange(0, description.length)];
//            description = [description mutableCopy];
//            [item setObject:description forKey:@"description"];
//        }
//    }
//}

- (NSString *)firstImgUrlString:(NSString *)string
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:string
                                                     options:0
                                                       range:NSMakeRange(0, [string length])];
    
    if (result)
        return [string substringWithRange:[result rangeAtIndex:2]];
    
    return nil;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
