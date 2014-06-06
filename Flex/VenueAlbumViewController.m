//
//  VenueAlbumViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "VenueAlbumViewController.h"
#import "VenuePic.h"
#import "UIImageView+AFNetworking.h"

#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@interface VenueAlbumViewController ()

@property (assign) BOOL isFirstPage;
@property (assign) BOOL isLastPage;

@end

@implementation VenueAlbumViewController

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
    _isFirstPage = true;
    _leftAction.alpha = 0.0;
    _rightAction.alpha = 0.0;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPressed)];
    [_picturesScrollView addGestureRecognizer:tapGestureRecognizer];

    _myWebService = [[WebService alloc]init];
    _myWebService.delegate = self;
    [_myWebService listPicturesForVenueID:_venue.idVenue fromPage:@"" start:@"" pagesize:@"50"];
	// Do any additional setup after loading the view.
}

- (void)scrollViewPressed
{
    if (self.navigationController.navigationBar.alpha < 1) {
        CGFloat animationDuration = .5f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.navigationController.navigationBar.alpha = 1.0;
                             _leftAction.alpha = _isFirstPage? 0.0:1.0;
                             _rightAction.alpha =_isLastPage? 0.0:1.0;
                         } completion:^(BOOL finished) {                             
                         }];
    }
    else
    {
        CGFloat animationDuration = .5f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.navigationController.navigationBar.alpha = 0.0;
                             _leftAction.alpha = 0.0;
                             _rightAction.alpha = 0.0;
                         } completion:^(BOOL finished) {
                         }];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"tb-album"];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    _frameImageView.frame = CGRectMake(0, 0,320, ASSET_BY_SCREEN_HEIGHT(460,548));
    _frameImageView.image = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"screen-corners-mask-4", @"screen-corners-mask-5")];

    [self setBackButton];
    [self setRightButtons];
    [self setTitleForNavBar:_venue.nameVenue];
    
//    [self configureScrollView];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;

    UIImage *navBackgroundImage = [UIImage imageNamed:@"tb-square-corners"];
    
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Controls Configuration

- (UILabel*)configureLabel:(UILabel*)theLabel
{
    theLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:14.5];
    theLabel.textColor = [UIColor whiteColor];
    return theLabel;
}

- (void)setBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"tb-back-normal-album"]  ;
    UIImage *backBtnImagePressed = [UIImage imageNamed:@"tb-back-pressed-album"]  ;
    
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn setBackgroundImage:backBtnImagePressed forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 50, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}
- (void)setRightButtons
{
    UIButton *favouriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *favouriteBtnImage = [UIImage imageNamed:@"tb-star-normal"]  ;
    UIImage *favouriteBtnImagePressed = [UIImage imageNamed:@"tb-star-pressed-album"]  ;
    
    [favouriteBtn setBackgroundImage:favouriteBtnImage forState:UIControlStateNormal];
    [favouriteBtn setBackgroundImage:favouriteBtnImagePressed forState:UIControlStateHighlighted];
    
    [favouriteBtn addTarget:self action:@selector(favouriteAction:) forControlEvents:UIControlEventTouchUpInside];
    favouriteBtn.frame = CGRectMake(0, 0, 38, 37);
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *photoBtnImage = [UIImage imageNamed:@"tb-camera-normal"]  ;
    UIImage *photoBtnImagePressed = [UIImage imageNamed:@"tb-camera-pressed-album"]  ;
    
    [photoBtn setBackgroundImage:photoBtnImage forState:UIControlStateNormal];
    [photoBtn setBackgroundImage:photoBtnImagePressed forState:UIControlStateHighlighted];
    
    [photoBtn addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    photoBtn.frame = CGRectMake(42, 0, 38, 37);
    
    UIView *buttonsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 37)];
    [buttonsView addSubview:favouriteBtn];
    [buttonsView addSubview:photoBtn];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonsView];

//    UIBarButtonItem *favouriteButton = [[UIBarButtonItem alloc] initWithCustomView:favouriteBtn] ;
//    UIBarButtonItem *photoButton = [[UIBarButtonItem alloc] initWithCustomView:photoBtn] ;
//    
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:photoButton,favouriteButton, nil];
    //    self.navigationItem.rightBarButtonItem = nextButton;
}
- (void)setTitleForNavBar:(NSString*)title
{
    UIView *myView = [[UIView alloc] initWithFrame:self.navigationItem.titleView.frame];
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(-80, -8, 160, 17)];
    titleLable.font = [UIFont fontWithName:@"Capriola-Regular" size:12.5];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = title;
    [myView addSubview:titleLable];
    
    self.navigationItem.titleView = myView;
}
#pragma mark -
#pragma mark ScrollView Configuration

- (void)configureScrollView
{
    _picturesScrollView.frame = CGRectMake(0, 0,320, ASSET_BY_SCREEN_HEIGHT(460,548));


    _picturesScrollView.contentSize = CGSizeMake(_picturesScrollView.frame.size.width*[_pictureArray count], _picturesScrollView.frame.size.height);
    [_picturesScrollView setDelegate:self];
    
    for (int i = 0; i<=[_pictureArray count]-1; i++) {
        UIImageView *pictureView = [[UIImageView alloc]initWithFrame:CGRectMake(_picturesScrollView.frame.size.width*i, 0,_picturesScrollView.frame.size.width,_picturesScrollView.frame.size.height)];
        VenuePic *myPic = (VenuePic*)[_pictureArray objectAtIndex:i];
        [pictureView setImageWithURL:[NSURL URLWithString:myPic.venuePicURL] placeholderImage:[UIImage imageNamed:@"missing-photo-loading"]];
        pictureView.clipsToBounds = YES;
        pictureView.contentMode = UIViewContentModeScaleAspectFit;
        [_picturesScrollView addSubview:pictureView];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat animationDuration = .5f;

    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 2;
    if (page == 1 && !_isFirstPage) {
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             _leftAction.alpha = 0.0;
                         } completion:^(BOOL finished) {}];
    } else if (page == [_pictureArray count] && !_isLastPage) {
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             _rightAction.alpha = 0.0;
                         } completion:^(BOOL finished) {}];
    }
    if (page >1 && _leftAction.alpha == 0.0) {
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             _leftAction.alpha = 1.0;
                         } completion:^(BOOL finished) {}];
    }
    if (page <[_pictureArray count] && _rightAction.alpha == 0.0) {
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             _rightAction.alpha = 1.0;
                         } completion:^(BOOL finished) {}];
    }
    _isFirstPage = page == 1?true:false;
    _isLastPage = page == [_pictureArray count]?true:false;

}

#pragma mark -
#pragma mark Actions Methods

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)photoAction
{
    //    [self performSegueWithIdentifier:@"RegisterThree" sender:self];
    
}

- (void)favouriteAction:(id)sender
{
    UIButton *favButton = (UIButton*)sender;
#warning change this condition according to venue favourite or not
    if (favButton.tag == 0) {
        favButton.tag = 1;
        [favButton setBackgroundImage:[UIImage imageNamed:@"tb-star-selected-album"] forState:UIControlStateNormal];
    }
    else
    {
        favButton.tag = 0;
        [favButton setBackgroundImage:[UIImage imageNamed:@"tb-star-normal"] forState:UIControlStateNormal];
    }
}



- (IBAction)rightTouchAction:(id)sender {
    CGPoint contentOffset = _picturesScrollView.contentOffset;
    CGRect scrollFrame = _picturesScrollView.frame;
    CGRect nextRect = CGRectMake(contentOffset.x + scrollFrame.size.width, contentOffset.y, scrollFrame.size.width, scrollFrame.size.height);
    
    [_picturesScrollView scrollRectToVisible:nextRect animated:YES];
}

- (IBAction)leftTouchAction:(id)sender {
    CGPoint contentOffset = _picturesScrollView.contentOffset;
    CGRect scrollFrame = _picturesScrollView.frame;
    CGRect nextRect = CGRectMake(contentOffset.x - scrollFrame.size.width, contentOffset.y, scrollFrame.size.width, scrollFrame.size.height);
    
    [_picturesScrollView scrollRectToVisible:nextRect animated:YES];
}

#pragma mark -
#pragma mark myWebService Delegate Methods

-(void) webServiceConnecting:(NSString*)req;
{
    //activity indicator here?
}
-(void) webServiceResponded:(NSDictionary*)webServiceResponse forRequest:(NSString*)req;
{
    if ([[webServiceResponse objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
        NSArray *objectsArray = (NSArray*)[webServiceResponse objectForKey:@"data"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (id oneObject in objectsArray) {
            if ([oneObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *onePictureDict = (NSDictionary*)oneObject;
                VenuePic *onePic = [[VenuePic alloc]initWithDictionary:onePictureDict];
                [tempArray addObject:onePic];
            }
        }
        _pictureArray = [tempArray mutableCopy];
        if ([_pictureArray count]>1) {
            CGFloat animationDuration = .5f;
            [UIView animateWithDuration:animationDuration
                             animations:^{
                                 _rightAction.alpha = 1.0;
                             } completion:^(BOOL finished) {}];
        }
        [self configureScrollView];
    }
    
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
