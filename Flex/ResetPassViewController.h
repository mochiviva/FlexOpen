//
//  ResetPassViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface ResetPassViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,WebServiceDelegate>
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@property (strong, nonatomic) WebService *myWebService;

- (IBAction)resetPassAction:(id)sender;

@end
