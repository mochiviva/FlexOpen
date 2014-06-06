//
//  SearchStoryboardSegueBack.m
//  Flex
//
//  Created by Mihai Olteanu on 5/22/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//
#import "AppDelegate.h"
#import "SearchStoryboardSegueBack.h"
#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)


@implementation SearchStoryboardSegueBack
- (void)perform {
    AppDelegate* myDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
    
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    

    [UIView transitionWithView:myDelegate.window duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [src.navigationController popViewControllerAnimated:NO];
                    }
                    completion:NULL];
    
}


@end
