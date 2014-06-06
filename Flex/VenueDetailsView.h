//
//  VenueDetailsView.h
//  Flex
//
//  Created by Mihai Olteanu on 4/24/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueDetailsView : UIView

@property (strong,nonatomic) UILabel *venueNameLabel;
@property (strong,nonatomic) UILabel *venueCategoryLabel;
@property (strong,nonatomic) UILabel *venueDistanceLabel;
@property (strong,nonatomic) UIImageView *starView1;
@property (strong,nonatomic) UIImageView *starView2;
@property (strong,nonatomic) UIImageView *starView3;
@property (strong,nonatomic) UIImageView *starView4;
@property (strong,nonatomic) UIImageView *starView5;

@property (strong,nonatomic) NSString *venueName;
@property (strong,nonatomic) NSString *venueCategory;
@property (strong,nonatomic) NSString *venueDistance;

@property (nonatomic) double venueStars;

@property (strong,nonatomic) NSString *starName;


- (id)initWithName:(NSString*)myName
          category:(NSString*)myCategory
          distance:(NSString*)myDistance
             stars:(double)myStars
          favorite:(BOOL)favorite;
@end
