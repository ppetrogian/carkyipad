//
//  RentalBookingRequest.m
//
//  Created by   on 17/05/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "RentalBookingRequest.h"
#import "BookingInfo.h"
#import "PaymentInfo.h"


NSString *const kRentalBookingRequestUserId = @"UserId";
NSString *const kRentalBookingRequestBookingInfo = @"BookingInfo";
NSString *const kRentalBookingRequestPaymentInfo = @"PaymentInfo";


@interface RentalBookingRequest ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RentalBookingRequest

@synthesize userId = _userId;
@synthesize bookingInfo = _bookingInfo;
@synthesize paymentInfo = _paymentInfo;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.userId = [self objectOrNilForKey:kRentalBookingRequestUserId fromDictionary:dict];
            self.bookingInfo = [BookingInfo modelObjectWithDictionary:[dict objectForKey:kRentalBookingRequestBookingInfo]];
            self.paymentInfo = [PaymentInfo modelObjectWithDictionary:[dict objectForKey:kRentalBookingRequestPaymentInfo]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.userId forKey:kRentalBookingRequestUserId];
    [mutableDict setValue:[self.bookingInfo dictionaryRepresentation] forKey:kRentalBookingRequestBookingInfo];
    [mutableDict setValue:[self.paymentInfo dictionaryRepresentation] forKey:kRentalBookingRequestPaymentInfo];

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

    self.userId = [aDecoder decodeObjectForKey:kRentalBookingRequestUserId];
    self.bookingInfo = [aDecoder decodeObjectForKey:kRentalBookingRequestBookingInfo];
    self.paymentInfo = [aDecoder decodeObjectForKey:kRentalBookingRequestPaymentInfo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_userId forKey:kRentalBookingRequestUserId];
    [aCoder encodeObject:_bookingInfo forKey:kRentalBookingRequestBookingInfo];
    [aCoder encodeObject:_paymentInfo forKey:kRentalBookingRequestPaymentInfo];
}

- (id)copyWithZone:(NSZone *)zone {
    RentalBookingRequest *copy = [[RentalBookingRequest alloc] init];
    
    
    
    if (copy) {

        copy.userId = [self.userId copyWithZone:zone];
        copy.bookingInfo = [self.bookingInfo copyWithZone:zone];
        copy.paymentInfo = [self.paymentInfo copyWithZone:zone];
    }
    
    return copy;
}


@end
