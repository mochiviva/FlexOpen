//
//  ChangeCCViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "ChangeCCViewController.h"

@interface ChangeCCViewController ()

@end

@implementation ChangeCCViewController

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

- (IBAction)cardNumberChangedAction:(id)sender {
    [self formatCreditCardNumber];
}

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
	// Do any additional setup after loading the view.
    _cardNumberTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
    _expirationTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
    _secretTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
    _cardNumberTitle.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:14];
    _expirationTitle.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:14];
    _secretTitle.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:14];
    _expirationTextField.delegate = self;
    _myWebService = [[WebService alloc]init];
    _myWebService.delegate = self;
    [_myWebService getCreditCardForUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    UIImage *backBtnImage = [UIImage imageNamed:@"tb-cancel-normal"]  ;
    UIImage *backBtnImagePressed = [UIImage imageNamed:@"tb-cancel-pressed"]  ;
    
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn setBackgroundImage:backBtnImagePressed forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 58, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}
- (void)setRightButton
{
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *saveBtnImage = [UIImage imageNamed:@"tb-save-normal"]  ;
    UIImage *saveBtnImagePressed = [UIImage imageNamed:@"tb-save-pressed"]  ;
    
    [saveBtn setBackgroundImage:saveBtnImage forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:saveBtnImagePressed forState:UIControlStateHighlighted];
    
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.frame = CGRectMake(0, 0, 57, 30);
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:saveBtn] ;
    self.navigationItem.rightBarButtonItem = saveButton;
}
- (void)setTitleForNavBar
{
    UIView *myView = [[UIView alloc] initWithFrame:self.navigationItem.titleView.frame];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(-80, -8, 160, 20)];
    titleLable.font = [UIFont fontWithName:@"Capriola-Regular" size:16.5];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = @"Payment Info";
    [myView addSubview:titleLable];
    
    self.navigationItem.titleView = myView;
}

#pragma mark -
#pragma mark Actions Methods

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction
{
    if (_myWebService == nil)
    {
        if (!(_cardNumberTextField.text.length == 16 || _cardNumberTextField.text.length == 19) || _expirationTextField.text.length < 5 || _secretTextField.text.length < 3)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Card number, expiration date or CVC incorrect." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            _myWebService = [[WebService alloc]init];
            _myWebService.delegate = self;
            NSString *expMonth = [_expirationTextField.text substringToIndex:2];
            [expMonth stringByReplacingOccurrencesOfString:@"0" withString:@""];
            NSString *expYear = [NSString stringWithFormat:@"20%@",[_expirationTextField.text substringFromIndex:3]];
            [_myWebService updateCreditCardForUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] cardNumber:[_cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] expMonth:expMonth expYear:expYear cvcCode:_secretTextField.text];
        }
    }
}

#pragma mark -
#pragma mark myWebService Delegate Methods

-(void) webServiceConnecting:(NSString*)req;
{
    if ([req isEqualToString:@"updateCreditCardForUserID"]) {
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
    
    if ([req isEqualToString:@"getCreditCardForUserID"]) {
        _cardNumberTextField.text = [webServiceResponse objectForKey:@"number"];
        _expirationTextField.text = [NSString stringWithFormat:@"%02d/%02d",[[webServiceResponse objectForKey:@"exp_month"] integerValue],[[webServiceResponse objectForKey:@"exp_year"] integerValue] % 100];
        if ([_expirationTextField.text isEqualToString:@"00/00"])
            _expirationTextField.text = nil;
    }
    if ([req isEqualToString:@"updateCreditCardForUserID"]) {
        
        [self goback];
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
