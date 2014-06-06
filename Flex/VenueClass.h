//
//  VenueClass.h
//  Flex
//
//  Created by Mihai Olteanu on 5/20/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenueClass : NSObject

@property (strong, nonatomic) NSString *idClass;
@property (strong, nonatomic) NSString *titleClass;
@property (strong, nonatomic) NSString *descriptionClass;
@property (strong, nonatomic) NSDictionary *scheduleClass;

- (id)initWithDictionary:(NSDictionary*)classDictionary;

@end
