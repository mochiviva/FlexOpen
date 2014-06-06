//
//  VenueAlbumViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"
#import "Venue.h"

@interface VenueAlbumViewController : UIViewController<UIScrollViewDelegate,WebServiceDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *picturesScrollView;
@property (strong, nonatomic) IBOutlet UIButton *leftAction;
@property (strong, nonatomic) IBOutlet UIButton *rightAction;
@property (strong, nonatomic) IBOutlet UIImageView *frameImageView;

@property (strong, nonatomic) WebService *myWebService;

@property (strong, nonatomic) Venue *venue;

@property (strong, nonatomic) NSArray *pictureArray;

- (IBAction)rightTouchAction:(id)sender;
- (IBAction)leftTouchAction:(id)sender;

@end
