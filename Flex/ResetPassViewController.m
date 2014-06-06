//
//  ResetPassViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "ResetPassViewController.h"

@interface ResetPassViewController ()

@end

@implementation ResetPassViewController

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
    [_emailTextField becomeFirstResponder];
    _emailTextField.text = _email;
    [self configureFields];

	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    
    [self setBackButton];
    [self setTitleForNavBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Controls Configuration

- (void)configureFields
{
    _emailTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
    
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
    //progress image
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tb-logo"]];
    [image setFrame:CGRectMake(-33, -16.5, 67, 31)];
    UIView *myView = [[UIView alloc] initWithFrame:self.navigationItem.titleView.frame];
    [myView addSubview:image];
    
    
    self.navigationItem.titleView = myView;
}

#pragma mark -
#pragma mark Actions Methods

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resetPassAction:(id)sender
{
    _myWebService = [[WebService alloc]init];
    _myWebService.delegate = self;
    [_myWebService resetPasswordForUserEmail:_emailTextField.text];
}

#pragma mark -
#pragma mark myWebService Delegate Methods

-(void) webServiceConnecting:(NSString*)req;
{
    if ([req isEqualToString:@"resetPasswordForUserEmail"]) {
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect titleRect = self.navigationItem.titleView.frame;
        CGRect activityFrame = CGRectMake(80, 0, titleRect.size.height, titleRect.size.height);
        _activityView.frame = activityFrame;
        
        [self.navigationItem.titleView addSubview:_activityView];
        [_activityView startAnimating];
    }
}
-(void) webServiceResponded:(NSDictionary*)webServiceResponse forRequest:(NSString*)req;
{
    _myWebService = nil;
    if ([req isEqualToString:@"resetPasswordForUserEmail"])
    {
        [self goback];
    }
}
-(void) webServiceError:(NSString *)alertMessage forRequest:(NSString *)req;
{
    [_activityView stopAnimating];
    _myWebService = nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)dealloc
{
    _myWebService.delegate = nil;
}

@end
