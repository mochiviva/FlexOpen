//
//  MainTableViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 5/27/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "WebService.h"

@interface MainTableViewController : UITableViewController<MKMapViewDelegate,CLLocationManagerDelegate,WebServiceDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *venuesMap;

@property (strong, nonatomic) NSDictionary *mainDictionary;
@property (strong, nonatomic) NSArray *messagesArray;
@property (strong, nonatomic) NSArray *nearbyFavsArray;
@property (strong, nonatomic) NSArray *nearbyVenuesArray;

@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@property (strong, nonatomic) WebService *myWebService, *myWebService2;

@end
