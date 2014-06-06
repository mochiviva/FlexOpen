//
//  RegisterThreeViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface RegisterThreeViewController : UIViewController<UITextFieldDelegate,WebServiceDelegate>
@property (strong, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *expirationTextField;
@property (strong, nonatomic) IBOutlet UITextField *secretTextField;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
- (IBAction)cardNumberChangedAction:(id)sender;
- (IBAction)expirationChangedAction:(id)sender;
- (IBAction)secretChangedAction:(id)sender;
@property (strong, nonatomic) NSDictionary *mainDictionary;

@property (strong, nonatomic) WebService *myWebService, *myWebService2;

@end
