//
//  VenueClass.m
//  Flex
//
//  Created by Mihai Olteanu on 5/20/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "VenueClass.h"

@implementation VenueClass

- (id)initWithDictionary:(NSDictionary*)classDictionary
{
    
    self = [super init];
    if (self) {
        _idClass = [classDictionary objectForKey:@"id"] != [NSNull null]?[classDictionary objectForKey:@"id"]:@"";
        _titleClass = [classDictionary objectForKey:@"title"] != [NSNull null]?[classDictionary objectForKey:@"title"]:@"";
        _descriptionClass = [classDictionary objectForKey:@"description"] != [NSNull null]?[classDictionary objectForKey:@"description"]:@"";
        _scheduleClass = [classDictionary objectForKey:@"schedule"];
    }
    return self;
}

@end
