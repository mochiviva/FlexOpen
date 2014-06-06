//
//  Venue.m
//  Flex
//
//  Created by Mihai Olteanu on 5/16/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "Venue.h"
#import "VenuePic.h"
#import "VenueClass.h"

@implementation Venue

- (id)initForHomeWithDictionary:(NSDictionary*)venueDictionary
{
    
    self = [super init];
    if (self) {
        _idVenue = [venueDictionary objectForKey:@"id"];
        _slugVenue = [venueDictionary objectForKey:@"slug"];
        _nameVenue = [venueDictionary objectForKey:@"name"];
        _urlVenue = [venueDictionary objectForKey:@"url"];
        _ratingVenue = [venueDictionary objectForKey:@"rating"];
        _isFavoriteVenue = [NSString stringWithFormat:@"%@",[venueDictionary objectForKey:@"favorite"]];
        _phoneVenue = [venueDictionary objectForKey:@"phone"];
//        _distanceVenue = [venueDictionary objectForKey:@"distance"];
//        _distanceVenue = @"bla";
        int distanceInMeters = [[venueDictionary objectForKey:@"distance"] integerValue];
        if (distanceInMeters > 99000) // >99 KM
            _distanceVenue = @">99 km";
        else if (distanceInMeters > 1000)
            _distanceVenue = [NSString stringWithFormat:@"%.1lf km", (distanceInMeters / 1000.0)];
        else
            _distanceVenue = [NSString stringWithFormat:@"%d m", distanceInMeters];
        if (distanceInMeters == 0)
            _distanceVenue = @"";
        //collections:
//        if ([venueDictionary objectForKey:@"address"] != [NSNull null]) {
            _venueAddress = [venueDictionary objectForKey:@"address"]!= [NSNull null]?[venueDictionary objectForKey:@"address"]:[NSDictionary dictionary];
            [self formatAddress];
//        }
        
            
        _venueCategories = [venueDictionary objectForKey:@"categories"];
        _categoryVenue = [_venueCategories objectAtIndex:0];
        _iconName = [self formatIconName];

        
    }
    return self;
}

- (id)initForDetailsWithDictionary:(NSDictionary*)venueDictionary
{
    
    self = [super init];
    if (self) {
        _idVenue = [venueDictionary objectForKey:@"id"];
        _slugVenue = [venueDictionary objectForKey:@"slug"];
        _nameVenue = [venueDictionary objectForKey:@"name"];
        _urlVenue = [venueDictionary objectForKey:@"url"];
        _ratingVenue = [venueDictionary objectForKey:@"rating"];
        _isFavoriteVenue = [NSString stringWithFormat:@"%@",[venueDictionary objectForKey:@"favorite"]];
        _phoneVenue = [venueDictionary objectForKey:@"phone"];
        _distanceVenue = [venueDictionary objectForKey:@"distance"];

        //collections:
//        if ([venueDictionary objectForKey:@"address"] != [NSNull null]) {
            _venueAddress = [venueDictionary objectForKey:@"address"]!= [NSNull null]?[venueDictionary objectForKey:@"address"]:[NSDictionary dictionary];
            [self formatAddress];
//        }

        _venueCategories = [venueDictionary objectForKey:@"categories"];
        _categoryVenue = [_venueCategories objectAtIndex:0];
        _iconName = [self formatIconName];
        
        _venueAvatar = [venueDictionary objectForKey:@"avatar"];
        NSArray *picsArray = [venueDictionary objectForKey:@"hilightPics"];
        _venuePics = [self formatPicsWithArray:picsArray];
        _venueSchedule = [venueDictionary objectForKey:@"schedule"] != [NSNull null]? [venueDictionary objectForKey:@"schedule"]:[NSDictionary dictionary];
        _venueFacilities = [venueDictionary objectForKey:@"facilities"] != [NSNull null]? [venueDictionary objectForKey:@"facilities"]:[NSDictionary dictionary];
        NSArray *classesArray = [venueDictionary objectForKey:@"classes"];

        _venueClasses = [self formatClassesWithArray:classesArray];

        
    }
    return self;
}

- (void)formatAddress
{
    _line1Venue = [_venueAddress objectForKey:@"line1"] != [NSNull null]?[_venueAddress objectForKey:@"line1"]:@"";
    if (_line1Venue == nil)
        _line1Venue = @"";
    
    _line2Venue = [_venueAddress objectForKey:@"line2"] != [NSNull null]?[_venueAddress objectForKey:@"line2"]:@"";
    if (_line2Venue == nil)
        _line2Venue = @"";
    
    _cityVenue = [_venueAddress objectForKey:@"city"]!= [NSNull null]?[_venueAddress objectForKey:@"city"]:@"";
    if (_cityVenue == nil)
        _cityVenue = @"";
    _zipVenue = [_venueAddress objectForKey:@"zip"] != [NSNull null]?[_venueAddress objectForKey:@"zip"]:@"";
    if (_zipVenue == nil)
        _zipVenue = @"";
    _stateVenue = [_venueAddress objectForKey:@"state"]!= [NSNull null]?[_venueAddress objectForKey:@"state"]:@"";
    if (_stateVenue == nil)
        _stateVenue = @"";
    _countryVenue = [_venueAddress objectForKey:@"country"]!= [NSNull null]?[_venueAddress objectForKey:@"country"]:@"";
    if (_countryVenue == nil)
        _countryVenue = @"";
    _latitudeVenue = [_venueAddress objectForKey:@"lat"]!= [NSNull null]?[_venueAddress objectForKey:@"lat"]:@"";
    
    _longitudeVenue = [_venueAddress objectForKey:@"lng"]!= [NSNull null]?[_venueAddress objectForKey:@"lng"]:@"";
}

- (NSArray*)formatPicsWithArray:(NSArray*)feedArray
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary* picsObj in feedArray)
    {
        VenuePic *onePic = [[VenuePic alloc]initWithDictionary:picsObj];
        [tempArray addObject:onePic];
    }
    NSArray *arrayReturn = [tempArray copy];
    return arrayReturn;
}

- (NSArray*)formatClassesWithArray:(NSArray*)feedArray
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary* classObj in feedArray)
    {
        VenueClass *oneClass = [[VenueClass alloc]initWithDictionary:classObj];
        [tempArray addObject:oneClass];
    }
    NSArray *arrayReturn = [tempArray copy];
    return arrayReturn;
}

- (NSString*)formatIconName
{

    NSString *theName;
    NSDictionary *iconNames = @{@"Boxing": @"boxing",@"Dance": @"dancing",@"fitness": @"gym",@"Martial Arts": @"mma",@"Pilates": @"pt",@"swimming": @"swimming",@"Yoga": @"yoga",@"yoga": @"yoga"};
    bool founded = 0;
    for (NSString* nameKey in [iconNames allKeys]) {
        if ([nameKey isEqualToString:_categoryVenue]) {
            if ([_isFavoriteVenue isEqualToString:@"1"]) {
                theName = [NSString stringWithFormat:@"%@-favorite",[iconNames objectForKey:nameKey]];
            } else
            {
                theName = [NSString stringWithFormat:@"%@-normal",[iconNames objectForKey:nameKey]];
            }
            founded = 1;
        }
    }
    if (!founded) {
            theName = [_isFavoriteVenue isEqualToString:@"1"] ? @"others-favorite":@"others-normal";
    }
    return theName;
}

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [_latitudeVenue doubleValue];
    theCoordinate.longitude = [_longitudeVenue doubleValue];
    return theCoordinate;
}

- (NSString *)title
{
    return _nameVenue;
}

// optional
- (NSString *)subtitle
{
    return _categoryVenue;
}


@end
