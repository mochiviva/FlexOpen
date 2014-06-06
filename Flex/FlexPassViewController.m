//
//  FlexPassViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "FlexPassViewController.h"
#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@interface FlexPassViewController ()

@end

@implementation FlexPassViewController

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

- (void)loadMemberPhoto
{
    NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/memberPhoto.jpg"]];
    UIImage *photoImage = [UIImage imageWithContentsOfFile:jpgPath];
    _memberPhotoOutlet.image = photoImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    CGRect centerFrame = CGRectMake(_centerView.frame.origin.x, _centerView.frame.origin.y + ASSET_BY_SCREEN_HEIGHT(0, 44), _centerView.frame.size.width,_centerView.frame.size.height);
    _centerView.frame = centerFrame;
    _passOutlet.font = [UIFont fontWithName:@"Capriola-Regular" size:60];
    _askAttendantLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:13];
    _memberNameOutlet.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:18];
    _venueNameLabelOutlet.text = _venueName;
    _venueNameLabelOutlet.font = [UIFont fontWithName:@"Capriola-Regular" size:15];
    _lostCodeNoteLabelOutlet.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:15];
    _lostCodeTitleLabelOutlet.font = [UIFont fontWithName:@"Capriola-Regular" size:16];
    _callCenterButtonOutlet.titleLabel.font = [UIFont fontWithName:@"Capriola-Regular" size:14];
    
    
    _myWebService = [[WebService alloc] init];
    _myWebService.delegate = self;
    [_myWebService getUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
    _myWebService2 = [[WebService alloc] init];
    _myWebService2.delegate = self;
    [_myWebService2 startActionGetCodeForVenueID:_venueId];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"memberPhotoUrl"] isEqualToString:@""])
        [self loadMemberPhoto];
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

//- (void)goback
//{
////    [self.navigationController popViewControllerAnimated:YES];
////    [self performSegueWithIdentifier:@"homePassBackSegue" sender:self];
//    
//    [self.view removeFromSuperview];
//
//}

//- (void)nextAction
//{
//    [self performSegueWithIdentifier:@"RegisterThree" sender:self];
//    
//}


- (IBAction)dismissModal:(id)sender {
//    [self.view removeFromSuperview];
    if ([_fromVenue isEqualToString:@"yes"]) {
        [self performSegueWithIdentifier:@"venuePassBackSegue" sender:self];

    }
    else
    {
        [self performSegueWithIdentifier:@"homePassBackSegue" sender:self];

    }

//    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark myWebService Delegate Methods

-(void) webServiceConnecting:(NSString*)req;
{
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect titleRect = self.navigationItem.titleView.frame;
    CGRect activityFrame = CGRectMake(80, 0, titleRect.size.height, titleRect.size.height);
    _activityView.frame = activityFrame;
    
    [self.navigationItem.titleView addSubview:_activityView];
    [_activityView startAnimating];
}
-(void) webServiceResponded:(NSDictionary*)webServiceResponse forRequest:(NSString*)req;
{
    _myWebService = nil;
    [_activityView stopAnimating];
    if ([req isEqualToString:@"getUserID"])
    {
        _memberNameOutlet.text = [webServiceResponse objectForKey:@"fullName"];
    }
    if ([req isEqualToString:@"startActionGetCodeForVenueID"])
    {
        _passOutlet.text = [webServiceResponse objectForKey:@"passCode"];
    }
    
}
//wrong login; temporary service unavailable; network failure
-(void) webServiceError:(NSString *)alertMessage forRequest:(NSString *)req;
{
    [_activityView stopAnimating];
    _myWebService = nil;
    if ([req isEqualToString:@"startActionGetCodeForVenueID"])
    {
        _errorViewOutlet.hidden = NO;
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}
- (IBAction)callCenterButtonAction:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSString *number = [NSString stringWithFormat:@"%@", button.titleLabel.text];
    NSString *url = [NSString stringWithFormat:@"telprompt://%@", [number stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)dealloc
{
    _myWebService.delegate = nil;
    _myWebService2.delegate = nil;
}

@end
