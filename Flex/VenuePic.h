//
//  VenuePic.h
//  Flex
//
//  Created by Mihai Olteanu on 5/16/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenuePic : NSObject

@property (strong, nonatomic) NSString *venuePicURL;
@property (strong, nonatomic) NSString *venuePicWidth;
@property (strong, nonatomic) NSString *venuePicHeight;

- (id)initWithDictionary:(NSDictionary*)picsDictionary;

@end
