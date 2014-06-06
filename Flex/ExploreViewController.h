//
//  ExploreViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "WebService.h"
#import "Venue.h"
#import "SearchViewController.h"



@interface ExploreViewController : UIViewController<UIScrollViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,WebServiceDelegate,SearchDelegate>


@property (weak, nonatomic) IBOutlet UILabel *noVenueLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) UITableView *venuesTableView;
@property (strong, nonatomic) MKMapView *venuesMap;

@property (strong, nonatomic) WebService *myWebService;

@property (strong, nonatomic) NSDictionary *mainDictionary;
@property (strong, nonatomic) NSArray *venuesArray;
@property (strong, nonatomic) Venue *selectedVenue;

@property (assign) BOOL shouldLoadMap;
@property (assign) MKCoordinateRegion regionFromHome;

@property (strong, nonatomic) IBOutlet UIButton *mapListButton;

- (IBAction)listMapAction:(id)sender;

@end
