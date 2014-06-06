//
//  ViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/4/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//
#import "AppDelegate.h"
#import "IntroViewController.h"
#import "IntroThreeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MainTableViewController.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"

#define ANIM_WIDTH 408
#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@interface IntroViewController ()
@property (assign) BOOL pageControlUsed;
@property (assign) NSUInteger page;
@property (assign) NSUInteger animationsNbr;


- (void)loadScrollViewWithPage:(int)page;
@end


@implementation IntroViewController


#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    _scrollView.alpha = 0;
    _pageControl.alpha = 0;
    
	// Do any additional setup after loading the view, typically from a nib.
    _cornersImage.image = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"screen-corners-mask-4", @"screen-corners-mask-5")];

	[self.scrollView setDelegate:self];
    
    UIViewController *pageZero = [self.storyboard instantiateViewControllerWithIdentifier:@"Present0"];
    [self addChildViewController:pageZero];
    
    UIViewController *pageOne = [self.storyboard instantiateViewControllerWithIdentifier:@"Present1"];
    [self addChildViewController:pageOne];
    
    UIViewController *pageTwo = [self.storyboard instantiateViewControllerWithIdentifier:@"Present2"];
	[self addChildViewController:pageTwo];
    
    IntroThreeViewController *pageThree = [self.storyboard instantiateViewControllerWithIdentifier:@"Present3"];
    pageThree.delegate = self;
	[self addChildViewController:pageThree];
    
    self.pageControl.currentPage = 0;
	_page = 0;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"password"] != nil)
    {
        [self autoSignIn];
    }else
    {
        [UIView animateWithDuration:.5 animations:^{_scrollView.alpha = 1;_pageControl.alpha = 1;}];
    }
    [self configureBackScroll];
    
    AppDelegate *appDelegate = ((AppDelegate*) [UIApplication sharedApplication].delegate);

    
}

- (void)configureBackScroll
{
    _backScrollView.contentSize = CGSizeMake(ANIM_WIDTH, _backScrollView.frame.size.height);
    CGRect imgFrame = _backScrollView.frame;
    _backScrollView.delegate = self;
    imgFrame.size.width = ANIM_WIDTH;
    
    UIImageView *animatedView = [[UIImageView alloc]initWithFrame:imgFrame];
    animatedView.image = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"bkg-iphone4.jpg", @"bkg-iphone5.jpg")];
    [_backScrollView addSubview:animatedView];
    
    
    [self scrollBackView];

}
- (void)scrollBackView
{
    if (_animationsNbr == 1) {
//        NSLog(@"a intrat in animation");
        CGPoint contentOffset = _backScrollView.contentOffset;
        
        CGRect scrollFrame = _backScrollView.frame;
        CGRect nextRect = CGRectMake(contentOffset.x + ANIM_WIDTH-2, contentOffset.y, scrollFrame.size.width, scrollFrame.size.height);
#warning se blocheaza aici cand sta mai mult idle
        
        [UIView animateWithDuration:15 animations:^(void){
            [_backScrollView scrollRectToVisible:nextRect animated:NO];
        }completion:^(BOOL finished){
            [UIView animateWithDuration:15 animations:^(void){
                [_backScrollView scrollRectToVisible:_backScrollView.frame animated:NO];
            }completion:^(BOOL finished){
                [self scrollBackView];
            }];
        }];

    }
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    _animationsNbr = 1;
    [self scrollBackView];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

	for (NSUInteger i =0; i < [self.childViewControllers count]; i++) {
		[self loadScrollViewWithPage:i];
	}
	
//	self.pageControl.currentPage = 0;
//	_page = 0;
	[self.pageControl setNumberOfPages:[self.childViewControllers count]];
	
	UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	if (viewController.view.superview != nil) {
		[viewController viewWillAppear:animated];
	}
	
	self.scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * [self.childViewControllers count], _scrollView.frame.size.height);
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultUser"] != nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * 3;
        frame.origin.y = 0;
        [_scrollView scrollRectToVisible:frame animated:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if ([self.childViewControllers count]) {
		UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
		if (viewController.view.superview != nil) {
			[viewController viewDidAppear:animated];
		}
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	if ([self.childViewControllers count]) {
		UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
		if (viewController.view.superview != nil) {
			[viewController viewWillDisappear:animated];
		}
	}
	[super viewWillDisappear:animated];
    [_animationTimer invalidate];
    [self.view.layer removeAllAnimations];
}

- (void)viewDidDisappear:(BOOL)animated {
	UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	if (viewController.view.superview != nil) {
		[viewController viewDidDisappear:animated];
	}
	[super viewDidDisappear:animated];
    _animationsNbr = 0;
    _pageControl.alpha = 1;
    _scrollView.alpha = 1;
    
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0)
        return;
    if (page >= [self.childViewControllers count])
        return;
    
	// replace the placeholder if necessary
    UIViewController *controller = [self.childViewControllers objectAtIndex:page];
    if (controller == nil) {
		return;
    }
	
	// add the controller's view to the scroll view
    if (controller.view.superview == nil) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
    }
}

- (void)previousPage {
	if (_page - 1 > 0) {
        
		// update the scroll view to the appropriate page
		CGRect frame = self.scrollView.frame;
		frame.origin.x = frame.size.width * (_page - 1);
		frame.origin.y = 0;
		
		UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
		UIViewController *newViewController = [self.childViewControllers objectAtIndex:_page - 1];
		[oldViewController viewWillDisappear:YES];
		[newViewController viewWillAppear:YES];
		
		[self.scrollView scrollRectToVisible:frame animated:YES];
		
		self.pageControl.currentPage = _page - 1;
		// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
		_pageControlUsed = YES;
	}
}

- (void)nextPage {
	if (_page + 1 > self.pageControl.numberOfPages) {
		
		// update the scroll view to the appropriate page
		CGRect frame = self.scrollView.frame;
		frame.origin.x = frame.size.width * (_page + 1);
		frame.origin.y = 0;
		
		UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
		UIViewController *newViewController = [self.childViewControllers objectAtIndex:_page + 1];
		[oldViewController viewWillDisappear:YES];
		[newViewController viewWillAppear:YES];
		
		[self.scrollView scrollRectToVisible:frame animated:YES];
		
		self.pageControl.currentPage = _page + 1;
		// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
		_pageControlUsed = YES;
	}
}

- (IBAction)changePage:(id)sender {
    int page = ((UIPageControl *)sender).currentPage;
	
	// update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
	UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
	UIViewController *newViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	[oldViewController viewWillDisappear:YES];
	[newViewController viewWillAppear:YES];
	
	[self.scrollView scrollRectToVisible:frame animated:YES];
	
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
	UIViewController *newViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	[oldViewController viewDidDisappear:YES];
	[newViewController viewDidAppear:YES];
	
	_page = self.pageControl.currentPage;
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	if (self.pageControl.currentPage != page) {
		UIViewController *oldViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
		UIViewController *newViewController = [self.childViewControllers objectAtIndex:page];
		[oldViewController viewWillDisappear:YES];
		[newViewController viewWillAppear:YES];
		self.pageControl.currentPage = page;
		[oldViewController viewDidDisappear:YES];
		[newViewController viewDidAppear:YES];
		_page = page;
	}
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

#pragma mark -
#pragma mark IntroThreeActionsDelegate methods

- (void)autoSignIn
{
    if (_myWebService == nil) {
        CGRect frm = self.view.frame;
        _activityViewHolder = [[UIImageView alloc]initWithFrame:CGRectMake(frm.size.width/2-39.5, frm.size.height/2-39.5, 79, 79)];
        _activityViewHolder.image = [UIImage imageNamed:@"spinner-bkg"];
        
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        _activityView.color = [UIColor whiteColor];
        _activityView.frame = CGRectMake(0, 0, 79, 79);
        [_activityViewHolder addSubview:_activityView];
        [self.view addSubview:_activityViewHolder];
        [_activityView startAnimating];

//        _activityView.frame = self.view.frame;
//        [self.view addSubview:_activityView];
        
        _myWebService = [[WebService alloc]init];
        _myWebService.delegate = self;
        [_myWebService startActionSignInEmail:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultUser"] password:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
    }
}

- (void)signInAction:(id)sender
{
    [self performSegueWithIdentifier:@"SignInSegue" sender:self];
}
- (void)registerAction:(id)sender
{
    [self performSegueWithIdentifier:@"RegisterSegue" sender:self];

}
- (void)signInFacebookAction:(id)sender
{
//    NSArray *permissions =
//    [NSArray arrayWithObjects:@"email", nil];
//here docs about the graph: https://developers.facebook.com/docs/reference/api/user/
    

    AppDelegate *appDelegate = ((AppDelegate*) [UIApplication sharedApplication].delegate);

    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                [self signInWithFacebookParameters];

            }];
        }
    }else
    {
        [self signInWithFacebookParameters];

    }

//    if (appDelegate.session.state != FBSessionStateCreated) {
//        // Create a new, logged out session.
//        appDelegate.session = [[FBSession alloc] init];
//    }
//    
//    // if the session isn't open, let's open it now and present the login UX to the user
//    [appDelegate.session openWithCompletionHandler:^(FBSession *session,
//                                                     FBSessionState status,
//                                                     NSError *error) {
//        // and here we make sure to update our UX according to the new session state
//        
//        [self signInWithFacebookParameters];
//    }];
//    [self signInWithFacebookParameters];



}
-(void)signInWithFacebookParameters
{
    AppDelegate *appDelegate = ((AppDelegate*) [UIApplication sharedApplication].delegate);
    [FBSession setActiveSession:appDelegate.session];

    if (appDelegate.session.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            if (!error) {
                _myWebService = nil;
                _myWebService = [[WebService alloc]init];
                _myWebService.delegate = self;
                [_myWebService logInWithFacebookID:user.id email:[user objectForKey:@"email"] fullName:user.name facebookUsername:user.username facebookUrl:user.link pictureUrl:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",user.id] locale:[user objectForKey:@"locale"] agerange:user.birthday gender:[user objectForKey:@"gender"] uuid:nil];
                
                
            } else
            {
                NSLog(@"eroarea este %@",error);
            }
        }];
    }
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
        NSLog(@"%@",[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
                                      appDelegate.session.accessTokenData.accessToken]);
        
        
    } else {
        NSLog(@"Login to create a link to fetch account data");
    }

}

-(void)signInGoogleAction:(id)sender
{
    
}

#pragma mark -
#pragma mark myWebService Delegate Methods

-(void) webServiceConnecting:(NSString*)req;
{
}
-(void) webServiceResponded:(NSDictionary*)webServiceResponse forRequest:(NSString*)req;
{
    _myWebService = nil;
    
    if ([req isEqualToString:@"startActionSignInEmail"]||[req isEqualToString:@"logInWithFacebookID"]) {
        _locationManager = [[CLLocationManager alloc]init];
        [_locationManager startUpdatingLocation];
        
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
        [_activityView stopAnimating];
        [_activityViewHolder removeFromSuperview];
        [self performSegueWithIdentifier:@"IntroMainSegue" sender:self];
        
    }
    
}
//wrong login; temporary service unavailable; network failure
-(void) webServiceError:(NSString *)alertMessage forRequest:(NSString *)req;
{
    [_activityView stopAnimating];
    [_activityViewHolder removeFromSuperview];

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
    if ([segue.identifier isEqualToString:@"IntroMainSegue"])
    {
        MainTableViewController *viewController = [segue destinationViewController];
        viewController.mainDictionary = _mainDictionary;
    }
}
-(void)dealloc
{
    _myWebService.delegate = nil;
}

@end
