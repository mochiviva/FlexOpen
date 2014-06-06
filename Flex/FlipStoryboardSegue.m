//
//  FlipStoryboardSegue.m
//  Flex
//
//  Created by Mihai Olteanu on 5/8/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//
#import "AppDelegate.h"
#import "FlipStoryboardSegue.h"

@implementation FlipStoryboardSegue

- (void)perform {
    AppDelegate* myDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));

    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    [UIView transitionWithView:myDelegate.window duration:0.7
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];

}
	
@end
