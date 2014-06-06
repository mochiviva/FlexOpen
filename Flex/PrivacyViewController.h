//
//  PrivacyViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webViewOutlet;

@end
