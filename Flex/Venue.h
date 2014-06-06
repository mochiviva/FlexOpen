//
//  Venue.h
//  Flex
//
//  Created by Mihai Olteanu on 5/16/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Venue : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *idVenue;
@property (strong, nonatomic) NSString *slugVenue;
@property (strong, nonatomic) NSString *nameVenue;
@property (strong, nonatomic) NSString *urlVenue;
@property (strong, nonatomic) NSString *ratingVenue;

@property (strong, nonatomic) NSArray *venueCategories;

@property (strong, nonatomic) NSString *categoryVenue;
@property (strong, nonatomic) NSString *isFavoriteVenue;
@property (strong, nonatomic) NSString *phoneVenue;

@property (strong, nonatomic) NSDictionary *venueAddress;
@property (strong, nonatomic) NSDictionary *venueAvatar;
@property (strong, nonatomic) NSArray *venuePics;
@property (strong, nonatomic) NSDictionary *venueSchedule;
@property (strong, nonatomic) NSArray *venueFacilities;
@property (strong, nonatomic) NSArray *venueClasses;

@property (strong, nonatomic) NSString *distanceVenue;

@property (strong, nonatomic) NSString *iconName;

//address properties
@property (strong, nonatomic) NSString *line1Venue;
@property (strong, nonatomic) NSString *line2Venue;
@property (strong, nonatomic) NSString *cityVenue;
@property (strong, nonatomic) NSString *zipVenue;
@property (strong, nonatomic) NSString *stateVenue;
@property (strong, nonatomic) NSString *countryVenue;
@property (strong, nonatomic) NSString *latitudeVenue;
@property (strong, nonatomic) NSString *longitudeVenue;

- (id)initForHomeWithDictionary:(NSDictionary*)venueDictionary;
- (id)initForDetailsWithDictionary:(NSDictionary*)venueDictionary;


@end
