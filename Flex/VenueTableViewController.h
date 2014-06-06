//
//  VenueTableViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/29/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "WebService.h"
#import "Venue.h"

@interface VenueTableViewController : UITableViewController<MKMapViewDelegate,CLLocationManagerDelegate,WebServiceDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) MKMapView *venuesMapView;

//Data properties:
@property (strong, nonatomic) NSDictionary *venueIDDictionary;

@property (strong, nonatomic) NSDictionary *scheduleDictionary;
@property (strong, nonatomic) NSArray *scheduleArray;

@property (strong, nonatomic) NSDictionary *facilitiesDictionary;
@property (strong, nonatomic) NSArray *facilitiesArray;

@property (strong, nonatomic) NSArray *classesArray;

@property (strong, nonatomic) WebService *myWebService;
@property (strong, nonatomic) WebService *myWebServiceHandle;
@property (strong, nonatomic) WebService *myWebServiceUpload;

@property (strong, nonatomic) Venue *venue;

@property (strong, nonatomic) UIScrollView *picturesScrollView;
@property (strong, nonatomic) UIPageControl *pageControlForPictures;

@property (strong, nonatomic) UIButton *favouriteBtn;

//@property (strong, nonatomic) IBOutlet UIButton *checkinButton;

@end
