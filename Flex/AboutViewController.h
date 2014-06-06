//
//  AboutViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *supportButton;
@property (strong, nonatomic) IBOutlet UIButton *termsButton;
@property (strong, nonatomic) IBOutlet UIButton *privacyButton;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *aboutTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutCopyLabel;
- (IBAction)followFlexAction:(id)sender;

@end
