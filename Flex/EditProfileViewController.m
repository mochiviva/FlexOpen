//
//  EditProfileViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "EditProfileViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CommonCrypto/CommonDigest.h>

@interface EditProfileViewController ()

@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (strong,nonatomic) UIImage *myImage;
@property (strong,nonatomic) NSURL *fileUrl;
@property (strong,nonatomic) NSData *myImageData;

@end

@implementation EditProfileViewController

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
    _memberPhotoOutlet.imageView.image = photoImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _nameTextField.font = [UIFont fontWithName:@"TheSans-B5Plain" size:17];
    _myWebService = [[WebService alloc]init];
    _myWebService.delegate = self;
    [_myWebService getUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]];
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
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(-50, -8, 100, 20)];
    titleLable.font = [UIFont fontWithName:@"Capriola-Regular" size:16.5];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = @"Edit Profile";
    [myView addSubview:titleLable];
    
    self.navigationItem.titleView = myView;
}

#pragma mark -
#pragma mark Actions Methods

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changePhotoAction:(id)sender
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

- (void)saveAction
{
    if (_myWebService == nil)
    {
        _myWebService = [[WebService alloc]init];
        _myWebService.delegate = self;
        [_myWebService updateUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] email:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultUser"] fullName:_nameTextField.text phoneNumber:nil pictureUrl:nil];
    }
}
#pragma mark - image Picker Controller
-(void) imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    _myImage = info[UIImagePickerControllerOriginalImage];
    
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
//    [_myWebServiceHandle updateUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] email:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultUser"] fullName:_nameTextField.text phoneNumber:nil pictureUrl:[NSString stringWithFormat:@"handle:%@",uniqueID]];

    [_myWebServiceHandle updateUserID:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] email:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultUser"] fullName:nil phoneNumber:nil pictureUrl:[NSString stringWithFormat:@"handle:%@",uniqueID]];

//    [_myWebServiceHandle uploadPictureForVenueID:_venue.idVenue pictureURL:[NSString stringWithFormat:@"handle:%@",uniqueID]];
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

#pragma mark -
#pragma mark myWebService Delegate Methods

-(void) webServiceConnecting:(NSString*)req;
{
    if ([req isEqualToString:@"updateUserID"]) {
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
    
    if ([req isEqualToString:@"getUserID"]) {
        _nameTextField.text = [webServiceResponse objectForKey:@"fullName"];
    }
    if ([req isEqualToString:@"updateUserID"]) {
        
        [self goback];
    }
    if ([req isEqualToString:@"uploadFile"])
    {
        NSLog(@"response for request %@ is %@",req,webServiceResponse);
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
