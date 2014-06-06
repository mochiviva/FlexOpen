//
//  VenueDetailsView.m
//  Flex
//
//  Created by Mihai Olteanu on 4/24/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "VenueDetailsView.h"
//#define starsPosition 80

@interface VenueDetailsView ()

@property (assign) CGFloat categoryLabelWidth;
@property (assign) CGFloat starsPosition;
@property (assign) BOOL isFavorite;

@end

@implementation VenueDetailsView

- (id)initWithName:(NSString*)myName
          category:(NSString*)myCategory
          distance:(NSString*)myDistance
             stars:(double)myStars
          favorite:(BOOL)favorite
{
    self = [super initWithFrame:CGRectMake(0, 0, 250, 57)];
    if (self) {
        _venueName = myName;
        _venueCategory = myCategory;
        _venueDistance = myDistance;
        _venueStars = myStars;
        _isFavorite = favorite;
        if (favorite) {
            _starName = @"star-normal-fav";
        }else
        {
            _starName = @"star-normal";
        }
        [self configureLabels];
        [self configureStars];
        // Initialization code
    }
    return self;
}

-(void)configureLabels
{
    
    CGSize textSize = [_venueCategory sizeWithFont:[UIFont fontWithName:@"TheSans-B6SemiBold" size:13.5] constrainedToSize:CGSizeMake(80, 28) lineBreakMode:NSLineBreakByTruncatingTail];
    
    _categoryLabelWidth = MIN(80, textSize.width);
    _starsPosition = _categoryLabelWidth + 15 + 10;
    _venueNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 230, 28)];
    _venueCategoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 26, _categoryLabelWidth, 28)];
    _venueDistanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_categoryLabelWidth+20+84, 26, 85, 28)];

    _venueNameLabel.text = _venueName;
    _venueCategoryLabel.text = _venueCategory;
    _venueDistanceLabel.text = _venueDistance;
    
    _venueNameLabel.font = [UIFont fontWithName:@"Capriola-Regular" size:17.5];
    _venueNameLabel.textColor = [UIColor colorWithRed:99.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
    _venueNameLabel.backgroundColor = [UIColor clearColor];
    
    _venueCategoryLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:13.5];
    _venueCategoryLabel.textColor = _isFavorite?[UIColor colorWithRed:142.0/255.0 green:126.0/255.0 blue:65.0/255.0 alpha:1]:[UIColor colorWithRed:177.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:1];
    _venueCategoryLabel.backgroundColor = [UIColor clearColor];
    
    _venueDistanceLabel.font = [UIFont fontWithName:@"TheSans-B6SemiBold" size:13.5];
    _venueDistanceLabel.textColor = _isFavorite?[UIColor colorWithRed:142.0/255.0 green:126.0/255.0 blue:65.0/255.0 alpha:1]:[UIColor colorWithRed:177.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:1];
    _venueDistanceLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_venueNameLabel];
    [self addSubview:_venueCategoryLabel];
    [self addSubview:_venueDistanceLabel];

    
}

-(void)configureStars
{
    _starView1 = [[UIImageView alloc]initWithFrame:CGRectMake(_starsPosition, 34, 12, 12)];
    _starView2 = [[UIImageView alloc]initWithFrame:CGRectMake(_starsPosition+13, 34, 12, 12)];
    _starView3 = [[UIImageView alloc]initWithFrame:CGRectMake(_starsPosition+26, 34, 12, 12)];
    _starView4 = [[UIImageView alloc]initWithFrame:CGRectMake(_starsPosition+39, 34, 12, 12)];
    _starView5 = [[UIImageView alloc]initWithFrame:CGRectMake(_starsPosition+52, 34, 12, 12)];

    _starView1.image = [UIImage imageNamed:(_venueStars >=1)?@"star-selected":_starName];
    _starView2.image = [UIImage imageNamed:(_venueStars >=2)?@"star-selected":_starName];
    _starView3.image = [UIImage imageNamed:(_venueStars >=3)?@"star-selected":_starName];
    _starView4.image = [UIImage imageNamed:(_venueStars >=4)?@"star-selected":_starName];
    _starView5.image = [UIImage imageNamed:(_venueStars >=5)?@"star-selected":_starName];

    [self addSubview:_starView1];
    [self addSubview:_starView2];
    [self addSubview:_starView3];
    [self addSubview:_starView4];
    [self addSubview:_starView5];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
