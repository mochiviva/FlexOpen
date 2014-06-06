//
//  AboutViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    _aboutCopyLabel.font = [UIFont fontWithName:@"TheSans-B5Plain" size:12];
    _aboutTitleLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:16.5];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setBackButton];
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
    _supportButton.titleLabel.font = [UIFont fontWithName:@"Capriola-Regular" size:16.5];
    _termsButton.titleLabel.font = [UIFont fontWithName:@"Capriola-Regular" size:16.5];
    _privacyButton.titleLabel.font = [UIFont fontWithName:@"Capriola-Regular" size:16.5];
    _followButton.titleLabel.font = [UIFont fontWithName:@"Capriola-Regular" size:16.5];
    
}

- (void)setBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"tb-back-normal"]  ;
    UIImage *backBtnImagePressed = [UIImage imageNamed:@"tb-back-pressed"]  ;
    
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn setBackgroundImage:backBtnImagePressed forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 50, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)setTitleForNavBar
{
    UIView *myView = [[UIView alloc] initWithFrame:self.navigationItem.titleView.frame];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(-80, -8, 160, 20)];
    titleLable.font = [UIFont fontWithName:@"Capriola-Regular" size:16.5];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = @"About Flex";
    [myView addSubview:titleLable];
    
    self.navigationItem.titleView = myView;
}

#pragma mark -
#pragma mark Actions Methods

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)followFlexAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=getFlexTweets"]];
}
@end
