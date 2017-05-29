//
//  BookingInfo.h
//
//  Created by   on 19/5/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LatLng;

@interface BookingInfoResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *dropoffAddress;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, assign) double carPrice;
@property (nonatomic, strong) NSString *pickupAddress;
@property (nonatomic, strong) NSString *carImage;
@property (nonatomic, strong) NSString *insuranceDisplay;
@property (nonatomic, strong) NSString *pickupTime;
@property (nonatomic, strong) NSString *dropoffTime;
@property (nonatomic, strong) LatLng *dropoffLatLng;
@property (nonatomic, strong) NSString *dropoffDate;
@property (nonatomic, strong) NSString *reservationCode;
@property (nonatomic, assign) double extrasPrice;
@property (nonatomic, assign) double insurancePrice;
@property (nonatomic, assign) double total;
@property (nonatomic, strong) LatLng *pickupLatLng;
@property (nonatomic, strong) NSString *extrasDisplay;
@property (nonatomic, strong) NSString *pickupDate;
@property (nonatomic, strong) NSString *carDisplay;
@property (nonatomic, assign) double actualDurationInDays;
@property (nonatomic, assign) double pricingDurationInDays;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
