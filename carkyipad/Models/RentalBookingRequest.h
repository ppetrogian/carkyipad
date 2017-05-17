//
//  RentalBookingRequest.h
//
//  Created by   on 17/05/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BookingInfo, PaymentInfo;

@interface RentalBookingRequest : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) BookingInfo *bookingInfo;
@property (nonatomic, strong) PaymentInfo *paymentInfo;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
