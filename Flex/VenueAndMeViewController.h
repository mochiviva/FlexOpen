//
//  VenueAndMeViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "Venue.h"

@interface VenueAndMeViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *venueMap;
@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) CLLocationManager *locationManager;


@end
