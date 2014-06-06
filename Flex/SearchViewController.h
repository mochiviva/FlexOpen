//
//  SearchViewController.h
//  Flex
//
//  Created by Mihai Olteanu on 4/10/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"
#import "Venue.h"

@protocol SearchDelegate

-(void)implementSearchDictionary:(NSDictionary*)searchDict andParams:(NSDictionary*)params;

@end

@interface SearchViewController : UITableViewController<WebServiceDelegate,UITextFieldDelegate>

@property (nonatomic, assign) id <SearchDelegate> delegate;

@property (strong, nonatomic) NSDictionary *mainDictionary;
@property (strong, nonatomic) NSArray *venuesArray;

@property (strong, nonatomic) NSDictionary *choicesDictionary;
@property (strong, nonatomic) NSArray *choicesArray;
@property (strong, nonatomic) UITextField *searchTextField;

@property (strong, nonatomic) WebService *myWebService;
@property (strong, nonatomic) WebService *myWebServiceForCells;

@property (strong, nonatomic) Venue *selectedVenue;

@property (strong, nonatomic) UIButton *searchButton;

@end
