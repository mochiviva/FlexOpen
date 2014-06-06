//
//  FlipStoryboardSegueBack.m
//  Flex
//
//  Created by Mihai Olteanu on 5/8/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//
#import "AppDelegate.h"
#import "FlipStoryboardSegueBack.h"

@implementation FlipStoryboardSegueBack

- (void)perform {
    AppDelegate* myDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
    
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    
    
    [UIView transitionWithView:myDelegate.window duration:0.7
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [src.navigationController popViewControllerAnimated:NO];
                    }
                    completion:NULL];
    
}

@end
