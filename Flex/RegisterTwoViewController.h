//
//  RegisterTwoViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface RegisterTwoViewController : UITableViewController<WebServiceDelegate>


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIButton *swimmingButton;
@property (strong, nonatomic) IBOutlet UIButton *gymButton;
@property (strong, nonatomic) IBOutlet UIButton *yogaButton;
@property (strong, nonatomic) IBOutlet UIButton *dancingButton;
@property (strong, nonatomic) IBOutlet UIButton *boxingButton;
@property (strong, nonatomic) IBOutlet UIButton *mmaButton;
@property (strong, nonatomic) IBOutlet UIButton *ptButton;
@property (strong, nonatomic) IBOutlet UIButton *othersButton;

@property (strong, nonatomic) WebService *myWebService;

- (IBAction)swimmingAction:(id)sender;
- (IBAction)gymAction:(id)sender;
- (IBAction)yogaAction:(id)sender;
- (IBAction)dancingAction:(id)sender;
- (IBAction)boxingAction:(id)sender;
- (IBAction)mmaAction:(id)sender;
- (IBAction)ptAction:(id)sender;
- (IBAction)othersAction:(id)sender;

@end
