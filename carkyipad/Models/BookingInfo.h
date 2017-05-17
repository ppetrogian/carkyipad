//
//  BookingInfo.h
//
//  Created by   on 17/05/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DateTime, PickupLocation, DropoffDateTime, Location;

@interface BookingInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger wellKnownDropoffLocationId;
@property (nonatomic, assign) NSInteger carTypeId;
@property (nonatomic, assign) NSInteger insuranceId;
@property (nonatomic, assign) NSInteger commission;
@property (nonatomic, assign) NSInteger fleetLocationId;
@property (nonatomic, assign) BOOL agreedToTermsAndConditions;
@property (nonatomic, strong) DateTime *pickupDateTime;
@property (nonatomic, strong) Location *pickupLocation;
@property (nonatomic, strong) DateTime *dropoffDateTime;
@property (nonatomic, assign) NSInteger wellKnownPickupLocationId;
@property (nonatomic, strong) NSArray *extraIds;
@property (nonatomic, strong) Location *dropoffLocation;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
