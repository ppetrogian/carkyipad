//
//  TransferBookingRequest.h
//
//  Created by   on 17/04/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LatLng,PickupDateTime,Location;

@interface TransferBookingRequest : NSObject <NSCoding, NSCopying>
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *dropoffAddress;
@property (nonatomic, strong) NSString *pickupAddress;
@property (nonatomic, strong) NSString *stripeCardToken;
@property (nonatomic, strong) NSString *payPalPaymentId;
@property (nonatomic, strong) NSString *payPalPayerId;
@property (nonatomic, assign) NSInteger passengersNumber;
@property (nonatomic, strong) Location *dropoffLocation;
@property (nonatomic, assign) NSInteger dropoffWellKnownLocationId;
@property (nonatomic, assign) BOOL agreedToTermsAndConditions;

@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, strong) PickupDateTime *pickupDateTime;
@property (nonatomic, assign) NSInteger paymentMethod;
@property (nonatomic, strong) LatLng *pickupLatLng;
@property (nonatomic, strong) NSArray<NSNumber*> *extras;
@property (nonatomic, assign) NSInteger carkyCategoryId;
@property (nonatomic, assign) NSInteger luggagePiecesNumber;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
