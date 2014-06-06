//
//  SettingsViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    _rightsLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:14];
    _rightsLabel.textColor = [UIColor colorWithRed:99.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    
    [self setCloseButton];
    [self setTitleForNavBar];

    [self configureButtons];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Configure Buttons methods

- (void)configureButtons
{
    _editProfileButton.titleLabel.font = [UIFont fontWithName:@"Capriola-Regular" size:16.5];
    _changePassButton.titleLabel.font = [UIFont fontWithName:@"Capriola-Regular" size:16.5];
    _paymentInfoButton.titleLabel.font = [UIFont fontWithName:@"Capriola-Regular" size:16.5];
    _aboutFlexButton.titleLabel.font = [UIFont fontWithName:@"Capriola-Regular" size:16.5];
    
}

- (void)setCloseButton
{
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *closeBtnImage = [UIImage imageNamed:@"tb-close-normal"]  ;
    UIImage *closeBtnImagePressed = [UIImage imageNamed:@"tb-close-pressed"]  ;
    
    [closeBtn setBackgroundImage:closeBtnImage forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:closeBtnImagePressed forState:UIControlStateHighlighted];
    
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(0, 0, 58, 30);
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:closeBtn] ;
    self.navigationItem.leftBarButtonItem = closeButton;
}

- (void)setTitleForNavBar
{
    
    UIView *myView = [[UIView alloc] initWithFrame:self.navigationItem.titleView.frame];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(-43, -8, 90, 20)];
    titleLable.font = [UIFont fontWithName:@"Capriola-Regular" size:16.5];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = @"Settings";
    [myView addSubview:titleLable];
    
    self.navigationItem.titleView = myView;
}

#pragma mark -
#pragma mark Actions Methods

- (void)closeAction
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"settingsSegueBack" sender:self];

}


- (IBAction)signOutAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];

}

























@end
