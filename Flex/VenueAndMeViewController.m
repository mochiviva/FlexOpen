//
//  VenueAndMeViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "VenueAndMeViewController.h"

@interface VenueAndMeViewController ()

@end

@implementation VenueAndMeViewController

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
    _venueMap.delegate = self;
    [_venueMap addAnnotation:_venue];
    _venueMap.showsUserLocation = YES;
    if ([[UIScreen mainScreen]bounds].size.height>480) {
        CGRect mapFrame = _venueMap.frame;
        
        _venueMap.frame = CGRectMake(mapFrame.origin.x, mapFrame.origin.y, mapFrame.size.width, mapFrame.size.height + 88);
    }
    _locationManager = [[CLLocationManager alloc]init];
    [_locationManager startUpdatingLocation];
	// Do any additional setup after loading the view.
    [self centerMapToVenue];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setCloseButton];
    [self setRightButton];
    [self setTitleForNavBar:_venue.nameVenue];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Controls Configuration

- (void)setCloseButton
{
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *closeBtnImage = [UIImage imageNamed:@"tb-close-normal"]  ;
    UIImage *closeBtnImagePressed = [UIImage imageNamed:@"tb-close-pressed"]  ;
    
    [closeBtn setBackgroundImage:closeBtnImage forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:closeBtnImagePressed forState:UIControlStateHighlighted];
    
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(0, 0, 58, 30);
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:closeBtn] ;
    self.navigationItem.leftBarButtonItem = closeButton;
}
- (void)setRightButton
{
    UIButton *directionsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *directionsBtnImage = [UIImage imageNamed:@"tb-directions-normal"]  ;
    UIImage *directionsBtnImagePressed = [UIImage imageNamed:@"tb-directions-pressed"]  ;
    
    [directionsBtn setBackgroundImage:directionsBtnImage forState:UIControlStateNormal];
    [directionsBtn setBackgroundImage:directionsBtnImagePressed forState:UIControlStateHighlighted];
    
    [directionsBtn addTarget:self action:@selector(directionsAction) forControlEvents:UIControlEventTouchUpInside];
    directionsBtn.frame = CGRectMake(0, 0, 80, 30);
    UIBarButtonItem *directionsButton = [[UIBarButtonItem alloc] initWithCustomView:directionsBtn] ;
    self.navigationItem.rightBarButtonItem = directionsButton;
}
- (void)setTitleForNavBar:(NSString*)title
{
    UIView *myView = [[UIView alloc] initWithFrame:self.navigationItem.titleView.frame];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(-80, -8, 160, 17)];
    titleLable.font = [UIFont fontWithName:@"Capriola-Regular" size:12.5];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = title;
    [myView addSubview:titleLable];
    
    self.navigationItem.titleView = myView;
}

#pragma mark -
#pragma mark Actions Methods

- (void)closeAction
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

//    [self performSegueWithIdentifier:@"venueMapSegueBack" sender:self];

}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)directionsAction
{
    CLLocationCoordinate2D endingCoord = _venue.coordinate;
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    
    [endingItem openInMapsWithLaunchOptions:launchOptions];
//    [self performSegueWithIdentifier:@"RegisterThree" sender:self];
    
}

#pragma mark -
#pragma mark Map Methods

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[_venueMap dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
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

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self centerMapToVenue];
}

- (void)centerMapToVenue
{
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = _locationManager.location.coordinate.latitude ;
    newRegion.center.longitude = _locationManager.location.coordinate.longitude ;
    newRegion.span.latitudeDelta = fabs(_locationManager.location.coordinate.latitude - _venue.coordinate.latitude) * 2.3;
    newRegion.span.longitudeDelta = fabs(_locationManager.location.coordinate.longitude - _venue.coordinate.longitude) * 2.3;
    [_venueMap setRegion:newRegion animated:YES];
}

@end
