//
//  ViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/4/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "IntroThreeViewController.h"
#import "WebService.h"
#import <FacebookSDK/FacebookSDK.h>

@interface IntroViewController : UIViewController <UIScrollViewDelegate,IntroThreeActionsDelegate,WebServiceDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *backScrollView;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIImageView *cornersImage;

@property (strong, nonatomic) NSTimer *animationTimer;
@property (strong, nonatomic) WebService *myWebService;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) UIImageView *activityViewHolder;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) NSDictionary *mainDictionary;

- (IBAction)changePage:(id)sender;

- (void)previousPage;
- (void)nextPage;

@end
