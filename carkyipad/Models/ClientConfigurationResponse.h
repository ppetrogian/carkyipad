//
//  ClientConfigurationResponse.h
//
//  Created by Filippos Sakellaropoulos on 23/04/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Location;

@interface ClientConfigurationResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *carServices;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *tradingName;
@property (nonatomic, assign) NSInteger areaOfServiceId;
@property (nonatomic, assign) NSInteger zoneId;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSString *pickupInstructionsImage;
@property (nonatomic, assign) NSInteger tabletMode;
@property (nonatomic, strong) NSString *payPalMode;
@property (nonatomic, strong) NSString *payPalClientId;
@property (nonatomic, assign) BOOL booksLater;
@property (nonatomic, strong) NSString *rentalBackgroundImage;
@property (nonatomic, strong) NSString *transferBackgroundImage;
@property (nonatomic, strong) NSString *confirmationVideo;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
