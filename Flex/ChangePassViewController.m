//
//  ChangePassViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "ChangePassViewController.h"

@interface ChangePassViewController ()

@end

@implementation ChangePassViewController

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
    _myNewPassTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
    _currentPassTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
    _reEnterPassTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
	// Do any additional setup after loading the view.
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
    titleLable.text = @"Change Password";
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
    if ([_myNewPassTextField.text isEqualToString:_reEnterPassTextField.text])
    {
        if (_myWebService == nil)
        {
            _myWebService = [[WebService alloc]init];
            _myWebService.delegate = self;
            [_myWebService updatePasswordForUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] oldPassword:_currentPassTextField.text newPassword:_myNewPassTextField.text];
        }
    }
}
#pragma mark -
#pragma mark myWebService Delegate Methods

-(void) webServiceConnecting:(NSString*)req;
{
    if ([req isEqualToString:@"updatePasswordForUserID"]) {
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
    
    if ([req isEqualToString:@"updatePasswordForUserID"]) {
        [[NSUserDefaults standardUserDefaults] setObject:_myNewPassTextField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
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
