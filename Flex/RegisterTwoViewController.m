//
//  RegisterTwoViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "RegisterTwoViewController.h"

@interface RegisterTwoViewController ()

@end

@implementation RegisterTwoViewController

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
    
    [self setBackButton];
    [self setRightButton];
    [self setTitleForNavBar];
    [self setFontForButtons];

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
    titleLable.font = [UIFont fontWithName:@"Capriola-Regular" size:12.5];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = @"Create Profile";
    [myView addSubview:titleLable];
    
    self.navigationItem.titleView = myView;
    
    _titleLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:14];
}
- (void)setFontForButtons
{
    NSArray *buttonsArray = @[_swimmingButton,_gymButton,_yogaButton,_dancingButton,_boxingButton,_mmaButton,_ptButton,_othersButton];
    for (UIButton* tempButton in buttonsArray) {
        tempButton.titleLabel.font = [UIFont fontWithName:@"Capriola-Regular" size:14];
    }
}

#pragma mark -
#pragma mark Actions Methods

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextAction
{
    [self performSegueWithIdentifier:@"RegisterThreeSegue" sender:self];
    
}

- (IBAction)swimmingAction:(id)sender {
    [self activityActionFor:sender withName:@"swimming"];
}

- (IBAction)gymAction:(id)sender {
    [self activityActionFor:sender withName:@"gym"];

}

- (IBAction)yogaAction:(id)sender {
    [self activityActionFor:sender withName:@"yoga"];

}

- (IBAction)dancingAction:(id)sender {
    [self activityActionFor:sender withName:@"dancing"];

}

- (IBAction)boxingAction:(id)sender {
    [self activityActionFor:sender withName:@"boxing"];
    UIButton *theButton = (UIButton*)sender;
    [theButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

}

- (IBAction)mmaAction:(id)sender {
    [self activityActionFor:sender withName:@"mma"];

}

- (IBAction)ptAction:(id)sender {
    [self activityActionFor:sender withName:@"pt"];

}

- (IBAction)othersAction:(id)sender {
    [self activityActionFor:sender withName:@"others"];

}

- (void)activityActionFor:(id)sender withName:(NSString*)name
{
    UIButton *theButton = (UIButton*)sender;
    if (theButton.tag != 1) {
        [theButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"pressed-%@",name]] forState:UIControlStateNormal];
         
//        theButton.highlighted = YES;
        [theButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        theButton.tag = 1;
    } else
    {
        [theButton setBackgroundImage:[UIImage imageNamed:@"button-normal"] forState:UIControlStateNormal];
//        theButton.highlighted = NO;
        [theButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        theButton.tag = 0;
    }

}

#pragma mark -
#pragma mark myWebService Delegate Methods

-(void) webServiceConnecting:(NSString*)req;
{
    //activity indicator here?
}
-(void) webServiceResponded:(NSDictionary*)webServiceResponse forRequest:(NSString*)req;
{
    
}
//wrong login; temporary service unavailable; network failure
-(void) webServiceError:(NSString *)alertMessage forRequest:(NSString *)req;
{
    _myWebService = nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)dealloc
{
    _myWebService.delegate = nil;
}

@end
