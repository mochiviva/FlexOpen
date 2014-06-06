//
//  AppDelegate.m
//  Flex
//
//  Created by Mihai Olteanu on 4/4/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

//test
//test2

#import "AppDelegate.h"
#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    UIView *myView = [[UIView alloc]initWithFrame:self.window.frame];
    UIImage *myImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"bkg-4",@"bkg-5")];
    UIImageView *myImageView = [[UIImageView alloc]initWithImage:myImage];
    myImageView.frame = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height-20);
    [myView addSubview:myImageView];
    
    [self.window addSubview:myView];
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"tb-square-corners" ];
//    UIImage *navBackgroundImage = [UIImage imageNamed:@"tb-album" ];

    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage
                                       forBarMetrics:UIBarMetricsDefault];
    
    _appID = [[NSUserDefaults standardUserDefaults] objectForKey:@"appID"];
    //    _appID = Nil;
    //    NSLog(@"appid:%@", _appID);
    
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSString *deviceModel = [[UIDevice currentDevice] model];
    
    if (_appID) {
        _myWebService = [[WebService alloc]init];
        _myWebService.delegate = self;
        [_myWebService startActionDevRegister:@"ios" product:@"SGH-1977" model:deviceModel osversion:iOSVersion appversion:@"1" lat:@"43.6481" lng:@"-79.4042" uuid:nil];
//        [_myWebService startActionCreateUser:@"mihai@mochiviva.com" fullName:@"Mihai O" password:@"abc"];
    }
    else
    {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        CFStringRef identifier = CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
        NSString *uuidString = CFBridgingRelease(identifier);
        _appID = uuidString;
        _appID = [_appID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        _appID = [_appID lowercaseString];
        [[NSUserDefaults standardUserDefaults] setObject:_appID forKey:@"appID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _myWebService = [[WebService alloc]init];
        _myWebService.delegate = self;
        [_myWebService startActionDevRegister:@"ios" product:@"SGH-1977" model:deviceModel osversion:iOSVersion appversion:@"1" lat:@"43.6481" lng:@"-79.4042" uuid:nil];
    }
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"43.6481" forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults]setObject:@"-79.4042" forKey:@"longitude"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:_session];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [_session close];

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


@end
