//
//  EditProfileViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface EditProfileViewController : UIViewController<UITextFieldDelegate,WebServiceDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
- (IBAction)changePhotoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *memberPhotoOutlet;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@property (strong, nonatomic) WebService *myWebService;

@property (strong, nonatomic) WebService *myWebServiceHandle;
@property (strong, nonatomic) WebService *myWebServiceUpload;

@end
