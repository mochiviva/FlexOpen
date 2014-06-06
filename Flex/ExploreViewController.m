//
//  ExploreViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "ExploreViewController.h"
#import "VenueDetailsView.h"
#import "VenueTableViewController.h"
#import "Venue.h"

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

#define ICONVIEW_TAG 1
#define CELLVIEW_TAG 2
#define VENUEVIEW_TAG 3



@interface ExploreViewController ()
@property (assign) BOOL isLoadedFromSearch;
@property (strong,nonatomic) NSDictionary *searchParams;

@end

@implementation ExploreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    _noVenueLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:16];
    _noVenueLabel.hidden = YES;
//    _venuesArray = [NSArray array];
//    _myWebService = [[WebService alloc]init];
//    _myWebService.delegate = self;
//    NSString *latitude = [[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"];
//    NSString *longitude = [[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"];
//
//    [_myWebService listVenuesWithName:@"" category:@"" favorites:@"" lat:latitude lng:longitude page:@"" start:@"" pagesize:@"50"];
    
    _isLoadedFromSearch = 0;
    [self configureScrollView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHomeButton];
    [self setRightButton];
    [self setTitleForNavBar];
    

    

//    [self configureData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_isLoadedFromSearch) {
        _myWebService = [[WebService alloc]init];
        _myWebService.delegate = self;
        NSString *latitude = [[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"];
        NSString *longitude = [[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"];
        
        [_myWebService listVenuesWithName:@"" category:@"" favorites:@"" lat:latitude lng:longitude page:@"" start:@"" pagesize:@"50"];
    }else
    {
        _myWebService = [[WebService alloc]init];
        _myWebService.delegate = self;
        [_myWebService listVenuesWithName:[_searchParams objectForKey:@"name"]
                                 category:[_searchParams objectForKey:@"category"]
                                favorites:[_searchParams objectForKey:@"favorites"]
                                      lat:[_searchParams objectForKey:@"lat"]
                                      lng:[_searchParams objectForKey:@"lng"]
                                     page:[_searchParams objectForKey:@"page"]
                                    start:[_searchParams objectForKey:@"start"]
                                 pagesize:[_searchParams objectForKey:@"pagesize"]];

    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Data Methods

- (void)configureData
{
    
    NSArray *brutArray = [_mainDictionary objectForKey:@"data"] == [NSNull null]? @[@""] :[_mainDictionary objectForKey:@"data"];
    NSMutableArray *venuesCollection = [NSMutableArray array];
    for (NSDictionary *oneVenue in brutArray) {
        if ([oneVenue count]>=1) {
            
            Venue *venue = [[Venue alloc]initForHomeWithDictionary:oneVenue];
            [venuesCollection addObject:venue];
            
        }
                
        
    }
    
    _venuesArray = [venuesCollection copy];
    if (_venuesArray.count == 0)
        _noVenueLabel.hidden = NO;
    else
        _noVenueLabel.hidden = YES;
    [_venuesTableView reloadData];
    [self addAnnotationsToMap];
        
}


#pragma mark -
#pragma mark TableView Configuration

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [_venuesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *iconView;
    UIImageView *cellView;
    VenueDetailsView *firstVenueDetail;
    UITableViewCell *cell;
    static NSString *CellIdentifier = @"MyReuseIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
            
            cellView = [[UIImageView alloc]initWithFrame:CGRectMake(42, 5, 271, 56)];
            cellView.tag = CELLVIEW_TAG;

            cellView.image = [UIImage imageNamed:@"gym-slot-normal"];
            cellView.highlightedImage = [UIImage imageNamed:@"gym-slot-pressed"];
            iconView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 14, 30, 35)];
            iconView.tag = ICONVIEW_TAG;
            
            [cell.contentView addSubview:iconView];
            [cell.contentView addSubview:cellView];
        }
    else
    {
        iconView = (UIImageView *)[cell.contentView viewWithTag:ICONVIEW_TAG];
        cellView = (UIImageView *)[cell.contentView viewWithTag:CELLVIEW_TAG];
        firstVenueDetail = (VenueDetailsView *)[cellView viewWithTag:VENUEVIEW_TAG];
        [firstVenueDetail removeFromSuperview];
    }
    // Configure the cell...
    Venue *theVenue = [_venuesArray objectAtIndex:indexPath.row];
    
    double starsNumber = [theVenue.ratingVenue doubleValue];

    firstVenueDetail = [[VenueDetailsView alloc]initWithName:theVenue.nameVenue category:theVenue.categoryVenue distance:theVenue.distanceVenue stars:starsNumber favorite:NO];
    firstVenueDetail.tag = VENUEVIEW_TAG;
    [cellView addSubview:firstVenueDetail];
    iconView.image =[UIImage imageNamed:theVenue.iconName];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell *selectedCell = [_venuesTableView cellForRowAtIndexPath:indexPath];
        UIImageView *selectedImage = (UIImageView*)[selectedCell viewWithTag:CELLVIEW_TAG];
        selectedImage.highlighted = YES;
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell *selectedCell = [_venuesTableView cellForRowAtIndexPath:indexPath];
        UIImageView *selectedImage = (UIImageView*)[selectedCell viewWithTag:CELLVIEW_TAG];
        selectedImage.highlighted = NO;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    _selectedVenue = [_venuesArray objectAtIndex:indexPath.row];

    [self performSegueWithIdentifier:@"exploreVenueSegue" sender:self];

}

- (void)showDetails:(id)sender
{
    for (Venue *annotation in self.venuesMap.selectedAnnotations)
    {
        _selectedVenue = annotation;
        
    }
    
    [self performSegueWithIdentifier:@"exploreVenueSegue" sender:self];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"exploreVenueSegue"])
    {
        VenueTableViewController *viewController = [segue destinationViewController];
        viewController.venue = _selectedVenue;
    }
    if ([[segue identifier] isEqualToString:@"searchSegue"])
    {
        SearchViewController *viewController = [segue destinationViewController];
        viewController.delegate = self;
    }
}
#pragma mark -
#pragma mark Map Methods
-(void)addAnnotationsToMap
{
    [_venuesMap removeAnnotations:_venuesMap.annotations];
    for (Venue *oneVenue in _venuesArray) {
        [_venuesMap addAnnotation:oneVenue];
        
    }
    for (Venue *oneVenue in _venuesArray) {
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
    
    annotationView.canShowCallout = YES;
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self
                    action:@selector(showDetails:)
          forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    return annotationView;
}


#pragma mark -
#pragma mark ScrollView Configuration

- (void)configureScrollView
{
    _myScrollView.frame = CGRectMake(_myScrollView.frame.origin.x, _myScrollView.frame.origin.y,_myScrollView.frame.size.width, ASSET_BY_SCREEN_HEIGHT(_myScrollView.frame.size.height,_myScrollView.frame.size.height+88));
    _myScrollView.contentSize = CGSizeMake(_myScrollView.frame.size.width, _myScrollView.frame.size.height*2);
    [_myScrollView setDelegate:self];
    _venuesTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _myScrollView.frame.size.width, _myScrollView.frame.size.height) style:UITableViewStylePlain];
    _venuesTableView.backgroundView = nil;
    _venuesTableView.backgroundColor = [UIColor clearColor];
    _venuesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _venuesTableView.delegate = self;
    _venuesTableView.dataSource = self;
    _venuesMap = [[MKMapView alloc]initWithFrame:CGRectMake(0, _myScrollView.frame.size.height, _myScrollView.frame.size.width, _myScrollView.frame.size.height)];
    _venuesMap.delegate = self;
    [_myScrollView addSubview:_venuesTableView];
    [_myScrollView addSubview:_venuesMap];

    if (_shouldLoadMap) {
        [_mapListButton setImage:[UIImage imageNamed:@"list-view-normal"] forState:UIControlStateNormal];
        [_mapListButton setImage:[UIImage imageNamed:@"list-view-pressed"] forState:UIControlStateHighlighted];
        [_myScrollView scrollRectToVisible:CGRectMake(0, _myScrollView.frame.size.height, _myScrollView.frame.size.width, _myScrollView.frame.size.height) animated:NO];
        [_venuesMap setRegion:_regionFromHome animated:YES];
        _shouldLoadMap = NO;
    }
    
}

#pragma mark -
#pragma mark Controls Configuration

- (void)setHomeButton
{
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *homeBtnImage = [UIImage imageNamed:@"tb-home-normal"]  ;
    UIImage *homeBtnImagePressed = [UIImage imageNamed:@"tb-home-pressed"]  ;
    
    [homeBtn setBackgroundImage:homeBtnImage forState:UIControlStateNormal];
    [homeBtn setBackgroundImage:homeBtnImagePressed forState:UIControlStateHighlighted];
    
    [homeBtn addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
    homeBtn.frame = CGRectMake(0, 0, 37, 37);
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithCustomView:homeBtn] ;
    self.navigationItem.leftBarButtonItem = homeButton;
}
- (void)setRightButton
{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *searchBtnImage = [UIImage imageNamed:@"tb-search-normal"]  ;
    UIImage *searchBtnImagePressed = [UIImage imageNamed:@"tb-search-pressed"]  ;
    
    [searchBtn setBackgroundImage:searchBtnImage forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:searchBtnImagePressed forState:UIControlStateHighlighted];
    
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.frame = CGRectMake(0, 0, 37, 37);
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithCustomView:searchBtn] ;
    self.navigationItem.rightBarButtonItem = searchButton;
}
- (void)setTitleForNavBar
{
    UIView *myView = [[UIView alloc] initWithFrame:self.navigationItem.titleView.frame];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(-73, -8, 150, 17)];
    titleLable.font = [UIFont fontWithName:@"Capriola-Regular" size:12.5];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = @"All Nearby";
    if (_searchParams != nil && ![[_searchParams objectForKey:@"category"] isEqualToString:@"All"])
        titleLable.text = [NSString stringWithFormat:@"All %@ Nearby", [_searchParams objectForKey:@"category"]];
    NSArray *brutArray = [_mainDictionary objectForKey:@"data"] == [NSNull null]? @[@""] :[_mainDictionary objectForKey:@"data"];
    if (_isLoadedFromSearch && brutArray.count == 0)
        titleLable.text = @"No Venues Nearby";

    [myView addSubview:titleLable];
    
    self.navigationItem.titleView = myView;
}

#pragma mark -
#pragma mark Actions Methods

- (void)homeAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchAction
{
    [self performSegueWithIdentifier:@"searchSegue" sender:self];
    
}

- (IBAction)listMapAction:(id)sender {
    if (_myScrollView.contentOffset.y == 0) {
        
        [_mapListButton setImage:[UIImage imageNamed:@"list-view-normal"] forState:UIControlStateNormal];
        [_mapListButton setImage:[UIImage imageNamed:@"list-view-pressed"] forState:UIControlStateHighlighted];
        [_myScrollView scrollRectToVisible:CGRectMake(0, _myScrollView.frame.size.height, _myScrollView.frame.size.width, _myScrollView.frame.size.height) animated:YES];
    }
    else
    {
        [_mapListButton setImage:[UIImage imageNamed:@"map-view-normal"] forState:UIControlStateNormal];
        [_mapListButton setImage:[UIImage imageNamed:@"map-view-pressed"] forState:UIControlStateHighlighted];
        
        [_myScrollView scrollRectToVisible:CGRectMake(0, 0, _myScrollView.frame.size.width, _myScrollView.frame.size.height) animated:YES];

    }
    
    
}

#pragma mark -
#pragma mark myWebService Delegate Methods

-(void) webServiceConnecting:(NSString*)req;
{
    //activity indicator here?
}
-(void) webServiceResponded:(NSDictionary*)webServiceResponse forRequest:(NSString*)req;
{
    _mainDictionary = webServiceResponse;
    [self configureData];

}
//wrong login; temporary service unavailable; network failure
-(void) webServiceError:(NSString *)alertMessage forRequest:(NSString *)req;
{
    _myWebService = nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -
#pragma mark search Delegate Methods

-(void)implementSearchDictionary:(NSDictionary*)searchDict andParams:(NSDictionary *)params;
{
    _searchParams = params;
    _isLoadedFromSearch = 1;
    _mainDictionary = searchDict;
    [self configureData];

}

-(void)dealloc
{
    _myWebService.delegate = nil;
}

@end
