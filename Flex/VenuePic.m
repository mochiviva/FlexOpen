//
//  VenuePic.m
//  Flex
//
//  Created by Mihai Olteanu on 5/16/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "VenuePic.h"

@implementation VenuePic

- (id)initWithDictionary:(NSDictionary*)picsDictionary
{
    
    self = [super init];
    if (self) {
        _venuePicURL = [picsDictionary objectForKey:@"url"];
        _venuePicWidth = [picsDictionary objectForKey:@"width"];
        _venuePicHeight = [picsDictionary objectForKey:@"height"];
        
    }
    return self;
}

@end
