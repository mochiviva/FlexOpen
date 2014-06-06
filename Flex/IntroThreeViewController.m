//
//  IntroThreeViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/16/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "IntroThreeViewController.h"
#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@interface IntroThreeViewController ()

@end

@implementation IntroThreeViewController

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

	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _firstLabel.font = [UIFont fontWithName:@"TheSans-B5Plain" size:14.5];
    _secondLabel.font = [UIFont fontWithName:@"TheSans-B5Plain" size:14.5];
    _termsButtonOutlet.titleLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:14.5];
    _privacyButtonOutlet.titleLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:14.5];
    
    [self setBackButton];
    [self setRightButton];
    [self setTitleForNavBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Controls Configuration

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
- (void)setRightButton
{
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *nextBtnImage = [UIImage imageNamed:@"tb-next-normal"]  ;
    UIImage *nextBtnImagePressed = [UIImage imageNamed:@"tb-next-pressed"]  ;
    
    [nextBtn setBackgroundImage:nextBtnImage forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:nextBtnImagePressed forState:UIControlStateHighlighted];
    
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.frame = CGRectMake(0, 0, 50, 30);
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithCustomView:nextBtn] ;
    self.navigationItem.rightBarButtonItem = nextButton;
}
- (void)setTitleForNavBar
{
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tb-progress-2"]];
    [image setFrame:CGRectMake(-37, 0, 74, 17)];
    UIView *myView = [[UIView alloc] initWithFrame:self.navigationItem.titleView.frame];
    [myView addSubview:image];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(-43, -17, 90, 17)];
    titleLable.font = [UIFont systemFontOfSize:14];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = @"Create Profile";
    [myView addSubview:titleLable];
    
    self.navigationItem.titleView = myView;
}

#pragma mark -
#pragma mark Actions Methods

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextAction
{
    [self performSegueWithIdentifier:@"RegisterThree" sender:self];
    
}

- (IBAction)signInButtonAction:(id)sender {
    [self.delegate signInAction:self];

}

- (IBAction)registerButtonAction:(id)sender {
    [self.delegate registerAction:self];

}

- (IBAction)signInFacebookButtonAction:(id)sender {
    [self.delegate signInFacebookAction:self];

}

- (IBAction)signInGoogleButtonAction:(id)sender {
    [self.delegate signInGoogleAction:self];

}
- (IBAction)termsButtonAction:(id)sender {
}
@end
