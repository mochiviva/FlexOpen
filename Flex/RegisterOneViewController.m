//
//  RegisterOneViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "RegisterOneViewController.h"

@interface RegisterOneViewController ()

@end

@implementation RegisterOneViewController

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
    
    _nameTextField.delegate = self;
    _emailTextField.delegate = self;
    _passwordTextField.delegate = self;
    [self configureFields];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];

    [self setBackButton];
    [self setRightButton];
    [self setTitleForNavBar];

}

- (void)viewDidAppear:(BOOL)animated
{
    [_nameTextField becomeFirstResponder];
    
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
    _nameTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
    _emailTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
    _passwordTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
    
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
    //progress image
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tb-progress-1"]];
    [image setFrame:CGRectMake(-37, 0, 74, 17)];
    UIView *myView = [[UIView alloc] initWithFrame:self.navigationItem.titleView.frame];
    [myView addSubview:image];
    
    //title
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(-43, -17, 90, 17)];
    titleLable.font = [UIFont fontWithName:@"Capriola-Regular" size:12.5];
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

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

- (void)nextAction
{
    if (_myWebService == nil)
    {
        if (_nameTextField.text.length <= 2)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please type your name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }else if(![self validateEmail:_emailTextField.text]) {
            // user entered invalid email address
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Enter a valid email address." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }else if(_passwordTextField.text.length < 3)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You must set a password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        else {
            // user entered valid email address
            _myWebService = [[WebService alloc]init];
            _myWebService.delegate = self;
            [_myWebService startActionCreateUser:_emailTextField.text fullName:_nameTextField.text password:_passwordTextField.text];
        }
    }
}
#pragma mark -
#pragma mark Text Fields Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _passwordTextField) {
        [self nextAction];
    }
    if (textField == _nameTextField)
    {
        [_emailTextField becomeFirstResponder];
    }
    if (textField == _emailTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    return NO;
}

#pragma mark -
#pragma mark myWebService Delegate Methods

-(void) webServiceConnecting:(NSString*)req;
{
    if ([req isEqualToString:@"startActionCreateUser"]) {
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
    if ([req isEqualToString:@"startActionCreateUser"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[webServiceResponse objectForKey:@"user"] objectForKey:@"userId"] forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] setObject:_emailTextField.text forKey:@"defaultUser"];
        [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:[[webServiceResponse objectForKey:@"app"] objectForKey:@"token"] forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:[[webServiceResponse objectForKey:@"app"] objectForKey:@"secret"] forKey:@"secret"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"RegisterTwoSegue" sender:self];
    }
}
//wrong login; temporary service unavailable; network failure
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
