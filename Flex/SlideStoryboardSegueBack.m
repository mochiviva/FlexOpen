//
//  SlideStoryboardSegueBack.m
//  Flex
//
//  Created by Mihai Olteanu on 5/22/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//
#import "AppDelegate.h"
#import "SlideStoryboardSegueBack.h"
#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)


@implementation SlideStoryboardSegueBack
- (void)perform {
    AppDelegate* myDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));

    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIView *blackView = (UIView *)[myDelegate.window viewWithTag:111];
    
    [UIView animateWithDuration:.5 animations:^{
        blackView.alpha = 0;
    }completion:^(BOOL finished){
        [blackView removeFromSuperview];
    }];
    
    [UIView animateWithDuration:.5
                     animations:^{
                         src.view.transform = CGAffineTransformMakeTranslation(0, ASSET_BY_SCREEN_HEIGHT(480, 568));
                         
                     }
                     completion:^(BOOL finished){
                         [src removeFromParentViewController];
                     }];

    

}


@end
