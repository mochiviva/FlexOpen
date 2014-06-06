//
//  IntroThreeViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/16/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroThreeActionsDelegate <NSObject>

- (void)signInAction:(id)sender;
- (void)registerAction:(id)sender;
- (void)signInFacebookAction:(id)sender;
- (void)signInGoogleAction:(id)sender;


@end

@interface IntroThreeViewController : UIViewController

- (IBAction)signInButtonAction:(id)sender;
- (IBAction)registerButtonAction:(id)sender;
- (IBAction)signInFacebookButtonAction:(id)sender;
- (IBAction)signInGoogleButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIButton *termsButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *privacyButtonOutlet;


@property (nonatomic, assign) id <IntroThreeActionsDelegate> delegate;
@end
