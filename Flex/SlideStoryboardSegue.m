//
//  SlideStoryboardSegue.m
//  Flex
//
//  Created by Mihai Olteanu on 5/22/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//
#import "AppDelegate.h"
#import "SlideStoryboardSegue.h"
#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@implementation SlideStoryboardSegue
- (void)perform {
    AppDelegate* myDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
    UIView *blackView = [[UIView alloc]initWithFrame:myDelegate.window.frame];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0;
    blackView.tag = 111;
    [myDelegate.window addSubview:blackView];
    [UIView animateWithDuration:.5 animations:^{
        blackView.alpha = .85;
    }completion:nil];
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    src.view.transform = CGAffineTransformMakeTranslation(0, 0);
    dst.view.transform = CGAffineTransformMakeTranslation(0, ASSET_BY_SCREEN_HEIGHT(-480, -568));
    
    [UIView animateWithDuration:.5
                     animations:^{
                         [myDelegate.window addSubview:dst.view];

                         dst.view.transform = CGAffineTransformMakeTranslation(0, 0);
                         
                     }
                     completion:^(BOOL finished){
                         [src addChildViewController:dst];
                     }
     ];

    
}

@end
