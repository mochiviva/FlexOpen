//
//  WebService.h
//  Flex
//
//  Created by Mihai Olteanu on 2/11/13.
//  Copyright (c) 2013 Mochiviva. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebServiceDelegate;

@interface WebService : NSObject <UIAlertViewDelegate>

@property (nonatomic, assign) id <WebServiceDelegate> delegate;

//done
- (void) startActionDevRegister:(NSString*)platform
                        product:(NSString*)product
                          model:(NSString*)model
                      osversion:(NSString*)osversion
                     appversion:(NSString*)appversion
                            lat:(NSString*)lat
                            lng:(NSString*)lng
                           uuid:(NSString*)uuid;
//done
- (void) startActionCreateUser:(NSString*)email
                      fullName:(NSString*)fullName
                      password:(NSString*)password;
//done
- (void) startActionSignInEmail:(NSString*)email
                       password:(NSString*)password;

//done
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
//done
- (void) getUserID:(NSString*)userID;

//done
- (void) updateUserID:(NSString*)userID
                email:(NSString*)email
             fullName:(NSString*)fullName
          phoneNumber:(NSString*)phoneNumber
           pictureUrl:(NSString*)pictureUrl;
//done
- (void) resetPasswordForUserEmail:(NSString*)email;
//done
- (void) updatePasswordForUserID:(NSString*)userID
                     oldPassword:(NSString*)oldPassword
                     newPassword:(NSString*)newPassword;
//done
- (void) getCreditCardForUserID:(NSString*)userID;
//done
- (void) updateCreditCardForUserID:(NSString*)userID
                        cardNumber:(NSString*)cardNumber
                          expMonth:(NSString*)expMonth
                           expYear:(NSString*)expYear
                           cvcCode:(NSString*)cvcCode;
//done
- (void) getActivitiesForUserID:(NSString*)userID;
//done
- (void) updateActivitiesForUserID:(NSString*)userID
                   activitiesArray:(NSArray*)activitiesArray;

- (void) uploadFile:(NSData*)file
          forUserID:(NSString*)userID
               name:(NSString*)name
             md5sum:(NSString*)md5sum
             handle:(NSString*)handle;
//done
- (void) getHomeForUserID:(NSString*)userID
                      lat:(NSString*)lat
                      lng:(NSString*)lng;
//done
- (void) listVenuesWithName:(NSString*)name
                   category:(NSString*)category
                  favorites:(NSString*)favorites
                        lat:(NSString*)lat
                        lng:(NSString*)lng
                       page:(NSString*)page
                      start:(NSString*)start
                   pagesize:(NSString*)pagesize;
//done
- (void) detailsForVenueID:(NSString*)venueID;
//done
- (void) favoriteVenueID:(NSString*)venueID
     favoriteTrueOrFalse:(NSString*)favoriteTrueOrFalse;
//done
- (void) uploadPictureForVenueID:(NSString*)venueID
                      pictureURL:(NSString*)pictureURL;
//done
- (void) listPicturesForVenueID:(NSString*)venueID
                       fromPage:(NSString*)page
                          start:(NSString*)start
                       pagesize:(NSString*)pagesize;

//done
- (void) startActionGetCodeForVenueID:(NSString*)venueID;

@end

@protocol WebServiceDelegate

-(void) webServiceConnecting:(NSString*)req;
-(void) webServiceResponded:(NSDictionary*)webServiceResponse forRequest:(NSString*)req;
//wrong login; temporary service unavailable; network failure
-(void) webServiceError:(NSString *)alertMessage forRequest:(NSString*)req;

@end