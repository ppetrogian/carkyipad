//
//  RentalBookingResponse.h
//
//  Created by   on 17/05/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LatLng;

@interface RentalBookingResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *dropoffAddress;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, assign) NSInteger carPrice;
@property (nonatomic, strong) NSString *pickupAddress;
@property (nonatomic, strong) NSString *pickupDate;
@property (nonatomic, strong) NSString *insuranceDisplay;
@property (nonatomic, strong) NSString *pickupTime;
@property (nonatomic, strong) NSString *dropoffTime;
@property (nonatomic, strong) LatLng *dropoffLatLng;
@property (nonatomic, strong) NSString *dropoffDate;
@property (nonatomic, strong) NSString *reservationCode;
@property (nonatomic, assign) NSInteger extrasPrice;
@property (nonatomic, assign) NSInteger insurancePrice;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) LatLng *pickupLatLng;
@property (nonatomic, strong) NSString *extrasDisplay;
@property (nonatomic, strong) NSString *payPalPaymentId;
@property (nonatomic, strong) NSString *carDisplay;
@property (nonatomic, strong) NSString *carImage;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
