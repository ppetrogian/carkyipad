//
//  RentalBookingResponse.m
//
//  Created by   on 19/5/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "RentalBookingResponse.h"
#import "BookingInfoResponse.h"
#import "PayPalPaymentInfo.h"


NSString *const kRentalBookingResponseBookingInfo = @"BookingInfo";
NSString *const kRentalBookingResponsePayPalPaymentInfo = @"PayPalPaymentInfo";


@interface RentalBookingResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RentalBookingResponse

@synthesize bookingInfo = _bookingInfo;
@synthesize payPalPaymentInfo = _payPalPaymentInfo;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.bookingInfo = [BookingInfoResponse modelObjectWithDictionary:[dict objectForKey:kRentalBookingResponseBookingInfo]];
            self.payPalPaymentInfo = [PayPalPaymentInfo modelObjectWithDictionary:[dict objectForKey:kRentalBookingResponsePayPalPaymentInfo]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.bookingInfo dictionaryRepresentation] forKey:kRentalBookingResponseBookingInfo];
    [mutableDict setValue:[self.payPalPaymentInfo dictionaryRepresentation] forKey:kRentalBookingResponsePayPalPaymentInfo];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description  {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    self.bookingInfo = [aDecoder decodeObjectForKey:kRentalBookingResponseBookingInfo];
    self.payPalPaymentInfo = [aDecoder decodeObjectForKey:kRentalBookingResponsePayPalPaymentInfo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_bookingInfo forKey:kRentalBookingResponseBookingInfo];
    [aCoder encodeObject:_payPalPaymentInfo forKey:kRentalBookingResponsePayPalPaymentInfo];
}

- (id)copyWithZone:(NSZone *)zone {
    RentalBookingResponse *copy = [[RentalBookingResponse alloc] init];
    
    
    
    if (copy) {

        copy.bookingInfo = [self.bookingInfo copyWithZone:zone];
        copy.payPalPaymentInfo = [self.payPalPaymentInfo copyWithZone:zone];
    }
    
    return copy;
}


@end
