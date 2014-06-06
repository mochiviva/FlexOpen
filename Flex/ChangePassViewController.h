//
//  ChangePassViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface ChangePassViewController : UIViewController<UITextFieldDelegate,WebServiceDelegate>
@property (strong, nonatomic) IBOutlet UITextField *currentPassTextField;
@property (strong, nonatomic) IBOutlet UITextField *myNewPassTextField;
@property (strong, nonatomic) IBOutlet UITextField *reEnterPassTextField;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@property (strong, nonatomic) WebService *myWebService;

@end
