//
//  SignInViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WebService.h"

@interface SignInViewController : UIViewController<UITextFieldDelegate,WebServiceDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *forgotButton;

@property (strong, nonatomic) WebService *myWebService;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSDictionary *mainDictionary;

- (IBAction)forgotPassAction:(id)sender;
@end
