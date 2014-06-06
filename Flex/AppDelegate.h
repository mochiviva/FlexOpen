//
//  AppDelegate.h
//  Flex
//
//  Created by Mihai Olteanu on 4/4/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"
#import <FacebookSDK/FacebookSDK.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,WebServiceDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *appID;
@property (strong, nonatomic) WebService *myWebService;

@property (strong, nonatomic) FBSession *session;

@end
