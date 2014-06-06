//
//  ChangeCCViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface ChangeCCViewController : UIViewController<UITextFieldDelegate,WebServiceDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberTitle;
@property (weak, nonatomic) IBOutlet UITextField *expirationTextField;
@property (weak, nonatomic) IBOutlet UILabel *expirationTitle;
@property (weak, nonatomic) IBOutlet UITextField *secretTextField;
@property (weak, nonatomic) IBOutlet UILabel *secretTitle;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
- (IBAction)cardNumberChangedAction:(id)sender;
- (IBAction)expirationChangedAction:(id)sender;
- (IBAction)secretChangedAction:(id)sender;

@property (strong, nonatomic) WebService *myWebService;

@end
