//
//  SignInViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "SignInViewController.h"
#import "MainTableViewController.h"
#import "ResetPassViewController.h"
@interface SignInViewController ()

@end

@implementation SignInViewController


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

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _emailTextField.delegate = self;
    _passwordTextField.delegate = self;
    
    _emailTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultUser"];
    if ([self validateEmail:_emailTextField.text])
        [_passwordTextField becomeFirstResponder];
    else
        [_emailTextField becomeFirstResponder];

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
    _passwordTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
    _forgotButton.titleLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:16];

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
    UIButton *signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *signInBtnImage = [UIImage imageNamed:@"tb-signin-normal"]  ;
    UIImage *signInBtnImagePressed = [UIImage imageNamed:@"tb-signin-pressed"]  ;
    
    [signInBtn setBackgroundImage:signInBtnImage forState:UIControlStateNormal];
    [signInBtn setBackgroundImage:signInBtnImagePressed forState:UIControlStateHighlighted];
    
    [signInBtn addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
    signInBtn.frame = CGRectMake(0, 0, 57, 30);
    UIBarButtonItem *signInButton = [[UIBarButtonItem alloc] initWithCustomView:signInBtn] ;
    self.navigationItem.rightBarButtonItem = signInButton;
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
#pragma mark Text Fields Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _passwordTextField) {
        [self signIn];
    }
    if (textField == _emailTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    return NO;
}

#pragma mark -
#pragma mark Actions Methods

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)signIn
{
    if (_myWebService == nil) {
        _myWebService = [[WebService alloc]init];
        _myWebService.delegate = self;
        [_myWebService startActionSignInEmail:_emailTextField.text password:_passwordTextField.text];
    }
    

}

- (IBAction)forgotPassAction:(id)sende
{
    [self performSegueWithIdentifier:@"forgotPassSegue" sender:self];
}

#pragma mark -
#pragma mark myWebService Delegate Methods

-(void) webServiceConnecting:(NSString*)req;
{
    if ([req isEqualToString:@"startActionSignInEmail"]) {
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

    if ([req isEqualToString:@"startActionSignInEmail"]) {
        _locationManager = [[CLLocationManager alloc]init];
        [_locationManager startUpdatingLocation];
        
        [[NSUserDefaults standardUserDefaults] setObject:_emailTextField.text forKey:@"defaultUser"];
        [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:[[webServiceResponse objectForKey:@"user"] objectForKey:@"userId"] forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] setObject:[[webServiceResponse objectForKey:@"app"] objectForKey:@"token"] forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:[[webServiceResponse objectForKey:@"app"] objectForKey:@"secret"] forKey:@"secret"];
        double latVar = self.locationManager.location.coordinate.latitude;
        double longVar = self.locationManager.location.coordinate.longitude;
        NSString *latitude = [NSString stringWithFormat:@"%f",latVar];
        NSString *longitude = [NSString stringWithFormat:@"%f",longVar];
        if (latVar || longVar)
        {
            [[NSUserDefaults standardUserDefaults] setObject:latitude forKey:@"latitude"];
            [[NSUserDefaults standardUserDefaults] setObject:longitude forKey:@"longitude"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _myWebService = [[WebService alloc]init];
        _myWebService.delegate = self;
        [_myWebService getHomeForUserID:[[webServiceResponse objectForKey:@"user"] objectForKey:@"userId"] lat:[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] lng:[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]];

        
    }
    if ([req isEqualToString:@"getHomeForUserID"]) {
        _mainDictionary = webServiceResponse;

        [self performSegueWithIdentifier:@"mainSegue" sender:self];

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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    double latVar, longVar;
    
    latVar = self.locationManager.location.coordinate.latitude;
    longVar = self.locationManager.location.coordinate.longitude;
    NSString *latitude = [NSString stringWithFormat:@"%f",latVar];
    NSString *longitude = [NSString stringWithFormat:@"%f",longVar];
    [[NSUserDefaults standardUserDefaults]setObject:latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults]setObject:longitude forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [_locationManager stopUpdatingLocation];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mainSegue"])
    {
        MainTableViewController *viewController = [segue destinationViewController];
        viewController.mainDictionary = _mainDictionary;
    }
    if ([segue.identifier isEqualToString:@"forgotPassSegue"])
    {
        ResetPassViewController *viewController = [segue destinationViewController];
        viewController.email = _emailTextField.text;
    }
}

-(void)dealloc
{
    _myWebService.delegate = nil;
}

@end
