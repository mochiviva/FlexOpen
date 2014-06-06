//
//  NSData+Base64.h
//  base64
//
//
//
//  Created by Mihai Olteanu on 2/11/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <Foundation/Foundation.h>

void *NewBase64Decode(
	const char *inputBuffer,
	size_t length,
	size_t *outputLength);

char *NewBase64Encode(
	const void *inputBuffer,
	size_t length,
	bool separateLines,
	size_t *outputLength);

@interface NSData (Base64)

+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;

@end
