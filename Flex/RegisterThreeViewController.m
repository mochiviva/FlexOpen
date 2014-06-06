//
//  RegisterThreeViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "RegisterThreeViewController.h"
#import "MainTableViewController.h"

@interface RegisterThreeViewController ()

@end

@implementation RegisterThreeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark -
#pragma mark TextField Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1)
    {
        if (textField.text.length == 3)
        {
            textField.text = [textField.text substringToIndex:2];
        }
    }
    return YES;
}

- (IBAction)cardNumberChangedAction:(id)sender {
    [self formatCreditCardNumber];
}

- (IBAction)expirationChangedAction:(id)sender {
    NSString *oldNumber = [_expirationTextField.text stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSMutableString *number = [NSMutableString stringWithFormat:@"%@", oldNumber];
    if (number.length > 4)
        number = [NSMutableString stringWithFormat:@"%@", [number substringToIndex:4]];
    if (number.length >= 2)
        [number insertString:@"/" atIndex:2];
    _expirationTextField.text = number;
}

- (IBAction)secretChangedAction:(id)sender {
    if (_secretTextField.text.length > 4)
        _secretTextField.text = [_secretTextField.text substringToIndex:4];
}

- (void)formatCreditCardNumber
{
    NSString *oldNumber = [_cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *number = [NSMutableString stringWithFormat:@"%@", oldNumber];
    if (number.length > 16)
        number = [NSMutableString stringWithFormat:@"%@", [number substringToIndex:16]];
    if (number.length > 4)
        [number insertString:@" " atIndex:4];
    if (number.length > 9)
        [number insertString:@" " atIndex:9];
    if (number.length > 14)
        [number insertString:@" " atIndex:14];
    _cardNumberTextField.text = number;
}

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    _expirationTextField.delegate = self;
    [self configureFields];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setSkipButton];
    [self setRightButton];
    [self setTitleForNavBar];

}

- (void)viewDidAppear:(BOOL)animated
{
    [_cardNumberTextField becomeFirstResponder];
    
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
    _cardNumberTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
    _expirationTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
    _secretTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
    
    _messageLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:14];
    
}

- (void)setSkipButton
{
    UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *skipBtnImage = [UIImage imageNamed:@"tb-skip-normal"]  ;
    UIImage *skipBtnImagePressed = [UIImage imageNamed:@"tb-skip-pressed"]  ;
    
    [skipBtn setBackgroundImage:skipBtnImage forState:UIControlStateNormal];
    [skipBtn setBackgroundImage:skipBtnImagePressed forState:UIControlStateHighlighted];
    
    [skipBtn addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    skipBtn.frame = CGRectMake(0, 0, 58, 30);
    UIBarButtonItem *skipButton = [[UIBarButtonItem alloc] initWithCustomView:skipBtn] ;
    self.navigationItem.leftBarButtonItem = skipButton;
}
- (void)setRightButton
{
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *doneBtnImage = [UIImage imageNamed:@"tb-done-normal"]  ;
    UIImage *doneBtnImagePressed = [UIImage imageNamed:@"tb-done-pressed"]  ;
    
    [doneBtn setBackgroundImage:doneBtnImage forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:doneBtnImagePressed forState:UIControlStateHighlighted];
    
    [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.frame = CGRectMake(0, 0, 57, 30);
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithCustomView:doneBtn] ;
    self.navigationItem.rightBarButtonItem = doneButton;
}
- (void)setTitleForNavBar
{
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tb-progress-3"]];
    [image setFrame:CGRectMake(-37, 0, 74, 17)];
    UIView *myView = [[UIView alloc] initWithFrame:self.navigationItem.titleView.frame];
    [myView addSubview:image];
    
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

- (void)skipAction
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self signInAction];
    
}

- (void)doneAction
{
//    [self performSegueWithIdentifier:@"RegisterTwo" sender:self];
    [self updateCreditCard];
}

- (void)updateCreditCard
{
    if (_myWebService2 == nil)
    {
        if (_cardNumberTextField.text.length < 16 || _expirationTextField.text.length < 5 || _secretTextField.text.length < 3)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Card number, expiration date or CVC incorrect." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            _myWebService2 = [[WebService alloc]init];
            _myWebService2.delegate = self;
            NSString *expMonth = [_expirationTextField.text substringToIndex:2];
            [expMonth stringByReplacingOccurrencesOfString:@"0" withString:@""];
            NSString *expYear = [NSString stringWithFormat:@"20%@",[_expirationTextField.text substringFromIndex:3]];
            [_myWebService2 updateCreditCardForUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] cardNumber:_cardNumberTextField.text expMonth:expMonth expYear:expYear cvcCode:_secretTextField.text];
        }
    }
}

- (void)signInAction
{
    if (_myWebService == nil) {
        _myWebService = [[WebService alloc]init];
        _myWebService.delegate = self;
        NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultUser"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        [_myWebService startActionSignInEmail:email password:password];
    }
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
    _myWebService2 = nil;
    
    if ([req isEqualToString:@"startActionSignInEmail"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[[webServiceResponse objectForKey:@"user"] objectForKey:@"userId"] forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] setObject:[[webServiceResponse objectForKey:@"app"] objectForKey:@"token"] forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:[[webServiceResponse objectForKey:@"app"] objectForKey:@"secret"] forKey:@"secret"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _myWebService = [[WebService alloc]init];
        _myWebService.delegate = self;
        [_myWebService getHomeForUserID:[[webServiceResponse objectForKey:@"user"] objectForKey:@"userId"] lat:nil lng:nil];
        
        
    }
    if ([req isEqualToString:@"getHomeForUserID"]) {
        _mainDictionary = webServiceResponse;
        
        [self performSegueWithIdentifier:@"registerMainSegue" sender:self];
        
    }
    if ([req isEqualToString:@"updateCreditCardForUserID"])
    {
        [self signInAction];
    }
    
}
//wrong login; temporary service unavailable; network failure
-(void) webServiceError:(NSString *)alertMessage forRequest:(NSString *)req;
{
    [_activityView stopAnimating];
    _myWebService = nil;
    _myWebService2 = nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"registerMainSegue"])
    {
        MainTableViewController *viewController = [segue destinationViewController];
        viewController.mainDictionary = _mainDictionary;
    }
}

-(void)dealloc
{
    _myWebService.delegate = nil;
    _myWebService2.delegate = nil;
}

@end