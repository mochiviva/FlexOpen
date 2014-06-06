//
//  SettingsViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
- (IBAction)signOutAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) IBOutlet UIButton *changePassButton;
@property (strong, nonatomic) IBOutlet UIButton *paymentInfoButton;
@property (strong, nonatomic) IBOutlet UIButton *aboutFlexButton;
@property (strong, nonatomic) IBOutlet UILabel *rightsLabel;

@end
