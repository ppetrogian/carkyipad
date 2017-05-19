//
//  RentalBookingResponse.h
//
//  Created by   on 19/5/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BookingInfoResponse, PayPalPaymentInfo;

@interface RentalBookingResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) BookingInfoResponse *bookingInfo;
@property (nonatomic, strong) PayPalPaymentInfo *payPalPaymentInfo;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
