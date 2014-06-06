//
//  MainTableViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 5/27/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "MainTableViewController.h"
#import "VenueDetailsView.h"
#import "VenueTableViewController.h"
#import "Venue.h"
#import "ExploreViewController.h"
#import "FlexPassViewController.h"
#import "AppDelegate.h"

#define MESSAGE_SECTION 0
#define VENUES_SECTION 1
#define EXPLORE_SECTION 2
#define MAP_SPAN 0.05

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@interface MainTableViewController ()

@property (strong, nonatomic) Venue *selectedVenue;
@property (assign) BOOL oneVenue;
@property (strong, nonatomic) Venue *mapVenueOne;
@property (strong, nonatomic) Venue *mapVenueTwo;
@property (assign) BOOL shouldLoadMapToExplore;
@property (assign) MKCoordinateRegion regionToSend;


@end

@implementation MainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _myWebService = [[WebService alloc] init];
    _myWebService.delegate = self;
    [_myWebService getUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
    
    [self configureData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    CLLocationManager *locationManager = [[CLLocationManager alloc]init];
    [locationManager startUpdatingLocation];
    
    double latVar = locationManager.location.coordinate.latitude;
    double longVar = locationManager.location.coordinate.longitude;
    NSString *latitude = [NSString stringWithFormat:@"%f",latVar];
    NSString *longitude = [NSString stringWithFormat:@"%f",longVar];
    if (latVar || longVar)
    {
        [[NSUserDefaults standardUserDefaults] setObject:latitude forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults] setObject:longitude forKey:@"longitude"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
  
    _myWebService2 = [[WebService alloc] init];
    _myWebService2.delegate = self;
    [_myWebService2 getHomeForUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] lat:[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"] lng:[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]];
    
    [self setSettingsButton];
    [self setTitleForNavBar];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureData
{
    
    _messagesArray = [_mainDictionary objectForKey:@"messages"] == [NSNull null]? @[@""] :[_mainDictionary objectForKey:@"messages"];
    
    //configure nearbyFavVenues Array
    if ([_mainDictionary objectForKey:@"nearbyFavs"]!=[NSNull null]) {
        NSArray *venuesFavArray = [_mainDictionary objectForKey:@"nearbyFavs"];
        if (venuesFavArray) {
            NSMutableArray *venuesCollection = [NSMutableArray array];
            for (NSDictionary *oneVenue in venuesFavArray) {
                if ([oneVenue count]>=1) {
                    Venue *venue = [[Venue alloc]initForHomeWithDictionary:oneVenue];
                    [venuesCollection addObject:venue];
                }
                
            }
            _nearbyFavsArray = [venuesCollection copy];
        }
        
    }
    
    //configure nearbyVenues Array
    if ([_mainDictionary objectForKey:@"nearbyVenues"]!=[NSNull null]) {
        
        NSArray *venuesArray = [_mainDictionary objectForKey:@"nearbyVenues"];
        if (venuesArray) {
            NSMutableArray *venuesCollection = [NSMutableArray array];
            for (NSDictionary *oneVenue in venuesArray) {
                Venue *venue = [[Venue alloc]initForHomeWithDictionary:oneVenue];
                [venuesCollection addObject:venue];
            }
            _nearbyVenuesArray = [venuesCollection copy];
        }
    }
    
//    [self addAnnotationsToMap];
    
    if ([_nearbyFavsArray count]>=1) {
        _oneVenue = 1;
//        [self configureScreenFavorite];
    } else if ([_nearbyVenuesArray count]>=2)
    {
        _oneVenue = 0;

//        [self configureScreenNearby];
    } else if ([_nearbyVenuesArray count]==1)
    {
        _oneVenue = 1;

//        [self configureScreenNearbyOne];
    } else
    {
        _oneVenue = 1;

//        [self configureScreenDefault];
    }
    _mapVenueOne = [_nearbyVenuesArray objectAtIndex:0]?[_nearbyVenuesArray objectAtIndex:0]:nil;
    _mapVenueTwo = [_nearbyVenuesArray objectAtIndex:1]?[_nearbyVenuesArray objectAtIndex:1]:_mapVenueOne;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];

//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];

//    [self.tableView reloadData];
}
#pragma mark -
#pragma mark Controls Configuration

- (void)setSettingsButton
{
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingsBtnImage = [UIImage imageNamed:@"tb-settings-normal"]  ;
    UIImage *settingsBtnImagePressed = [UIImage imageNamed:@"tb-settings-pressed"]  ;
    
    [settingsBtn setBackgroundImage:settingsBtnImage forState:UIControlStateNormal];
    [settingsBtn setBackgroundImage:settingsBtnImagePressed forState:UIControlStateHighlighted];
    
    [settingsBtn addTarget:self action:@selector(goSettings) forControlEvents:UIControlEventTouchUpInside];
    settingsBtn.frame = CGRectMake(0, 0, 26, 26);
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn] ;
    //    self.navigationItem.rightBarButtonItem = settingsButton;
    self.navigationItem.leftBarButtonItem = settingsButton;
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationItem.titleView.center = self.navigationController.navigationBar.center;
}

- (void)setTitleForNavBar
{
    //progress image
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tb-logo"]];
    [image setFrame:CGRectMake(-33, -16.5, 67, 31)];
    UIView *myView = [[UIView alloc] initWithFrame:self.navigationItem.titleView.frame];
    [myView addSubview:image];
    
    self.navigationItem.titleView = myView;
    
//    _messageLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:18];
//    _messageLabel.textColor = [UIColor whiteColor];
//    _messageLabel.text = @"Get 5 Passes until 5 April and enter the race for winning a trip to the moon!";
//    
//    _nearbyLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:14.5];
    //    _nearbyLabel.textColor = [UIColor grayColor];
    //    _nearbyLabel.text = @"Nearby Favorite";
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch(section) {
        case MESSAGE_SECTION:
            return 1;
        case VENUES_SECTION:
            if (_oneVenue) {
                return 1;

            } else 
            {
                return 2;
                
            }
        case EXPLORE_SECTION:
            return 1;
        
        default:
            return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //venue-title-bkg.png
    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectNull];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    backView.image = [UIImage imageNamed:@"venue-title-bkg"];
    //    backView.alpha = 0.8;
    [sectionHeader addSubview:backView];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
    sectionLabel.backgroundColor = [UIColor clearColor];
    sectionLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:14.5];
    sectionLabel.textColor = [UIColor grayColor];
    [sectionHeader addSubview:sectionLabel];
    switch(section) {
            
        case VENUES_SECTION:
            if ([_nearbyFavsArray count]>=1) {
                sectionLabel.text = @"Nearby Favorite";
                sectionLabel.textColor = [UIColor colorWithRed:99.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
            }
            else
            {
                sectionLabel.text = @"Nearby";
                sectionLabel.textColor = [UIColor colorWithRed:99.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
            }
            return sectionHeader;
            
        default:
            return nil;
            
            break;
    }
    
    //    return sectionHeader;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch(section) {
        case MESSAGE_SECTION:
            return 0;
        case VENUES_SECTION:
            return 30;
        case EXPLORE_SECTION:
            return 0;
        default:
            return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section) {
        case MESSAGE_SECTION:
            return 99;
        case VENUES_SECTION:
            return 65;
        case EXPLORE_SECTION:
            if (_oneVenue) {
                return ASSET_BY_SCREEN_HEIGHT(212, 212+88);
                
            } else 
            {
                return ASSET_BY_SCREEN_HEIGHT(149, 149+88);
                
            } 
                default:
            return 65;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == MESSAGE_SECTION) {
        static NSString *CellIdentifier = @"messageCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
        }
        UILabel *messageLabel = (UILabel*)[cell viewWithTag:1];
        messageLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:17];
        if ([_messagesArray count]>=1) {
            NSLog(@"%@", _messagesArray);
            messageLabel.text = [[_messagesArray objectAtIndex:0] objectForKey:@"message"];
        }
        
    }
    if (indexPath.section == VENUES_SECTION) {
        
        static NSString *CellIdentifier;
        if ([_nearbyFavsArray count] >= 1) {
            CellIdentifier = @"favoriteCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            if (cell == nil) {
                
            }
            Venue *theVenue = [_nearbyFavsArray objectAtIndex:indexPath.row];
            _mapVenueOne = theVenue;
            
            double starsNumber = [theVenue.ratingVenue doubleValue];
            VenueDetailsView *firstVenueDetail = [[VenueDetailsView alloc]initWithName:theVenue.nameVenue category:theVenue.categoryVenue distance:theVenue.distanceVenue stars:starsNumber favorite:YES];
            
            UIView *supportView = (UIView*)[cell viewWithTag:22];
            if ([[supportView subviews]count]>=1) {
                [[[supportView subviews] objectAtIndex:0]removeFromSuperview];
            }
            [supportView addSubview: firstVenueDetail];
            
            UIButton *favButton = (UIButton*)[cell viewWithTag:23];
            
            [favButton addTarget:self action:@selector(getPass:) forControlEvents:UIControlEventTouchUpInside];
            

        }else
        {
            
            CellIdentifier = @"nearbyCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                
            }
            Venue *theVenue = [_nearbyVenuesArray objectAtIndex:indexPath.row];
            double starsNumber = [theVenue.ratingVenue doubleValue];
            VenueDetailsView *firstVenueDetail = [[VenueDetailsView alloc]initWithName:theVenue.nameVenue category:theVenue.categoryVenue distance:theVenue.distanceVenue stars:starsNumber favorite:NO];
            

            
            UIView *supportView = (UIView*)[cell viewWithTag:22];
            if ([[supportView subviews]count]>=1) {
                [[[supportView subviews] objectAtIndex:0]removeFromSuperview];
            }
            [supportView addSubview: firstVenueDetail];


            UIButton *favButton = (UIButton*)[cell viewWithTag:23];
            
            [favButton addTarget:self action:@selector(getPass:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
    }
    if (indexPath.section == EXPLORE_SECTION) {
        static NSString *CellIdentifier = @"exploreCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            //            [[NSBundle mainBundle] loadNibNamed:@"venuePhotosCell" owner:self options:nil];
            //            cell = myAddNameCell;
        }
        _venuesMap = (MKMapView*)[cell viewWithTag:31];
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(mapToMapAction)];
        [_venuesMap addGestureRecognizer:singleFingerTap];
        _venuesMap.delegate = self;
        [self addAnnotationsToMap];

        
        UIButton *theButton = (UIButton*)[cell viewWithTag:32];
        [theButton addTarget:self action:@selector(venueMapAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *supportImageView = (UIImageView*)[cell viewWithTag:33];
        
        if (_oneVenue) {
            CGFloat frameHeight = ASSET_BY_SCREEN_HEIGHT(212, 212+88);
            supportImageView.frame = CGRectMake(supportImageView.frame.origin.x, supportImageView.frame.origin.y, supportImageView.frame.size.width, frameHeight);
            supportImageView.image = [UIImage imageNamed: ASSET_BY_SCREEN_HEIGHT(@"map-holder-4-big", @"map-holder-5-big")];

            _venuesMap.frame = CGRectMake(_venuesMap.frame.origin.x, _venuesMap.frame.origin.y, _venuesMap.frame.size.width, frameHeight-59);
            
            MKCoordinateRegion region = MKCoordinateRegionMake(_mapVenueOne.coordinate, MKCoordinateSpanMake(0.05, 0.05));
            _regionToSend = region;
            [_venuesMap setRegion:region animated:YES];

        } else
        {
            CGFloat frameHeight = ASSET_BY_SCREEN_HEIGHT(149, 149+88);
            supportImageView.frame = CGRectMake(supportImageView.frame.origin.x, supportImageView.frame.origin.y, supportImageView.frame.size.width, frameHeight);
            supportImageView.image = [UIImage imageNamed: ASSET_BY_SCREEN_HEIGHT(@"map-holder-4-small", @"map-holder-5-small")];
            
            _venuesMap.frame = CGRectMake(_venuesMap.frame.origin.x, _venuesMap.frame.origin.y, _venuesMap.frame.size.width, frameHeight-59);

            MKCoordinateRegion newRegion;
            newRegion.center.latitude = (_mapVenueOne.coordinate.latitude + _mapVenueTwo.coordinate.latitude)/2 ;
            newRegion.center.longitude = (_mapVenueOne.coordinate.longitude + _mapVenueTwo.coordinate.longitude)/2 ;
//            newRegion.span = MKCoordinateSpanMake(0.05, 0.05);
            newRegion.span.latitudeDelta = fabs(_mapVenueOne.coordinate.latitude - _mapVenueTwo.coordinate.latitude) * 2.3;
            newRegion.span.longitudeDelta = fabs(_mapVenueOne.coordinate.longitude - _mapVenueTwo.coordinate.longitude) * 2.3;
            _regionToSend = newRegion;
            [_venuesMap setRegion:newRegion animated:YES];

        }
        
    }
    
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == VENUES_SECTION) {

        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
        UIImageView *selectedImage = (UIImageView*)[selectedCell viewWithTag:21];
        selectedImage.highlighted = YES;
    }
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == VENUES_SECTION) {

        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
        UIImageView *selectedImage = (UIImageView*)[selectedCell viewWithTag:21];
        selectedImage.highlighted = NO;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if (indexPath.section == VENUES_SECTION) {
        
        
        if ([_nearbyFavsArray count] >= 1) {
            _selectedVenue = [_nearbyFavsArray objectAtIndex:0];
        }else
        {
            _selectedVenue = [_nearbyVenuesArray objectAtIndex:indexPath.row];
        }
        [self performSegueWithIdentifier:@"homeVenueSegue" sender:self];
    }
    if (indexPath.section == EXPLORE_SECTION) {
        [self performSegueWithIdentifier:@"exploreSegue" sender:self];

    }


}


#pragma mark -
#pragma mark Actions Methods

- (void)goSettings
{
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}
- (void)getPass:(id)sender
{
    
    UITableViewCell *selectedCell = (UITableViewCell*)[sender superview];
    NSIndexPath* pathOfTheCell = [self.tableView indexPathForCell:selectedCell];

    if (_oneVenue) {
        _selectedVenue = [_nearbyFavsArray objectAtIndex:0];
    } else
    {
        _selectedVenue = [_nearbyVenuesArray objectAtIndex:pathOfTheCell.row];
    }
    [self performSegueWithIdentifier:@"homePassSegue" sender:self];
}
- (void)mapToMapAction
{
    _shouldLoadMapToExplore = YES;
    [self performSegueWithIdentifier:@"exploreSegue" sender:self];
    
}
- (void)venueMapAction
{
    _shouldLoadMapToExplore = NO;
    [self performSegueWithIdentifier:@"exploreSegue" sender:self];
    
}

-(void) saveNewPhotoFromUrl:(NSString*)photoUrl
{
    NSLog(@"the Photo url for user is: %@",photoUrl);
    
    [[NSUserDefaults standardUserDefaults] setObject:photoUrl forKey:@"memberPhotoUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //    NSData *imgData = UIImageJPEGRepresentation(resultingImage, 1);
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]];
    // Identify the home directory and file name
    NSString *fileName = @"memberPhoto";
    
    NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.jpg",fileName]];
    
    // Write the file, atomically to enforce an all or none write, NO if partially written files are okay in case of corruption
    [imgData writeToFile:jpgPath atomically:YES];
}
#pragma mark -
#pragma mark myWebService Delegate Methods

-(void) webServiceConnecting:(NSString*)req;
{
    if ([req isEqualToString:@"getUserID"]) {
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect titleRect = self.navigationItem.titleView.frame;
        CGRect activityFrame = CGRectMake(80, 0, titleRect.size.height, titleRect.size.height);
        _activityView.frame = activityFrame;
        
        [self.navigationItem.titleView addSubview:_activityView];
        [_activityView startAnimating];
    }
    if ([req isEqualToString:@"getHomeForUserID"])
    {
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect titleRect = self.navigationItem.titleView.frame;
        CGRect activityFrame = CGRectMake(80, 0, titleRect.size.height, titleRect.size.height);
        _activityView.frame = activityFrame;
        
        [self.navigationItem.titleView addSubview:_activityView];
        [_activityView startAnimating];
    }
    
}
-(void) webServiceResponded:(NSDictionary*)webServiceResponse forRequest:(NSString*)req;
{
    if ([req isEqualToString:@"getUserID"]) {
        _myWebService = nil;
        NSString *newPhotoUrl = [webServiceResponse objectForKey:@"pictureUrl"] != [NSNull null] ? [webServiceResponse objectForKey:@"pictureUrl"] : @"";
        NSLog(@"New photo URL is:  %@",newPhotoUrl);
        NSLog(@"Response for New photo URL is:  %@",webServiceResponse);

        if (![newPhotoUrl isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"memberPhotoUrl"]])
            [self saveNewPhotoFromUrl:newPhotoUrl];
    }
    if ([req isEqualToString:@"getHomeForUserID"])
    {
        _myWebService2 = nil;
        _mainDictionary = webServiceResponse;
//        NSLog(@"dictionarul este: %@",_mainDictionary);
        [self configureData];
    }
}
//wrong login; temporary service unavailable; network failure
-(void) webServiceError:(NSString *)alertMessage forRequest:(NSString *)req;
{
    [_activityView stopAnimating];
    _myWebService = nil;
//    _myWebService2 = nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -
#pragma mark Map Methods
-(void)addAnnotationsToMap
{
    //    MKPointAnnotation *myPoint = [[MKPointAnnotation alloc] init];
    //    myPoint.coordinate = CLLocationCoordinate2DMake([[response objectForKey:@"lat"] doubleValue],[[response objectForKey:@"long"] doubleValue]);
    //    myPoint.coordinate = CLLocationCoordinate2DMake(43.6481,-79.4042);
    [_venuesMap removeAnnotations:_venuesMap.annotations];

    for (Venue *oneVenue in _nearbyFavsArray) {
        [_venuesMap addAnnotation:oneVenue];
        
    }
    for (Venue *oneVenue in _nearbyVenuesArray) {
        [_venuesMap addAnnotation:oneVenue];
        
    }
    
}
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[_venuesMap dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
    Venue *theAnnotation = (Venue*)annotation;
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier];
    }
    
    annotationView.image = [UIImage imageNamed:theAnnotation.iconName];
    
    //    [annotationView setImage:[UIImage imageNamed:@"mma-favorite"]];
    annotationView.frame = CGRectMake(0, 0, 30, 35);
    annotationView.annotation = annotation;
    
    //    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"homeVenueSegue"])
    {
        VenueTableViewController *viewController = [segue destinationViewController];
        viewController.venue = _selectedVenue;
    }
    if ([[segue identifier] isEqualToString:@"homePassSegue"])
    {
        FlexPassViewController *viewController = [segue destinationViewController];
        viewController.venueId = _selectedVenue.idVenue;
        viewController.venueName = _selectedVenue.nameVenue;
    }
    
    if ([[segue identifier] isEqualToString:@"exploreSegue"])
    {
        ExploreViewController *viewController = [segue destinationViewController];
        viewController.venuesArray = [_nearbyVenuesArray arrayByAddingObjectsFromArray:_nearbyFavsArray];
        viewController.shouldLoadMap = _shouldLoadMapToExplore;
        viewController.regionFromHome = _regionToSend;
    }
}

-(void)dealloc
{
    _myWebService.delegate = nil;
    _myWebService2.delegate = nil;
}

@end
