//
//  SearchViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "SearchViewController.h"
#import "Venue.h"
#import "VenueDetailsView.h"
#import "VenueTableViewController.h"

#define ICONVIEW_TAG 1
#define CELLVIEW_TAG 2
#define VENUEVIEW_TAG 3

@interface SearchViewController ()

@property (assign) BOOL isSearching;
@property (assign) BOOL viewWillDissapear;
@property (assign) BOOL didSelectRow;
@property (strong,nonatomic) NSDictionary *searchParams;
@property (strong,nonatomic) UIActivityIndicatorView *searchActivityIndicator;
@property (strong,nonatomic) UIActivityIndicatorView *searchingActivityIndicator;

@end

@implementation SearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    [self configureTableData];

    _viewWillDissapear = false;
    
    
	// Do any additional setup after loading the view.
}
#pragma mark -
#pragma mark Data Methods

- (void)configureData
{
    _isSearching = true;
    
    NSArray *brutArray = [_mainDictionary objectForKey:@"data"] == [NSNull null]? @[@""] :[_mainDictionary objectForKey:@"data"];
    NSMutableArray *venuesCollection = [NSMutableArray array];
    for (NSDictionary *oneVenue in brutArray) {
        if ([oneVenue count]>=1) {
            
            Venue *venue = [[Venue alloc]initForHomeWithDictionary:oneVenue];
            [venuesCollection addObject:venue];
            
        }
        
        
    }
    
    _venuesArray = [venuesCollection copy];

    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    
}

- (void)configureTableData
{
    _isSearching = false;

    _choicesDictionary = @{@"All":@"all-icon",@"Favorites":@"favorite-icon",@"Gym":@"gym",@"MMA":@"mma",@"Swimming":@"swimming",@"Yoga":@"yoga",@"Boxing":@"boxing",@"Dancing":@"dancing",@"PT":@"pt",@"Others":@"others"};
    _choicesArray = @[@"All",@"Favorites",@"Gym",@"MMA",@"Swimming",@"Yoga",@"Boxing",@"Dancing",@"PT",@"Others"];
//    UITableView *anotherTable = [[UITableView alloc]initWithFrame:self.tableView.frame style:UITableViewStylePlain];
//    anotherTable.dataSource = self;
//    anotherTable.delegate = self;
//    self.tableView = anotherTable;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self setBackButton];
    [self setRightButton];
//    [self setTitleForNavBar];
    [self addSearchBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Controls Configuration

- (void)setBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"tb-back-normal"]  ;
    UIImage *backBtnImagePressed = [UIImage imageNamed:@"tb-back-pressed"]  ;
    
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn setBackgroundImage:backBtnImagePressed forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 50, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}
- (void)setRightButton
{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cancelBtnImage = [UIImage imageNamed:@"tb-cancel-normal"]  ;
    UIImage *cancelBtnImagePressed = [UIImage imageNamed:@"tb-cancel-pressed"]  ;
    
    [cancelBtn setBackgroundImage:cancelBtnImage forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:cancelBtnImagePressed forState:UIControlStateHighlighted];
    
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(0, 0, 58, 30);
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn] ;
    self.navigationItem.rightBarButtonItem = cancelButton;
}
- (void)setTitleForNavBar
{
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tb-progress-2"]];
    [image setFrame:CGRectMake(-37, 0, 74, 17)];
    UIView *myView = [[UIView alloc] initWithFrame:self.navigationItem.titleView.frame];
    [myView addSubview:image];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(-43, -17, 90, 17)];
    titleLable.font = [UIFont systemFontOfSize:14];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = @"Create Profile";
    [myView addSubview:titleLable];
    
    self.navigationItem.titleView = myView;
}
- (void)addSearchBar
{
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 240, 40)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];

//    searchBar.backgroundImage = [[UIImage alloc] init];
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 241, 29)];
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 241, 29)];
    searchImageView.image = [UIImage imageNamed:@"tb-search"];
    [searchView addSubview:searchImageView];

    _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(30, 5, 210, 20)];
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    _searchTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:16];
    [_searchTextField addTarget:self action:@selector(editingChangedForTextField:) forControlEvents:UIControlEventEditingChanged];
    
    _searchTextField.delegate = self;
    [searchView addSubview:_searchTextField];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchView];
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (_isSearching) {
        return [_venuesArray count];

    }else
    {
        return [_choicesArray count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearching) {
        return 60;
        
    }else
    {
        return 44;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_isSearching) {
   
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 48)];
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = headerView.frame;
//        _searchButton = [[UIButton alloc]initWithFrame:headerView.frame];
        [_searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [_searchButton setBackgroundImage:[UIImage imageNamed: @"search-bkg"] forState:UIControlStateNormal];
        [_searchButton setBackgroundImage:[UIImage imageNamed: @"search-bkg-selected"] forState:UIControlStateHighlighted];
        [_searchButton setTitleColor:[UIColor colorWithRed:99.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

        _searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _searchButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _searchButton.titleLabel.font = [UIFont fontWithName:@"Capriola-Regular" size:17];
        
        [_searchButton setTitle:[NSString stringWithFormat:@"Search for \"%@\"",_searchTextField.text] forState:UIControlStateNormal];
//        [_searchButton setTitle:[NSString stringWithFormat:@"Search for \"%@\"",_searchTextField.text] forState:UIControlStateHighlighted];
        _searchingActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        _searchingActivityIndicator.frame = CGRectMake(272, 0, 48, 48);
            
        [headerView addSubview:_searchButton];
        [headerView addSubview:_searchingActivityIndicator];
        return headerView;

    }else
    {
        return nil;

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isSearching) {
        
        return 44;
        
    }else
    {
        return 0;
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearching) {
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
        //    VenueDetailsView *firstVenueDetail = [[VenueDetailsView alloc]initWithName:@"BamBoo Kung Foo" category:@"MMA" distance:@"5 km" stars:3];
        Venue *theVenue = [_venuesArray objectAtIndex:indexPath.row];
        
        firstVenueDetail = [[VenueDetailsView alloc]initWithName:theVenue.nameVenue category:theVenue.categoryVenue distance:theVenue.distanceVenue stars:[theVenue.ratingVenue doubleValue] favorite:NO];
        //    firstVenueDetail = [[VenueDetailsView alloc]initWithName:@"BamBoo Kung Foo" category:@"MMA" distance:[NSString stringWithFormat:@"%d km",indexPath.row] stars:3];
        firstVenueDetail.tag = VENUEVIEW_TAG;
        [cellView addSubview:firstVenueDetail];
        iconView.image =[UIImage imageNamed:theVenue.iconName];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
        
    }else
    {
        static NSString *CellIdentifier = @"choicesCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UIImageView *logoImage = (UIImageView*)[cell viewWithTag:1];
        UILabel *labelOne = (UILabel*)[cell viewWithTag:2];
        
        labelOne.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:16];

        if (indexPath.row == 0) {
            labelOne.textColor = [UIColor colorWithRed:207.0/255.0 green:72.0/255.0 blue:19.0/255.0 alpha:1];
        } else if (indexPath.row == 1)
        {
            labelOne.textColor = [UIColor colorWithRed:241.0/255.0 green:193.0/255.0 blue:2.0/255.0 alpha:1];

        } else
        {
            labelOne.textColor = [UIColor colorWithRed:99.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];

        }
        labelOne.text = [_choicesArray objectAtIndex:indexPath.row];
        NSString *imageName = [NSString stringWithFormat:@"%@-normal",[_choicesDictionary objectForKey:[_choicesArray objectAtIndex:indexPath.row]]];
        logoImage.image = [UIImage imageNamed:imageName];
        
        // Configure the cell...
        UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
        myBackView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:96.0/255.0 blue:34.0/255.0 alpha:1];
        cell.selectedBackgroundView = myBackView;
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIImageView *selectedImage = (UIImageView*)[selectedCell viewWithTag:CELLVIEW_TAG];
    selectedImage.highlighted = YES;
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
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
    if (_isSearching) {
        _selectedVenue = [_venuesArray objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"searchVenueSegue" sender:self];
    }else
    {
//        _myWebServiceForCells = [[WebService alloc]init];
//        _myWebServiceForCells.delegate = self;
        _didSelectRow = true;

        
        NSString *latitude = [[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"];
        NSString *longitude = [[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"];
        if (indexPath.row == 0) {
            //search for all venues nearby
//            [_myWebServiceForCells listVenuesWithName:@"" category:@"" favorites:@"" lat:latitude lng:longitude page:@"" start:@"" pagesize:@"50"];
            [self makeConnectionWithName:@"" category:@"" favorites:@"" lat:latitude lng:longitude page:@"" start:@"" pagesize:@"50"];
        }else if (indexPath.row == 1)
        {
            //search for favorites nearby
//            [_myWebServiceForCells listVenuesWithName:@"" category:@"" favorites:@"true" lat:latitude lng:longitude page:@"" start:@"" pagesize:@"50"];
            [self makeConnectionWithName:@"" category:@"" favorites:@"true" lat:latitude lng:longitude page:@"" start:@"" pagesize:@"50"];
        } else
        {
//            [_myWebServiceForCells listVenuesWithName:@"" category:[_choicesArray objectAtIndex:indexPath.row] favorites:@"" lat:latitude lng:longitude page:@"" start:@"" pagesize:@"50"];
            [self makeConnectionWithName:@"" category:[_choicesArray objectAtIndex:indexPath.row] favorites:@"" lat:latitude lng:longitude page:@"" start:@"" pagesize:@"50"];
        }
        
    }

}

#pragma mark -
#pragma mark Actions Methods

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelAction
{
    _viewWillDissapear = true;
    [self performSegueWithIdentifier:@"searchSegueBack" sender:self];

//    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -
#pragma mark myWebService Delegate Methods

-(void) webServiceConnecting:(NSString*)req;
{
    

    if (_didSelectRow) {
        _searchActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_searchActivityIndicator setColor:[UIColor blackColor]];
        _searchActivityIndicator.frame = self.view.frame;
        [self.view addSubview:_searchActivityIndicator];
        [_searchActivityIndicator startAnimating];

    }else
    {
        [_searchingActivityIndicator startAnimating];

    }

    
    
}
-(void) webServiceResponded:(NSDictionary*)webServiceResponse forRequest:(NSString*)req;
{
    if (_didSelectRow) {
//        _mainDictionary = webServiceResponse;
        [_searchActivityIndicator stopAnimating];
        [_searchActivityIndicator removeFromSuperview];
        [self.delegate implementSearchDictionary:webServiceResponse andParams:_searchParams];
        [self cancelAction];
    }else
    {
        [_searchingActivityIndicator stopAnimating];
        _mainDictionary = webServiceResponse;
        [self configureData];
    }
    
}
//wrong login; temporary service unavailable; network failure
-(void) webServiceError:(NSString *)alertMessage forRequest:(NSString *)req;
{
    [_searchActivityIndicator stopAnimating];
    [_searchActivityIndicator removeFromSuperview];
    [_searchingActivityIndicator stopAnimating];

    _myWebService = nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"searchVenueSegue"])
    {
        VenueTableViewController *viewController = [segue destinationViewController];
        viewController.venue = _selectedVenue;
    }


}
#pragma mark -
#pragma mark textField Delegate Methods
- (void)editingChangedForTextField:(id)sender;
{
 
    if (!_viewWillDissapear) {
//        _myWebService = [[WebService alloc]init];
//        _myWebService.delegate = self;
        NSString *latitude = [[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"];
        NSString *longitude = [[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"];
//        [_myWebService listVenuesWithName:_searchTextField.text category:@"" favorites:@"" lat:latitude lng:longitude page:@"" start:@"" pagesize:@"50"];
        [self makeConnectionWithName:_searchTextField.text category:@"" favorites:@"" lat:latitude lng:longitude page:@"" start:@"" pagesize:@"50"];

    }
    
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _choicesArray = @[];
    [self.tableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
//    [self configureTableData];
//
//    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
	return YES;
}
- (void)searchAction
{
    [self.delegate implementSearchDictionary:_mainDictionary andParams:_searchParams];
    [self cancelAction];
}
- (void)makeConnectionWithName:(NSString*)name
                      category:(NSString*)category
                     favorites:(NSString*)favorites
                           lat:(NSString*)lat
                           lng:(NSString*)lng
                          page:(NSString*)page
                         start:(NSString*)start
                      pagesize:(NSString*)pagesize
{
    _searchParams = @{@"name":name,@"category":category,@"favorites": favorites,@"lat":lat,@"lng":lng,@"page":page,@"start": start,@"pagesize":pagesize};
    _myWebService = [[WebService alloc]init];
    _myWebService.delegate = self;
    [_myWebService listVenuesWithName:name category:category favorites:favorites lat:lat lng:lng page:page start:start pagesize:pagesize];
}

-(void)dealloc
{
    _myWebService.delegate = nil;
}

@end
