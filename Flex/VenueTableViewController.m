//
//  VenueTableViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/29/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "VenueTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "VenuePic.h"
#import "VenueAndMeViewController.h"
#import "VenueClass.h"
#import "FlexPassViewController.h"
#import "VenueAlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CommonCrypto/CommonDigest.h>

#define PHOTOS_SECTION 0
#define VENUE_NAME_SECTION 1
#define CHECKIN_SECTION 2
#define MAP_SECTION 3
#define HOURS_SECTION 4
#define FACILITIES_SECTION 5
#define CLASSES_SECTION 6

@interface VenueTableViewController ()

@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (strong,nonatomic) UIButton *photoBtn;
@property (strong,nonatomic) UIImage *myImage;
@property (strong,nonatomic) NSURL *fileUrl;
@property (strong,nonatomic) NSData *myImageData;

@end

@implementation VenueTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark ViewController Methods

- (void)populateVenue
{
//    _venueIDDictionary = @{@"name":@"Bam Boo KungFoo",@"category":@"MMA Kung Foo",@"stars":@"3"};
    
//    _scheduleDictionary = @{@"Monday - Friday": @"15:00 - 16:00",@"Thursday": @"15:00 - 18:00",@"Wenesday": @"14:00 - 16:00",@"Thirdsday": @"14:00 - 16:00",@"Saturday": @"14:00 - 16:00",@"Sunday": @"14:00 - 16:00"};
//    _scheduleArray = [_scheduleDictionary allKeys];
    
//    _facilitiesDictionary = @{@"fac1":@"Showers",@"fac2":@"Pool",@"fac3":@"Lockers",@"fac4":@"Towels",@"fac5":@"Trainers"};
//    _facilitiesArray = [_facilitiesDictionary allValues];
    
//    NSDictionary *class1 = @{@"title":@"Belly Dancing",@"description":@"A lot of description here",@"schedule":@"Tue&Fri from 12:00 to 13:00"};
//    NSDictionary *class2 = @{@"title":@"Belly Dancing",@"description":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sed orci ipsum, at fermentum tortor. Etiam et ultricies urna. Integer eget lacinia lacus. Nullam pharetra lacinia accumsan. Curabitur id sagittis ligula. Nullam eget metus sit amet magna faucibus molestie. Duis sagittis dictum quam, viverra imperdiet arcu venenatis vitae. In sed euismod metus. Pellentesque ac lorem odio.",@"schedule":@"Tue&Fri from 12:00 to 13:00"};
//    NSDictionary *class3 = @{@"title":@"Belly Dancing",@"description":@"A lot of description here",@"schedule":@"Tue&Fri from 12:00 to 13:00"};
//
//    _classesArray = @[class1,class2,class3];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateVenue];
    
    _myWebService = [[WebService alloc]init];
    _myWebService.delegate = self;
    [_myWebService detailsForVenueID:_venue.idVenue];

        
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitleForNavBar:@""];

    [self setBackButton];
    [self setRightButtons];
    
    if ([_venue.isFavoriteVenue isEqualToString:@"1"]) {
        [_favouriteBtn setBackgroundImage:[UIImage imageNamed:@"tb-star-selected"] forState:UIControlStateNormal];
    }



//    [self setTitleForNavBar:@"Bamboo Kung Foo"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self setTitleForNavBar:@"BamBoo Kung Foo"];
    [self setTitleForNavBar:_venue.nameVenue];

    self.navigationItem.titleView.alpha = 0;
    

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
    UIImage *backBtnImage = [UIImage imageNamed:@"tb-back-normal"]  ;
    UIImage *backBtnImagePressed = [UIImage imageNamed:@"tb-back-pressed"]  ;
    
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn setBackgroundImage:backBtnImagePressed forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 50, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}
- (void)setRightButtons
{
    _favouriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *favouriteBtnImage = [UIImage imageNamed:@"tb-star-normal"]  ;
    UIImage *favouriteBtnImagePressed = [UIImage imageNamed:@"tb-star-pressed"]  ;
    
    [_favouriteBtn setBackgroundImage:favouriteBtnImage forState:UIControlStateNormal];
    [_favouriteBtn setBackgroundImage:favouriteBtnImagePressed forState:UIControlStateHighlighted];
    
    [_favouriteBtn addTarget:self action:@selector(favouriteAction:) forControlEvents:UIControlEventTouchUpInside];
    _favouriteBtn.frame = CGRectMake(0, 0, 38, 37);
    
    _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *photoBtnImage = [UIImage imageNamed:@"tb-camera-normal"]  ;
    UIImage *photoBtnImagePressed = [UIImage imageNamed:@"tb-camera-pressed"]  ;
    
    [_photoBtn setBackgroundImage:photoBtnImage forState:UIControlStateNormal];
    [_photoBtn setBackgroundImage:photoBtnImagePressed forState:UIControlStateHighlighted];
    
    [_photoBtn addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    _photoBtn.frame = CGRectMake(42, 0, 38, 37);
    
    UIView *buttonsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 37)];
    [buttonsView addSubview:_favouriteBtn];
    [buttonsView addSubview:_photoBtn];
    
//    UIBarButtonItem *favouriteButton = [[UIBarButtonItem alloc] initWithCustomView:favouriteBtn] ;
//    UIBarButtonItem *photoButton = [[UIBarButtonItem alloc] initWithCustomView:photoBtn] ;
    
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:photoButton,favouriteButton, nil];
//    self.navigationItem.rightBarButtonItem = nextButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonsView];

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
#pragma mark Actions Methods

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)photoAction
{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose from Library", nil];
    [myActionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.delegate = (id)self;
        [self presentViewController:_imagePicker animated:YES completion:nil];
        
    }
    else if (buttonIndex == 1) {
        
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.delegate = (id)self;
        _imagePicker.navigationBar.translucent = YES;

    
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
    
    
    
    
}

- (void)favouriteAction:(id)sender
{
#warning change this condition according to venue favourite or not
    if (![_venue.isFavoriteVenue isEqualToString:@"1"]) {
        _myWebService = [[WebService alloc] init];
        _myWebService.delegate = self;
        [_myWebService favoriteVenueID:_venue.idVenue favoriteTrueOrFalse:@"true"];
    }
    else
    {
        _myWebService = [[WebService alloc] init];
        _myWebService.delegate = self;
        [_myWebService favoriteVenueID:_venue.idVenue favoriteTrueOrFalse:@"false"];
    }
}

- (void)passAction
{
    
    [self performSegueWithIdentifier:@"venuePassSegue" sender:self];
    
}

- (void)venueMapAction
{
    [self performSegueWithIdentifier:@"venueMapSegue" sender:self];
    
}

- (void)venueAlbumAction
{
    if ([_venue.venuePics count] >= 1)
        [self performSegueWithIdentifier:@"venueAlbumSegue" sender:self];
}
#pragma mark - image Picker Controller
-(void) imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    _myImage = info[UIImagePickerControllerOriginalImage];
//    _fileUrl = info[UIImagePickerControllerReferenceURL];
//    UIImage *portraitImage = [[UIImage alloc] initWithCGImage: _myImage.CGImage
//                                                        scale: 1.0
//                                                  orientation: UIImageOrientationRight];
    
//    _myImageData = UIImagePNGRepresentation(info[UIImagePickerControllerOriginalImage]);
    _myImageData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 1);

    [picker dismissViewControllerAnimated:YES completion:^{
        [self sendImageToServer];
    }];


}


-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendImageToServer
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef identifier = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    NSString *uniqueID = CFBridgingRelease(identifier);
    
    _myWebServiceHandle = [[WebService alloc]init];
    [_myWebServiceHandle uploadPictureForVenueID:_venue.idVenue pictureURL:[NSString stringWithFormat:@"handle:%@",uniqueID]];
    _myWebServiceUpload = [[WebService alloc]init];
//    _myWebServiceUpload.delegate = self;
#warning de extras numele imaginii;
    [_myWebServiceUpload uploadFile:_myImageData forUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] name:uniqueID md5sum:nil handle:[NSString stringWithFormat:@"%@",uniqueID]];
    
}

- (NSString*)makemd5sumForImg:(UIImage*)image
{
    unsigned char result[16];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(_myImage)];
    CC_MD5([imageData bytes], [imageData length], result);
    NSString *imageHash = [NSString stringWithFormat:
                           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return imageHash;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //venue-title-bkg.png
    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectNull];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    backView.image = [UIImage imageNamed:@"venue-title-bkg"];
//    backView.alpha = 0.8;
    [sectionHeader addSubview:backView];

    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
    sectionLabel.backgroundColor = [UIColor clearColor];
    sectionLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:14.5];
    sectionLabel.textColor = [UIColor colorWithRed:99.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
    [sectionHeader addSubview:sectionLabel];
    switch(section) {
        
        case HOURS_SECTION:
            sectionLabel.text = @"Hours";
            return sectionHeader;

        case FACILITIES_SECTION:
            sectionLabel.text = @"Facilities";
            sectionLabel.frame = CGRectMake(20, 13, 100, 20);
            return sectionHeader;

        case CLASSES_SECTION:
            sectionLabel.text = @"Classes";
            return sectionHeader;

        default:
            return nil;

            break;
    }

//    return sectionHeader;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch(section) {
        case PHOTOS_SECTION:
            return 0;
        case VENUE_NAME_SECTION:
            return 0;
        case CHECKIN_SECTION:
            return 0;
        case MAP_SECTION:
            return 0;
        case HOURS_SECTION:
        {
            if ([_venue.venueSchedule count]>=1) {
                return 30;

            }
            else{
                return 0;
            }
        }
        case FACILITIES_SECTION:
        {
            if ([_facilitiesArray count]>=1) {
                return 30;
                
            }
            else{
                return 0;
            }
        }
        case CLASSES_SECTION:
            if ([_classesArray count]>=1) {
                return 30;
                
            }
            else{
                return 0;
            }
        default:
            return 0;
    }

}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString *title = nil;
//    switch(section) {
//        case PHOTOS_SECTION:
//            title = nil;
//        case VENUE_NAME_SECTION:
//            title = nil;
//        case CHECKIN_SECTION:
//            title = nil;
//        case MAP_SECTION:
//            title = nil;
//        case HOURS_SECTION:
//            title = @"Hours";
//        case FACILITIES_SECTION:
//            title = @"Facilities";
//        case CLASSES_SECTION:
//            title = @"Classes";
//        default:
//            break;
//    }
//
//    
//    return title;;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section) {
        case PHOTOS_SECTION:
            return 1;
        case VENUE_NAME_SECTION:
            return 1;
        case CHECKIN_SECTION:
            return 1;
        case MAP_SECTION:
            return 1;
        case HOURS_SECTION:
            return [_venue.venueSchedule count];
        case FACILITIES_SECTION:
            return round(([_facilitiesArray count]+1)/2);
        case CLASSES_SECTION:
            return [_classesArray count];
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section) {
        case PHOTOS_SECTION:
            return 156;
        case VENUE_NAME_SECTION:
            return 76;
        case CHECKIN_SECTION:
            return 74;
        case MAP_SECTION:
            return 115;
        case HOURS_SECTION:
            return 44;
        case FACILITIES_SECTION:
            return 50;
        case CLASSES_SECTION:
        {
            VenueClass *class = (VenueClass*)[_classesArray objectAtIndex:indexPath.row];
//            NSString *textString = [classDict objectForKey:@"description"];
            NSString *textString = class.descriptionClass;

            CGSize textSize = [textString sizeWithFont:[UIFont fontWithName:@"TheSans-B5Plain" size:
                                                        12.0] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail];
            CGFloat heightDiff = textSize.height;
            
            NSString *scheduleString = @"";
            CGFloat scheduleHeight = 0;

            for (NSString *key in class.scheduleClass) {
                scheduleString = [NSString stringWithFormat:@"%@ %@",key,[class.scheduleClass objectForKey:key]];
            }
            //remove or show schedule:
            if (![scheduleString isEqualToString:@""])
            {
                scheduleHeight = 34;
            }
            
            return MAX(56+scheduleHeight , 56+scheduleHeight+heightDiff ) ;
            
            

        }
        default:
            return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == PHOTOS_SECTION) {
        static NSString *CellIdentifier = @"venuePhotosCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
        }
        UIScrollView *albumScrollView = (UIScrollView*)[cell viewWithTag:1];
        UIPageControl *albumPageControl = (UIPageControl*)[cell viewWithTag:2];
        _picturesScrollView = albumScrollView;
        _picturesScrollView.delegate = self;
        _pageControlForPictures = albumPageControl;
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(venueAlbumAction)];
        [albumScrollView addGestureRecognizer:singleFingerTap];
        
#warning the code that follows should be moved into a separate method or class with pictures loading from server
        
        albumScrollView.contentSize = CGSizeMake(albumScrollView.frame.size.width*[_venue.venuePics count], albumScrollView.frame.size.height);
        albumScrollView.pagingEnabled = YES;
        albumScrollView.showsHorizontalScrollIndicator = NO;
        [albumScrollView setDelegate:self];
        if ([_venue.venuePics count]>=1) {
            [albumPageControl setNumberOfPages:[_venue.venuePics count]==1?0:[_venue.venuePics count]];
            for (int i = 0; i<=[_venue.venuePics count]-1; i++) {
                UIImageView *pictureView = [[UIImageView alloc]initWithFrame:CGRectMake(albumScrollView.frame.size.width*i, 0,albumScrollView.frame.size.width,albumScrollView.frame.size.height)];
                VenuePic *myPic = (VenuePic*)[_venue.venuePics objectAtIndex:i];
                [pictureView setImageWithURL:[NSURL URLWithString:myPic.venuePicURL] placeholderImage:[UIImage imageNamed:@"missing-photo-loading"]];

                pictureView.clipsToBounds = YES;
                pictureView.contentMode = UIViewContentModeScaleAspectFill;
                [albumScrollView addSubview:pictureView];
                
            }

        } else
        {
            [albumPageControl setNumberOfPages:0];

            albumScrollView.contentSize = CGSizeMake(albumScrollView.frame.size.width, albumScrollView.frame.size.height);
            albumScrollView.pagingEnabled = YES;
            albumScrollView.showsHorizontalScrollIndicator = NO;
            [albumScrollView setDelegate:self];

            for (int i = 0; i<=0; i++) {
//                UIImage *pictureImage = [UIImage imageNamed:[NSString stringWithFormat:@"imgFlex%d.jpg",i+1]];
                UIImage *pictureImage = [UIImage imageNamed:@"missing-photo"];

                UIImageView *pictureView = [[UIImageView alloc]initWithFrame:CGRectMake(albumScrollView.frame.size.width*i, 0,albumScrollView.frame.size.width,albumScrollView.frame.size.height)];
                pictureView.image = pictureImage;
                pictureView.clipsToBounds = YES;
                pictureView.contentMode = UIViewContentModeScaleAspectFill;
                [albumScrollView addSubview:pictureView];
                
                
            }
        }
        

    }
    if (indexPath.section == VENUE_NAME_SECTION) {
        static NSString *CellIdentifier = @"venueNameCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            //            [[NSBundle mainBundle] loadNibNamed:@"venuePhotosCell" owner:self options:nil];
            //            cell = myAddNameCell;
        }
        UILabel *labelOne = (UILabel*)[cell viewWithTag:11];
        UILabel *labelTwo = (UILabel*)[cell viewWithTag:12];
        
        UIImageView *star1 = (UIImageView*)[cell viewWithTag:1];
        UIImageView *star2 = (UIImageView*)[cell viewWithTag:2];
        UIImageView *star3 = (UIImageView*)[cell viewWithTag:3];
        UIImageView *star4 = (UIImageView*)[cell viewWithTag:4];
        UIImageView *star5 = (UIImageView*)[cell viewWithTag:5];
        
//        NSString *stars = [_venueIDDictionary objectForKey:@"stars"];
        NSString *stars = _venue.ratingVenue;

        double starsNumber = [stars doubleValue];
        
        star1.image = [UIImage imageNamed:(starsNumber>=1)?@"star-selected":@"star-normal-gym"];
        star2.image = [UIImage imageNamed:(starsNumber>=2)?@"star-selected":@"star-normal-gym"];
        star3.image = [UIImage imageNamed:(starsNumber>=3)?@"star-selected":@"star-normal-gym"];
        star4.image = [UIImage imageNamed:(starsNumber>=4)?@"star-selected":@"star-normal-gym"];
        star5.image = [UIImage imageNamed:(starsNumber>=5)?@"star-selected":@"star-normal-gym"];
        
//        star1.image = [UIImage imageNamed:(starsNumber>=1)?@"star-normal-fav":@"star-normal"];
//        star2.image = [UIImage imageNamed:(starsNumber>=2)?@"star-normal-fav":@"star-normal"];
//        star3.image = [UIImage imageNamed:(starsNumber>=3)?@"star-normal-fav":@"star-normal"];
//        star4.image = [UIImage imageNamed:(starsNumber>=4)?@"star-normal-fav":@"star-normal"];
//        star5.image = [UIImage imageNamed:(starsNumber>=5)?@"star-normal-fav":@"star-normal"];

        labelOne.font = [UIFont fontWithName:@"Capriola-Regular" size:19.0];
        labelOne.textColor = [UIColor colorWithRed:99.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
        
        labelTwo.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:14.5];
        labelTwo.textColor = [UIColor colorWithRed:99.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
        
//        labelOne.text = [_venueIDDictionary objectForKey:@"name"];
//        labelTwo.text = [_venueIDDictionary objectForKey:@"category"];
        labelOne.text = _venue.nameVenue;
        labelTwo.text = _venue.categoryVenue;

        
    }
    if (indexPath.section == CHECKIN_SECTION) {
        static NSString *CellIdentifier = @"venueCheckinCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            //            [[NSBundle mainBundle] loadNibNamed:@"venuePhotosCell" owner:self options:nil];
            //            cell = myAddNameCell;
        }
        UIButton *theButton = (UIButton*)[cell viewWithTag:1];
        [theButton addTarget:self action:@selector(passAction) forControlEvents:UIControlEventTouchUpInside];


    }
    if (indexPath.section == MAP_SECTION) {
        static NSString *CellIdentifier = @"venueMapCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        _venuesMapView = (MKMapView*)[cell viewWithTag:1];
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(venueMapAction)];
        [_venuesMapView addGestureRecognizer:singleFingerTap];
        _venuesMapView.delegate = self;
        MKCoordinateRegion region = MKCoordinateRegionMake(_venue.coordinate, MKCoordinateSpanMake(0.005, 0.005));
        [_venuesMapView setRegion:region animated:YES];
//        [_venuesMapView setCenterCoordinate:_venue.coordinate];
        [_venuesMapView addAnnotation:_venue];

        if (cell == nil) {
            //            [[NSBundle mainBundle] loadNibNamed:@"venuePhotosCell" owner:self options:nil];
            //            cell = myAddNameCell;
        }
        UILabel *addressLabel = (UILabel*)[cell viewWithTag:2];
        addressLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:13.0];
        addressLabel.textColor = [UIColor colorWithRed:99.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
//        addressLabel.text = @"101 Queen Street East, Suite 101";
        addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",_venue.zipVenue,_venue.cityVenue,_venue.line1Venue,_venue.line2Venue];

        
    }
    
    if (indexPath.section == HOURS_SECTION) {
        static NSString *CellIdentifier;
        if ([_scheduleArray count] == 1) {
            CellIdentifier = @"venueHoursSingleCell";
        } else if (indexPath.row == 0)
        {
            CellIdentifier = @"venueHoursTopCell";

        } else if (indexPath.row == [_scheduleArray count]-1)
        {
            CellIdentifier = @"venueHoursBottomCell";

        }
        else
        {
            CellIdentifier = @"venueHoursCell";

        }
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            //            [[NSBundle mainBundle] loadNibNamed:@"venuePhotosCell" owner:self options:nil];
            //            cell = myAddNameCell;
        }
        UILabel *firstLabel = (UILabel*)[cell viewWithTag:1];
        UILabel *secondLabel = (UILabel*)[cell viewWithTag:2];
        
        firstLabel = [self configureLabel:firstLabel];
        secondLabel = [self configureLabel:secondLabel];

        firstLabel.text = [_scheduleArray objectAtIndex:indexPath.row];
        secondLabel.text = [[[_scheduleDictionary objectForKey:[_scheduleArray objectAtIndex:indexPath.row]] valueForKey:@"description"] componentsJoinedByString:@" "];
        
    }
    if (indexPath.section == FACILITIES_SECTION) {
        static NSString *CellIdentifier = @"venueFacilitiesCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            //            [[NSBundle mainBundle] loadNibNamed:@"venuePhotosCell" owner:self options:nil];
            //            cell = myAddNameCell;
        }
        UILabel *labelOne = (UILabel*)[cell viewWithTag:5];
        UILabel *labelTwo = (UILabel*)[cell viewWithTag:6];
        labelOne = [self configureLabel:labelOne];
        labelTwo = [self configureLabel:labelTwo];

        NSDictionary *facDict = [_facilitiesArray objectAtIndex:indexPath.row*2] != [NSNull null]?[_facilitiesArray objectAtIndex:indexPath.row*2]:[NSDictionary dictionary];
        labelOne.text = [facDict objectForKey:@"key"];
        if (indexPath.row*2+1<[_facilitiesArray count]) {
             NSDictionary *facDict2 = [_facilitiesArray objectAtIndex:indexPath.row*2+1] != [NSNull null]?[_facilitiesArray objectAtIndex:indexPath.row*2+1]:[NSDictionary dictionary];
            labelTwo.text = [facDict2 objectForKey:@"key"];

        } else
        {
            UIView *hideView = (UIView*)[cell viewWithTag:2];
            hideView.hidden = YES;
        }

    }
    if (indexPath.section == CLASSES_SECTION) {
        static NSString *CellIdentifier;

        VenueClass *class = (VenueClass*)[_classesArray objectAtIndex:indexPath.row];

        NSString *scheduleString = @"";
        for (NSString *key in class.scheduleClass) {
            scheduleString = [NSString stringWithFormat:@"%@ %@ %@ ",scheduleString,key,[class.scheduleClass objectForKey:key]];
        }
        //remove or show schedule:
        if ([scheduleString isEqualToString:@""]) {
            CellIdentifier = @"venueClassesNoScheduleCell";

            
        }else
        {
            CellIdentifier = @"venueClassesCell";

        }

        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            //            [[NSBundle mainBundle] loadNibNamed:@"venuePhotosCell" owner:self options:nil];
            //            cell = myAddNameCell;
        }
        UILabel *labelOne = (UILabel*)[cell viewWithTag:1];
        UILabel *labelTwo = (UILabel*)[cell viewWithTag:2];
        labelOne.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:15.5];
        labelOne.textColor = [UIColor whiteColor];
        
        labelTwo.font = [UIFont fontWithName:@"TheSans-B5Plain" size:12.0];
        labelTwo.textColor = [UIColor whiteColor];
        
        
        
//        labelOne.text = [classDict objectForKey:@"title"];
//        labelTwo.text = [classDict objectForKey:@"description"];
//        labelThree.text = [classDict objectForKey:@"schedule"];
        labelOne.text = class.titleClass;
        labelTwo.text = class.descriptionClass;
//        for (NSString *key in class.scheduleClass) {
//            scheduleString = [NSString stringWithFormat:@"%@ %@ %@ ",scheduleString,key,[class.scheduleClass objectForKey:key]];
//        }
        //remove or show schedule:
        if (![scheduleString isEqualToString:@""]) {
            UILabel *labelThree = (UILabel*)[cell viewWithTag:3];
            labelThree.font = [UIFont fontWithName:@"TheSans-B5Plain" size:12.0];
            labelThree.textColor = [UIColor whiteColor];
            labelThree.text = scheduleString;
            
        }    
        

    }
    
 //    static NSString *CellIdentifier = @"venueNameCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _picturesScrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if (_pageControlForPictures.currentPage != page) {
            _pageControlForPictures.currentPage = page;
            
        }

    }else
    {
#warning condition so to not setTitle at all scrolls and to set bounce at a smaller distance scroll

        if (scrollView.contentOffset.y > 150) {
            //        [self setTitleForNavBar:@"BamBoo Kung Foo"];
            CGFloat animationDuration = .5f;
            [UIView animateWithDuration:animationDuration
                             animations:^{
                                 self.navigationItem.titleView.alpha = 1.0;
                             } completion:^(BOOL finished) {
                                 //                         self.navigationItem.titleView.alpha = 1.0;
                                 
                             }];
//            self.tableView.bounces = YES;
        }
        
        if (scrollView.contentOffset.y < 150) {
            CGFloat animationDuration = .5f;
            [UIView animateWithDuration:animationDuration
                             animations:^{
                                 self.navigationItem.titleView.alpha = 0.0;
                             } completion:^(BOOL finished) {
                                 //                         self.navigationItem.titleView.alpha = 1.0;
                                 
                             }];
            //        [self setTitleForNavBar:@""];
            
//            self.tableView.bounces = NO;
            
        }

    }
        
//    NSLog(@"did");
}
#pragma mark -
#pragma mark Map Methods

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[_venuesMapView dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
    Venue *theAnnotation = (Venue*)annotation;
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier];
    }
    
    annotationView.image = [UIImage imageNamed:theAnnotation.iconName];
    
    //    [annotationView setImage:[UIImage imageNamed:@"mma-favorite"]];
    annotationView.frame = CGRectMake(0, 0, 30, 35);
    annotationView.annotation = annotation;
    
    //    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"venueMapSegue"])
    {
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        VenueAndMeViewController *viewController = (VenueAndMeViewController *)[navController topViewController];
//        VenueAndMeViewController *viewController = [segue destinationViewController];
        viewController.venue = _venue;
    }
    if ([[segue identifier] isEqualToString:@"venuePassSegue"])
    {
        FlexPassViewController *viewController = [segue destinationViewController];
        viewController.fromVenue = @"yes";
        viewController.venueId = _venue.idVenue;
        viewController.venueName = _venue.nameVenue;
    }
    if ([[segue identifier] isEqualToString:@"venueAlbumSegue"])
    {
        VenueAlbumViewController *viewController = [segue destinationViewController];
        viewController.venue = _venue;
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
    _myWebService = nil;
    if ([req isEqualToString:@"detailsForVenueID"])
    {
        _venue = nil;
        _venue = [[Venue alloc]initForDetailsWithDictionary:webServiceResponse];
        _scheduleArray = [_venue.venueSchedule allKeys];
        _scheduleDictionary = _venue.venueSchedule;
        _facilitiesArray = _venue.venueFacilities;
        _classesArray = _venue.venueClasses;
        
        [self.tableView reloadData];
    }
    if ([req isEqualToString:@"favoriteVenueID"])
    {
        if ([_venue.isFavoriteVenue isEqualToString:@"1"]) {
            [_favouriteBtn setBackgroundImage:[UIImage imageNamed:@"tb-star-normal"] forState:UIControlStateNormal];
            _venue.isFavoriteVenue = @"0";
        }else
        {
            [_favouriteBtn setBackgroundImage:[UIImage imageNamed:@"tb-star-selected"] forState:UIControlStateNormal];
            _venue.isFavoriteVenue = @"1";

        }

    }
    if ([req isEqualToString:@"uploadFile"])
    {
        NSLog(@"response for request %@ is %@",req,webServiceResponse);
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
