//
//  FlexPassViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface FlexPassViewController : UIViewController<UITextFieldDelegate,WebServiceDelegate>
- (IBAction)dismissModal:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *memberNameOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *memberPhotoOutlet;
@property (weak, nonatomic) IBOutlet UILabel *passOutlet;
@property (strong, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabelOutlet;
@property (weak, nonatomic) IBOutlet UIView *errorViewOutlet;
@property (weak, nonatomic) IBOutlet UILabel *askAttendantLabel;

@property (weak, nonatomic) IBOutlet UILabel *lostCodeTitleLabelOutlet;
@property (weak, nonatomic) IBOutlet UILabel *lostCodeNoteLabelOutlet;
@property (weak, nonatomic) IBOutlet UIButton *callCenterButtonOutlet;
- (IBAction)callCenterButtonAction:(id)sender;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) NSString *venueId;
@property (strong, nonatomic) NSString *venueName;

@property (strong, nonatomic) NSString *fromVenue;

@property (strong, nonatomic) WebService *myWebService, *myWebService2;

@end
