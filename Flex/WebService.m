//
//  WebService.m
//  Flex
//
//  Created by Mihai Olteanu on 2/11/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import "NSData+Base64.h"
#import "WebService.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import <CommonCrypto/CommonDigest.h>

#define kServerApiURL @"http://preprod.flexpass.ca"
#define kServerApiURL2Path @"/api/v1/devices.json"
#define kServerApiURL3Path @"/api/v1/passes.json"
#define kServerApiURLCreateUser @"/api/v1/users.json"

@implementation WebService





- (void) startActionDevRegister:(NSString *)platform
                        product:(NSString *)product
                          model:(NSString *)model
                      osversion:(NSString *)osversion
                     appversion:(NSString *)appversion
                            lat:(NSString *)lat
                            lng:(NSString *)lng
                           uuid:(NSString *)uuid;
{
    if (lat == nil)
        lat = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    if (lng == nil)
        lng = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            platform, @"platform",
                            product, @"product",
                            model, @"model",
                            osversion, @"osversion",
                            appversion, @"appversion",
                            lat, @"lat",
                            lng, @"lng",
                            [[NSUserDefaults standardUserDefaults] objectForKey:@"appID"], @"uuid", nil];
    
    [self createRequestForMethod:@"startActionDevRegister" withParams:params urlPath:kServerApiURL2Path method:@"POST" authHeader:[self makeFirstAuthHeader] outsideReq:nil];
}












- (void) startActionCreateUser:(NSString*)email
                      fullName:(NSString*)fullName
                      password:(NSString*)password;
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            email, @"email",
                            fullName, @"fullName",
                            password, @"password",
                            @"member", @"role",
                            [[NSUserDefaults standardUserDefaults] objectForKey:@"appID"], @"uuid", nil];
    [self createRequestForMethod:@"startActionCreateUser" withParams:params urlPath:kServerApiURLCreateUser method:@"POST" authHeader:[self makeFirstAuthHeader] outsideReq:nil];
}












- (void) startActionSignInEmail:(NSString*)email
                       password:(NSString*)password;
{
    NSString *encodedEmail = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(                                                                                  NULL,(__bridge CFStringRef)((email)),NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8 ));
    
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/users/%@/signin.json",encodedEmail];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            password, @"password",        
                            [[NSUserDefaults standardUserDefaults] objectForKey:@"appID"], @"uuid", nil];
    [self createRequestForMethod:@"startActionSignInEmail" withParams:params urlPath:kServerApiURLPath method:@"POST" authHeader:[self makeFirstAuthHeader] outsideReq:nil];
}











- (void) logInWithFacebookID:(NSString*)facebookId
                       email:(NSString*)email
                    fullName:(NSString*)fullName
            facebookUsername:(NSString*)facebookUsername
                 facebookUrl:(NSString*)facebookUrl
                  pictureUrl:(NSString*)pictureUrl
                      locale:(NSString*)locale
                    agerange:(NSString*)agerange
                      gender:(NSString*)gender
                        uuid:(NSString*)uuid;
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            facebookId, @"facebookId",
                            email, @"email",
                            fullName, @"fullName",
                            facebookUsername, @"facebookUsername",
                            facebookUrl, @"facebookUrl",
                            locale, @"locale",
                            agerange, @"agerange",
                            gender, @"gender",
                            [[NSUserDefaults standardUserDefaults] objectForKey:@"appID"], @"uuid", nil];
    [self createRequestForMethod:@"logInWithFacebookID" withParams:params urlPath:kServerApiURLCreateUser method:@"POST" authHeader:[self makeFirstAuthHeader] outsideReq:nil];
}









- (void) getUserID:(NSString*)userID;
{
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/users/%@.json",userID];
    [self createRequestForMethod:@"getUserID" withParams:nil urlPath:kServerApiURLPath method:@"GET" authHeader:[self makeAuthHeather] outsideReq:nil];
}







- (void) updateUserID:(NSString*)userID
                email:(NSString*)email
             fullName:(NSString*)fullName
          phoneNumber:(NSString*)phoneNumber
           pictureUrl:(NSString*)pictureUrl;
{
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/users/%@.json",userID];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"PUT", @"_method",
                            pictureUrl, @"pictureUrl",
                            email, @"email",
                            fullName, @"fullName",
                            phoneNumber, @"phoneNumber",
                            nil];
    NSLog(@"dictionarul cu parametri este : %@",params);
    
    [self createRequestForMethod:@"updateUserID" withParams:params urlPath:kServerApiURLPath method:@"POST" authHeader:[self makeAuthHeather] outsideReq:nil];
}








- (void) resetPasswordForUserEmail:(NSString*)email;
{
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/users/%@/password.json",email];
    [self createRequestForMethod:@"resetPasswordForUserEmail" withParams:nil urlPath:kServerApiURLPath method:@"POST" authHeader:[self makeAuthHeather] outsideReq:nil];
}








- (void) updatePasswordForUserID:(NSString*)userID
                     oldPassword:(NSString*)oldPassword
                     newPassword:(NSString*)newPassword;
{
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/users/%@/password.json",userID];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            oldPassword, @"oldPasswd",
                            newPassword, @"newPasswd",
                            nil];
    [self createRequestForMethod:@"updatePasswordForUserID" withParams:params urlPath:kServerApiURLPath method:@"POST" authHeader:[self makeAuthHeather] outsideReq:nil];
}







- (void) getCreditCardForUserID:(NSString*)userID;
{
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/users/%@/creditcard.json",userID];
    [self createRequestForMethod:@"getCreditCardForUserID" withParams:nil urlPath:kServerApiURLPath method:@"GET" authHeader:[self makeAuthHeather] outsideReq:nil];
}







- (void) updateCreditCardForUserID:(NSString*)userID
                        cardNumber:(NSString*)cardNumber
                          expMonth:(NSString*)expMonth
                           expYear:(NSString*)expYear
                           cvcCode:(NSString*)cvcCode;
{
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/users/%@/creditcard.json",userID];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            cardNumber, @"number",
                            expMonth, @"exp_month",
                            expYear, @"exp_year",
                            cvcCode, @"cvc",
                            nil];
    [self createRequestForMethod:@"updateCreditCardForUserID" withParams:params urlPath:kServerApiURLPath method:@"POST" authHeader:[self makeAuthHeather] outsideReq:nil];
}







- (void) getActivitiesForUserID:(NSString*)userID;
{
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/users/%@/activities.json",userID];
    [self createRequestForMethod:@"getActivitiesForUserID" withParams:nil urlPath:kServerApiURLPath method:@"GET" authHeader:[self makeAuthHeather] outsideReq:nil];
}







- (void) updateActivitiesForUserID:(NSString*)userID
                   activitiesArray:(NSArray*)activitiesArray;
{
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/users/%@/activities.json",userID];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            activitiesArray, @"activities",
                            nil];
    [self createRequestForMethod:@"updateActivitiesForUserID" withParams:params urlPath:kServerApiURLPath method:@"POST" authHeader:[self makeAuthHeather] outsideReq:nil];
}







- (void) getHomeForUserID:(NSString*)userID
                      lat:(NSString*)lat
                      lng:(NSString*)lng;
{
    if (lat == nil)
        lat = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    if (lng == nil)
        lng = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/users/%@/home.json",userID];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            lat, @"lat",
                            lng, @"lng",
                            nil];
    [self createRequestForMethod:@"getHomeForUserID" withParams:params urlPath:kServerApiURLPath method:@"GET" authHeader:[self makeAuthHeather] outsideReq:nil];
}










- (void) listVenuesWithName:(NSString*)name
                   category:(NSString*)category
                  favorites:(NSString*)favorites
                        lat:(NSString*)lat
                        lng:(NSString*)lng
                       page:(NSString*)page
                      start:(NSString*)start
                   pagesize:(NSString*)pagesize;
{
    if (lat == nil)
        lat = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    if (lng == nil)
        lng = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
    
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/venues.json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            name, @"search",
                            category, @"category",
                            favorites, @"favorites",
                            lat, @"lat",
                            lng, @"lng",
                            page, @"page",
                            start, @"start",
                            pagesize, @"pagesize",
                            nil];
    [self createRequestForMethod:@"listVenuesWithName" withParams:params urlPath:kServerApiURLPath method:@"GET" authHeader:[self makeAuthHeather] outsideReq:nil];
}









- (void) detailsForVenueID:(NSString*)venueID;
{
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/venues/%@.json", venueID];
    [self createRequestForMethod:@"detailsForVenueID" withParams:nil urlPath:kServerApiURLPath method:@"GET" authHeader:[self makeAuthHeather] outsideReq:nil];
}









- (void) favoriteVenueID:(NSString*)venueID
     favoriteTrueOrFalse:(NSString*)favoriteTrueOrFalse;
{
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/venues/%@.json", venueID];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            favoriteTrueOrFalse, @"favorite", @"PUT", @"_method",
                            nil];
    [self createRequestForMethod:@"favoriteVenueID" withParams:params urlPath:kServerApiURLPath method:@"POST" authHeader:[self makeAuthHeather] outsideReq:nil];
}



- (NSString*)makemd5sumForData:(NSData*)data
{
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(data.bytes, data.length, md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
    
//    unsigned char result[16];
//    CC_MD5([data bytes], [data length], result);
//    NSLog(@"md5 result este %s",result);
//    
//    NSString *imageHash = [NSString stringWithFormat:
//                           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
//                           result[0], result[1], result[2], result[3],
//                           result[4], result[5], result[6], result[7],
//                           result[8], result[9], result[10], result[11],
//                           result[12], result[13], result[14], result[15]
//                           ];
//    return imageHash;
}

- (void) uploadFile:(NSData*)file
          forUserID:(NSString*)userID
               name:(NSString*)name
             md5sum:(NSString*)md5sum
             handle:(NSString*)handle;
{
        
    
    
    
    
    
    
//    NSData *nameData = [name dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *md5sumData = [md5sum dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *handleData = [handle dataUsingEncoding:NSUTF8StringEncoding];
    
//    NSData *imageData =UIImagePNGRepresentation(file);

//    NSString* str = @"teststring";
//    NSData* imageData = [str dataUsingEncoding:NSUTF8StringEncoding];


    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/users/%@/uploads.json?name=%@&md5sum=%@&handle=%@", userID,name,[self makemd5sumForData:file],handle];
    
    NSLog(@"dimensiunea fisierululi este: %@",[NSByteCountFormatter stringFromByteCount:file.length countStyle:NSByteCountFormatterCountStyleFile]);

//    NSDictionary *params = @{@"name":nameData,@"md5sum":md5sumData,@"handle":handleData};
//    NSLog(@"parametrii sunt: %@",params);

    NSURL *url = [NSURL URLWithString: kServerApiURL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setDefaultHeader:@"Authorization" value:[self makeAuthHeather]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"Post" path:kServerApiURLPath parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
        [formData appendPartWithFileData:file name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg",@"nice"] mimeType:@"image/jpeg"];
    }];
# warning cu blocul acesta de cod in loc de createRequest... putem urmari uploadul imaginii in asa fel incat sa putem pune un loading-bar
    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//               NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//        
//    }];
//    
//    [operation setCompletionBlock:^{
//        NSLog(@"%@", operation.responseString); //Gives a very scary warning
//    }];
//    
//    [operation start];
    [self createRequestForMethod:@"uploadFile" withParams:nil urlPath:nil method:nil authHeader:nil outsideReq:request];
 
}



- (void) uploadPictureForVenueID:(NSString*)venueID
                      pictureURL:(NSString*)pictureURL;
{
//    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/venues/%@/pictures.json?pictureUrl=%@", venueID,pictureURL];
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/venues/%@/pictures.json", venueID];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            pictureURL, @"pictureUrl",
                            nil];
//    NSLog(@"parametrii sunt: %@",params);
    [self createRequestForMethod:@"uploadPictureForVenueID" withParams:params urlPath:kServerApiURLPath method:@"POST" authHeader:[self makeAuthHeather] outsideReq:nil];
}






- (void) listPicturesForVenueID:(NSString*)venueID
                       fromPage:(NSString*)page
                          start:(NSString*)start
                       pagesize:(NSString*)pagesize;
{
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/venues/%@/pictures.json", venueID];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            page, @"page",
                            start, @"start",
                            pagesize, @"pagesize",
                            nil];
    [self createRequestForMethod:@"listPicturesForVenueID" withParams:params urlPath:kServerApiURLPath method:@"GET" authHeader:[self makeAuthHeather] outsideReq:nil];
}




- (void) startActionGetCodeForVenueID:(NSString*)venueID
{
    NSString *kServerApiURLPath = [NSString stringWithFormat:@"/api/v1/venues/%@/passes.json", venueID];
    [self createRequestForMethod:@"startActionGetCodeForVenueID" withParams:nil urlPath:kServerApiURLPath method:@"POST" authHeader:[self makeAuthHeather] outsideReq:nil];
}




//- (void) startActionGetCode;
//{
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    NSString *secret = [[NSUserDefaults standardUserDefaults] objectForKey:@"secret"];
//    NSString *plainText = [NSString stringWithFormat:@"%@:%@", token, secret];
//    NSLog(@"plain %@", plainText);
//    NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64String = [plainTextData base64EncodedString];
//    NSString *authHeather = [NSString stringWithFormat:@"Basic %@",base64String];
//    
//    if (authHeather.length >69) {
//        NSString *primul = [authHeather substringToIndex:70];
//        NSString *doilea = [authHeather substringFromIndex:72];
//        authHeather = [NSString stringWithFormat:@"%@%@",primul,doilea];
//    }
//    
//    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
//    
//    NSLog(@"email-ul este %@",email);
//    NSArray *suffixesArray = @[@"preprod",@"local",@"dimi",@"mock"];
//    NSRange pointInEmailIndex = [email rangeOfString:@"." options:NSBackwardsSearch];
//    NSString *suffix = [email substringFromIndex:pointInEmailIndex.location+1];
//    
//    NSString *serverURL = kServerApiURL;
//    for (int i=0; i<[suffixesArray count]; i++) {
//        if ([suffix isEqualToString:[suffixesArray objectAtIndex:i]]) {
//            serverURL = [NSString stringWithFormat:@"http://%@.flexpass.ca",suffix];
//        }
//    }
//    
//    
//    NSURL *url = [NSURL URLWithString: serverURL];
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
//    [httpClient setDefaultHeader:@"Authorization" value:authHeather];
//    
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"], @"lat",
//                            [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"], @"lng",
//                            nil];
//    
//    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path: kServerApiURL3Path parameters:params];
//    
//    AFJSONRequestOperation *operation =
//    [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:
//     ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
//     {
//         NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:JSON];
//
//         if(self.delegate){
//             [self.delegate webServiceResponded:responseDict forRequest:@"startActionGetCode"];
//         }
//
//         if (response.statusCode == 200)
//         {
//             NSLog(@"from json master code %i", response.statusCode);
//         }
//     }
//                                                    failure:
//     ^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON)
//     {
//         NSLog(@"[Error]: (%@ %@) %@", [request HTTPMethod], [[request URL] relativePath], error);
//         if(self.delegate){
//             [self.delegate webServiceError:error forRequest:@"startActionGetCode"];
//         }
//     }];
//    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperation:operation];
//}













/*
 authheader
 kServerApiURLPath
 method (put, post, get)
 methodname (getHomeForUserID)
 NSDictionary (params)
 */


- (void) createRequestForMethod:(NSString*)methodName
                     withParams:(NSDictionary*)params
                        urlPath:(NSString*)urlPath
                         method:(NSString*)method
                     authHeader:(NSString*)authHeader
                     outsideReq:(NSMutableURLRequest*)outReq

{
    if(self.delegate){
        [self.delegate webServiceConnecting:methodName];
    }
    
    NSMutableURLRequest *request;
    if ([methodName isEqualToString:@"uploadFile"]) {
        request = outReq;

    }else
    {
        NSURL *url = [NSURL URLWithString: kServerApiURL];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        [httpClient setDefaultHeader:@"Authorization" value:authHeader];
        request = [httpClient requestWithMethod:method path: urlPath parameters:params];
    }
    NSLog(@"request is %@",request);

    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:
     ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
     {
         
         NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:JSON];
         
         if(self.delegate){
             [self.delegate webServiceResponded:responseDict forRequest:methodName];
         }
         
         if (response.statusCode == 200)
         {
             NSLog(@"from json master code %i", response.statusCode);
         }
     }
                                                    failure:
     ^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON)
     {
         NSLog(@"[Error]: (%@ %@) %@", [request HTTPMethod], [[request URL] relativePath], error);
         if(self.delegate){
             NSString *alertMessage;
//             if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."])
//                 alertMessage = error.localizedDescription;
//             else
//             {
//                 
//                 NSDictionary *errorMess =
//                 [NSJSONSerialization JSONObjectWithData: [error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding]
//                                                 options: NSJSONReadingMutableContainers
//                                                   error: nil];
//                 if (errorMess.count == 1)
//                     alertMessage = [NSString stringWithFormat:@"%@", errorMess];
//#warning Here the app will crash if the message is wrong formated !!!!
//                 else
//                     alertMessage = (NSString*)[(NSDictionary*)[(NSArray*)[errorMess objectForKey:@"fields"]objectAtIndex:0] objectForKey:@"message"];
//#warning !!!
//             }
             if (error.localizedRecoverySuggestion)
             {
                 NSDictionary *errorMess =
                 [NSJSONSerialization JSONObjectWithData: [error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding]
                                                 options: NSJSONReadingMutableContainers
                                                   error: nil];
                 if (errorMess.count == 1)
                     alertMessage = [NSString stringWithFormat:@"%@", errorMess];
#warning Here the app will crash if the message is wrong formated !!!!
                 else
                     alertMessage = (NSString*)[(NSDictionary*)[(NSArray*)[errorMess objectForKey:@"fields"]objectAtIndex:0] objectForKey:@"message"];
#warning !!!
             }
             else if (error.localizedDescription)
                 alertMessage = error.localizedDescription;
             else
                 alertMessage = @"";
             [self.delegate webServiceError:alertMessage forRequest:methodName];
         }
     }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}


- (NSString*)makeFirstAuthHeader
{
    NSString *plainText = @"android:7d25e85001505608d2fd4ef261e059f2";
    NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainTextData base64EncodedString];
    NSString *authHeather = [NSString stringWithFormat:@"Basic %@",base64String];
    return authHeather;
}

- (NSString*)makeAuthHeather
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *secret = [[NSUserDefaults standardUserDefaults] objectForKey:@"secret"];
    NSString *plainText = [NSString stringWithFormat:@"%@:%@", token, secret];
    NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainTextData base64EncodedString];
    NSString *authHeather = [NSString stringWithFormat:@"Basic %@",base64String];
//    NSString *authHeather = plainText;

    if (authHeather.length >69) {
        NSString *primul = [authHeather substringToIndex:70];
        NSString *doilea = [authHeather substringFromIndex:72];
        authHeather = [NSString stringWithFormat:@"%@%@",primul,doilea];
    }
    return authHeather;
}

@end
