//
//  RentalBookingRequest.h
//
//  Created by   on 15/05/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LatLng;

@interface RentalBookingRequest : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *dropoffAddress;
@property (nonatomic, strong) NSString *pickupAddress;
@property (nonatomic, assign) NSInteger wellKnowPickupLocationId;
@property (nonatomic, assign) NSInteger carInsuranceId;
@property (nonatomic, assign) NSInteger commission;
@property (nonatomic, assign) NSInteger fleetLocationId;
@property (nonatomic, strong) NSString *pickupTime;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) LatLng *dropoffLatLng;
@property (nonatomic, strong) NSString *dropoffTime;
@property (nonatomic, assign) NSInteger wellKnowDropoffLocationId;
@property (nonatomic, strong) NSString *dropoffDate;
@property (nonatomic, strong) NSString *stripeCardId;
@property (nonatomic, assign) BOOL agreedToTermsAndConditions;
@property (nonatomic, strong) LatLng *pickupLatLng;
@property (nonatomic, assign) NSInteger paymentMethod;
@property (nonatomic, strong) NSArray *extras;
@property (nonatomic, assign) NSInteger carTypeId;
@property (nonatomic, strong) NSString *pickupDate;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
