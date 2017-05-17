//
//  RentalBookingResponse.m
//
//  Created by   on 17/05/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "RentalBookingResponse.h"
#import "LatLng.h"


NSString *const kRentalBookingResponseDropoffAddress = @"DropoffAddress";
NSString *const kRentalBookingResponseDisplayName = @"DisplayName";
NSString *const kRentalBookingResponseCarPrice = @"CarPrice";
NSString *const kRentalBookingResponsePickupAddress = @"PickupAddress";
NSString *const kRentalBookingResponsePickupDate = @"PickupDate";
NSString *const kRentalBookingResponseInsuranceDisplay = @"InsuranceDisplay";
NSString *const kRentalBookingResponsePickupTime = @"PickupTime";
NSString *const kRentalBookingResponseDropoffTime = @"DropoffTime";
NSString *const kRentalBookingResponseDropoffLatLng = @"DropoffLatLng";
NSString *const kRentalBookingResponseDropoffDate = @"DropoffDate";
NSString *const kRentalBookingResponseReservationCode = @"ReservationCode";
NSString *const kRentalBookingResponseExtrasPrice = @"ExtrasPrice";
NSString *const kRentalBookingResponseInsurancePrice = @"InsurancePrice";
NSString *const kRentalBookingResponseTotal = @"Total";
NSString *const kRentalBookingResponsePickupLatLng = @"PickupLatLng";
NSString *const kRentalBookingResponseExtrasDisplay = @"ExtrasDisplay";
NSString *const kRentalBookingResponsePayPalPaymentId = @"PayPalPaymentId";
NSString *const kRentalBookingResponseCarDisplay = @"CarDisplay";
NSString *const kRentalBookingResponseCarImage = @"CarImage";


@interface RentalBookingResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RentalBookingResponse

@synthesize dropoffAddress = _dropoffAddress;
@synthesize displayName = _displayName;
@synthesize carPrice = _carPrice;
@synthesize pickupAddress = _pickupAddress;
@synthesize pickupDate = _pickupDate;
@synthesize insuranceDisplay = _insuranceDisplay;
@synthesize pickupTime = _pickupTime;
@synthesize dropoffTime = _dropoffTime;
@synthesize dropoffLatLng = _dropoffLatLng;
@synthesize dropoffDate = _dropoffDate;
@synthesize reservationCode = _reservationCode;
@synthesize extrasPrice = _extrasPrice;
@synthesize insurancePrice = _insurancePrice;
@synthesize total = _total;
@synthesize pickupLatLng = _pickupLatLng;
@synthesize extrasDisplay = _extrasDisplay;
@synthesize payPalPaymentId = _payPalPaymentId;
@synthesize carDisplay = _carDisplay;
@synthesize carImage = _carImage;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.dropoffAddress = [self objectOrNilForKey:kRentalBookingResponseDropoffAddress fromDictionary:dict];
            self.displayName = [self objectOrNilForKey:kRentalBookingResponseDisplayName fromDictionary:dict];
            self.carPrice = [[self objectOrNilForKey:kRentalBookingResponseCarPrice fromDictionary:dict] doubleValue];
            self.pickupAddress = [self objectOrNilForKey:kRentalBookingResponsePickupAddress fromDictionary:dict];
            self.pickupDate = [self objectOrNilForKey:kRentalBookingResponsePickupDate fromDictionary:dict];
            self.insuranceDisplay = [self objectOrNilForKey:kRentalBookingResponseInsuranceDisplay fromDictionary:dict];
            self.pickupTime = [self objectOrNilForKey:kRentalBookingResponsePickupTime fromDictionary:dict];
            self.dropoffTime = [self objectOrNilForKey:kRentalBookingResponseDropoffTime fromDictionary:dict];
            self.dropoffLatLng = [LatLng modelObjectWithDictionary:[dict objectForKey:kRentalBookingResponseDropoffLatLng]];
            self.dropoffDate = [self objectOrNilForKey:kRentalBookingResponseDropoffDate fromDictionary:dict];
            self.reservationCode = [self objectOrNilForKey:kRentalBookingResponseReservationCode fromDictionary:dict];
            self.extrasPrice = [[self objectOrNilForKey:kRentalBookingResponseExtrasPrice fromDictionary:dict] doubleValue];
            self.insurancePrice = [[self objectOrNilForKey:kRentalBookingResponseInsurancePrice fromDictionary:dict] doubleValue];
            self.total = [[self objectOrNilForKey:kRentalBookingResponseTotal fromDictionary:dict] doubleValue];
            self.pickupLatLng = [LatLng modelObjectWithDictionary:[dict objectForKey:kRentalBookingResponsePickupLatLng]];
            self.extrasDisplay = [self objectOrNilForKey:kRentalBookingResponseExtrasDisplay fromDictionary:dict];
            self.payPalPaymentId = [self objectOrNilForKey:kRentalBookingResponsePayPalPaymentId fromDictionary:dict];
            self.carDisplay = [self objectOrNilForKey:kRentalBookingResponseCarDisplay fromDictionary:dict];
            self.carImage = [self objectOrNilForKey:kRentalBookingResponseCarImage fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.dropoffAddress forKey:kRentalBookingResponseDropoffAddress];
    [mutableDict setValue:self.displayName forKey:kRentalBookingResponseDisplayName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.carPrice] forKey:kRentalBookingResponseCarPrice];
    [mutableDict setValue:self.pickupAddress forKey:kRentalBookingResponsePickupAddress];
    [mutableDict setValue:self.pickupDate forKey:kRentalBookingResponsePickupDate];
    [mutableDict setValue:self.insuranceDisplay forKey:kRentalBookingResponseInsuranceDisplay];
    [mutableDict setValue:self.pickupTime forKey:kRentalBookingResponsePickupTime];
    [mutableDict setValue:self.dropoffTime forKey:kRentalBookingResponseDropoffTime];
    [mutableDict setValue:[self.dropoffLatLng dictionaryRepresentation] forKey:kRentalBookingResponseDropoffLatLng];
    [mutableDict setValue:self.dropoffDate forKey:kRentalBookingResponseDropoffDate];
    [mutableDict setValue:self.reservationCode forKey:kRentalBookingResponseReservationCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.extrasPrice] forKey:kRentalBookingResponseExtrasPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.insurancePrice] forKey:kRentalBookingResponseInsurancePrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kRentalBookingResponseTotal];
    [mutableDict setValue:[self.pickupLatLng dictionaryRepresentation] forKey:kRentalBookingResponsePickupLatLng];
    [mutableDict setValue:self.extrasDisplay forKey:kRentalBookingResponseExtrasDisplay];
    [mutableDict setValue:self.payPalPaymentId forKey:kRentalBookingResponsePayPalPaymentId];
    [mutableDict setValue:self.carDisplay forKey:kRentalBookingResponseCarDisplay];
    [mutableDict setValue:self.carImage forKey:kRentalBookingResponseCarImage];

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

    self.dropoffAddress = [aDecoder decodeObjectForKey:kRentalBookingResponseDropoffAddress];
    self.displayName = [aDecoder decodeObjectForKey:kRentalBookingResponseDisplayName];
    self.carPrice = [aDecoder decodeDoubleForKey:kRentalBookingResponseCarPrice];
    self.pickupAddress = [aDecoder decodeObjectForKey:kRentalBookingResponsePickupAddress];
    self.pickupDate = [aDecoder decodeObjectForKey:kRentalBookingResponsePickupDate];
    self.insuranceDisplay = [aDecoder decodeObjectForKey:kRentalBookingResponseInsuranceDisplay];
    self.pickupTime = [aDecoder decodeObjectForKey:kRentalBookingResponsePickupTime];
    self.dropoffTime = [aDecoder decodeObjectForKey:kRentalBookingResponseDropoffTime];
    self.dropoffLatLng = [aDecoder decodeObjectForKey:kRentalBookingResponseDropoffLatLng];
    self.dropoffDate = [aDecoder decodeObjectForKey:kRentalBookingResponseDropoffDate];
    self.reservationCode = [aDecoder decodeObjectForKey:kRentalBookingResponseReservationCode];
    self.extrasPrice = [aDecoder decodeDoubleForKey:kRentalBookingResponseExtrasPrice];
    self.insurancePrice = [aDecoder decodeDoubleForKey:kRentalBookingResponseInsurancePrice];
    self.total = [aDecoder decodeDoubleForKey:kRentalBookingResponseTotal];
    self.pickupLatLng = [aDecoder decodeObjectForKey:kRentalBookingResponsePickupLatLng];
    self.extrasDisplay = [aDecoder decodeObjectForKey:kRentalBookingResponseExtrasDisplay];
    self.payPalPaymentId = [aDecoder decodeObjectForKey:kRentalBookingResponsePayPalPaymentId];
    self.carDisplay = [aDecoder decodeObjectForKey:kRentalBookingResponseCarDisplay];
    self.carImage = [aDecoder decodeObjectForKey:kRentalBookingResponseCarImage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_dropoffAddress forKey:kRentalBookingResponseDropoffAddress];
    [aCoder encodeObject:_displayName forKey:kRentalBookingResponseDisplayName];
    [aCoder encodeDouble:_carPrice forKey:kRentalBookingResponseCarPrice];
    [aCoder encodeObject:_pickupAddress forKey:kRentalBookingResponsePickupAddress];
    [aCoder encodeObject:_pickupDate forKey:kRentalBookingResponsePickupDate];
    [aCoder encodeObject:_insuranceDisplay forKey:kRentalBookingResponseInsuranceDisplay];
    [aCoder encodeObject:_pickupTime forKey:kRentalBookingResponsePickupTime];
    [aCoder encodeObject:_dropoffTime forKey:kRentalBookingResponseDropoffTime];
    [aCoder encodeObject:_dropoffLatLng forKey:kRentalBookingResponseDropoffLatLng];
    [aCoder encodeObject:_dropoffDate forKey:kRentalBookingResponseDropoffDate];
    [aCoder encodeObject:_reservationCode forKey:kRentalBookingResponseReservationCode];
    [aCoder encodeDouble:_extrasPrice forKey:kRentalBookingResponseExtrasPrice];
    [aCoder encodeDouble:_insurancePrice forKey:kRentalBookingResponseInsurancePrice];
    [aCoder encodeDouble:_total forKey:kRentalBookingResponseTotal];
    [aCoder encodeObject:_pickupLatLng forKey:kRentalBookingResponsePickupLatLng];
    [aCoder encodeObject:_extrasDisplay forKey:kRentalBookingResponseExtrasDisplay];
    [aCoder encodeObject:_payPalPaymentId forKey:kRentalBookingResponsePayPalPaymentId];
    [aCoder encodeObject:_carDisplay forKey:kRentalBookingResponseCarDisplay];
    [aCoder encodeObject:_carImage forKey:kRentalBookingResponseCarImage];
}

- (id)copyWithZone:(NSZone *)zone {
    RentalBookingResponse *copy = [[RentalBookingResponse alloc] init];
    
    
    
    if (copy) {

        copy.dropoffAddress = [self.dropoffAddress copyWithZone:zone];
        copy.displayName = [self.displayName copyWithZone:zone];
        copy.carPrice = self.carPrice;
        copy.pickupAddress = [self.pickupAddress copyWithZone:zone];
        copy.pickupDate = [self.pickupDate copyWithZone:zone];
        copy.insuranceDisplay = [self.insuranceDisplay copyWithZone:zone];
        copy.pickupTime = [self.pickupTime copyWithZone:zone];
        copy.dropoffTime = [self.dropoffTime copyWithZone:zone];
        copy.dropoffLatLng = [self.dropoffLatLng copyWithZone:zone];
        copy.dropoffDate = [self.dropoffDate copyWithZone:zone];
        copy.reservationCode = [self.reservationCode copyWithZone:zone];
        copy.extrasPrice = self.extrasPrice;
        copy.insurancePrice = self.insurancePrice;
        copy.total = self.total;
        copy.pickupLatLng = [self.pickupLatLng copyWithZone:zone];
        copy.extrasDisplay = [self.extrasDisplay copyWithZone:zone];
        copy.payPalPaymentId = [self.payPalPaymentId copyWithZone:zone];
        copy.carDisplay = [self.carDisplay copyWithZone:zone];
        copy.carImage = [self.carImage copyWithZone:zone];
    }
    
    return copy;
}


@end
