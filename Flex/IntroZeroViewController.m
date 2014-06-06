//
//  IntroZeroViewController.m
//  Flex
//
//  Created by Mihai Olteanu on 5/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "IntroZeroViewController.h"
#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)

@interface IntroZeroViewController ()

@end

@implementation IntroZeroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _presentImage.image = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"slide-14", @"slide-15")];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
