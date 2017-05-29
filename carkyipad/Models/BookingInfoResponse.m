//
//  BookingInfoResponse.m
//
//  Created by   on 19/5/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "BookingInfoResponse.h"
#import "LatLng.h"


NSString *const kBookingInfoDropoffAddress = @"DropoffAddress";
NSString *const kBookingInfoDisplayName = @"DisplayName";
NSString *const kBookingInfoCarPrice = @"CarPrice";
NSString *const kBookingInfoPickupAddress = @"PickupAddress";
NSString *const kBookingInfoCarImage = @"CarImage";
NSString *const kBookingInfoInsuranceDisplay = @"InsuranceDisplay";
NSString *const kBookingInfoPickupTime = @"PickupTime";
NSString *const kBookingInfoDropoffTime = @"DropoffTime";
NSString *const kBookingInfoDropoffLatLng = @"DropoffLatLng";
NSString *const kBookingInfoDropoffDate = @"DropoffDate";
NSString *const kBookingInfoReservationCode = @"ReservationCode";
NSString *const kBookingInfoExtrasPrice = @"ExtrasPrice";
NSString *const kBookingInfoInsurancePrice = @"InsurancePrice";
NSString *const kBookingInfoTotal = @"Total";
NSString *const kBookingInfoPickupLatLng = @"PickupLatLng";
NSString *const kBookingInfoExtrasDisplay = @"ExtrasDisplay";
NSString *const kBookingInfoPickupDate = @"PickupDate";
NSString *const kBookingInfoCarDisplay = @"CarDisplay";
NSString *const kBookingInfoActualDurationInDays = @"ActualDurationInDays";
NSString *const kBookingInfoPricingDurationInDays = @"PricingDurationInDays";

@interface BookingInfoResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BookingInfoResponse

@synthesize dropoffAddress = _dropoffAddress;
@synthesize displayName = _displayName;
@synthesize carPrice = _carPrice;
@synthesize pickupAddress = _pickupAddress;
@synthesize carImage = _carImage;
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
@synthesize pickupDate = _pickupDate;
@synthesize carDisplay = _carDisplay;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.dropoffAddress = [self objectOrNilForKey:kBookingInfoDropoffAddress fromDictionary:dict];
        self.displayName = [self objectOrNilForKey:kBookingInfoDisplayName fromDictionary:dict];
        self.carPrice = [[self objectOrNilForKey:kBookingInfoCarPrice fromDictionary:dict] doubleValue];
        self.pickupAddress = [self objectOrNilForKey:kBookingInfoPickupAddress fromDictionary:dict];
        self.carImage = [self objectOrNilForKey:kBookingInfoCarImage fromDictionary:dict];
        self.insuranceDisplay = [self objectOrNilForKey:kBookingInfoInsuranceDisplay fromDictionary:dict];
        self.pickupTime = [self objectOrNilForKey:kBookingInfoPickupTime fromDictionary:dict];
        self.dropoffTime = [self objectOrNilForKey:kBookingInfoDropoffTime fromDictionary:dict];
        self.dropoffLatLng = [LatLng modelObjectWithDictionary:[dict objectForKey:kBookingInfoDropoffLatLng]];
        self.dropoffDate = [self objectOrNilForKey:kBookingInfoDropoffDate fromDictionary:dict];
        self.reservationCode = [self objectOrNilForKey:kBookingInfoReservationCode fromDictionary:dict];
        self.extrasPrice = [[self objectOrNilForKey:kBookingInfoExtrasPrice fromDictionary:dict] doubleValue];
        self.insurancePrice = [[self objectOrNilForKey:kBookingInfoInsurancePrice fromDictionary:dict] doubleValue];
        self.total = [[self objectOrNilForKey:kBookingInfoTotal fromDictionary:dict] doubleValue];
        self.pickupLatLng = [LatLng modelObjectWithDictionary:[dict objectForKey:kBookingInfoPickupLatLng]];
        self.extrasDisplay = [self objectOrNilForKey:kBookingInfoExtrasDisplay fromDictionary:dict];
        self.pickupDate = [self objectOrNilForKey:kBookingInfoPickupDate fromDictionary:dict];
        self.carDisplay = [self objectOrNilForKey:kBookingInfoCarDisplay fromDictionary:dict];
        self.actualDurationInDays = [[self objectOrNilForKey:kBookingInfoActualDurationInDays fromDictionary:dict] doubleValue];
        self.pricingDurationInDays = [[self objectOrNilForKey:kBookingInfoPricingDurationInDays fromDictionary:dict] doubleValue];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.dropoffAddress forKey:kBookingInfoDropoffAddress];
    [mutableDict setValue:self.displayName forKey:kBookingInfoDisplayName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.carPrice] forKey:kBookingInfoCarPrice];
    [mutableDict setValue:self.pickupAddress forKey:kBookingInfoPickupAddress];
    [mutableDict setValue:self.carImage forKey:kBookingInfoCarImage];
    [mutableDict setValue:self.insuranceDisplay forKey:kBookingInfoInsuranceDisplay];
    [mutableDict setValue:self.pickupTime forKey:kBookingInfoPickupTime];
    [mutableDict setValue:self.dropoffTime forKey:kBookingInfoDropoffTime];
    [mutableDict setValue:[self.dropoffLatLng dictionaryRepresentation] forKey:kBookingInfoDropoffLatLng];
    [mutableDict setValue:self.dropoffDate forKey:kBookingInfoDropoffDate];
    [mutableDict setValue:self.reservationCode forKey:kBookingInfoReservationCode];
    [mutableDict setValue:[NSNumber numberWithDouble:self.extrasPrice] forKey:kBookingInfoExtrasPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.insurancePrice] forKey:kBookingInfoInsurancePrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kBookingInfoTotal];
    [mutableDict setValue:[self.pickupLatLng dictionaryRepresentation] forKey:kBookingInfoPickupLatLng];
    [mutableDict setValue:self.extrasDisplay forKey:kBookingInfoExtrasDisplay];
    [mutableDict setValue:self.pickupDate forKey:kBookingInfoPickupDate];
    [mutableDict setValue:self.carDisplay forKey:kBookingInfoCarDisplay];
    [mutableDict setValue:[NSNumber numberWithDouble:self.actualDurationInDays] forKey:kBookingInfoActualDurationInDays];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pricingDurationInDays] forKey:kBookingInfoPricingDurationInDays];

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

    self.dropoffAddress = [aDecoder decodeObjectForKey:kBookingInfoDropoffAddress];
    self.displayName = [aDecoder decodeObjectForKey:kBookingInfoDisplayName];
    self.carPrice = [aDecoder decodeDoubleForKey:kBookingInfoCarPrice];
    self.pickupAddress = [aDecoder decodeObjectForKey:kBookingInfoPickupAddress];
    self.carImage = [aDecoder decodeObjectForKey:kBookingInfoCarImage];
    self.insuranceDisplay = [aDecoder decodeObjectForKey:kBookingInfoInsuranceDisplay];
    self.pickupTime = [aDecoder decodeObjectForKey:kBookingInfoPickupTime];
    self.dropoffTime = [aDecoder decodeObjectForKey:kBookingInfoDropoffTime];
    self.dropoffLatLng = [aDecoder decodeObjectForKey:kBookingInfoDropoffLatLng];
    self.dropoffDate = [aDecoder decodeObjectForKey:kBookingInfoDropoffDate];
    self.reservationCode = [aDecoder decodeObjectForKey:kBookingInfoReservationCode];
    self.extrasPrice = [aDecoder decodeDoubleForKey:kBookingInfoExtrasPrice];
    self.insurancePrice = [aDecoder decodeDoubleForKey:kBookingInfoInsurancePrice];
    self.total = [aDecoder decodeDoubleForKey:kBookingInfoTotal];
    self.pickupLatLng = [aDecoder decodeObjectForKey:kBookingInfoPickupLatLng];
    self.extrasDisplay = [aDecoder decodeObjectForKey:kBookingInfoExtrasDisplay];
    self.pickupDate = [aDecoder decodeObjectForKey:kBookingInfoPickupDate];
    self.carDisplay = [aDecoder decodeObjectForKey:kBookingInfoCarDisplay];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_dropoffAddress forKey:kBookingInfoDropoffAddress];
    [aCoder encodeObject:_displayName forKey:kBookingInfoDisplayName];
    [aCoder encodeDouble:_carPrice forKey:kBookingInfoCarPrice];
    [aCoder encodeObject:_pickupAddress forKey:kBookingInfoPickupAddress];
    [aCoder encodeObject:_carImage forKey:kBookingInfoCarImage];
    [aCoder encodeObject:_insuranceDisplay forKey:kBookingInfoInsuranceDisplay];
    [aCoder encodeObject:_pickupTime forKey:kBookingInfoPickupTime];
    [aCoder encodeObject:_dropoffTime forKey:kBookingInfoDropoffTime];
    [aCoder encodeObject:_dropoffLatLng forKey:kBookingInfoDropoffLatLng];
    [aCoder encodeObject:_dropoffDate forKey:kBookingInfoDropoffDate];
    [aCoder encodeObject:_reservationCode forKey:kBookingInfoReservationCode];
    [aCoder encodeDouble:_extrasPrice forKey:kBookingInfoExtrasPrice];
    [aCoder encodeDouble:_insurancePrice forKey:kBookingInfoInsurancePrice];
    [aCoder encodeDouble:_total forKey:kBookingInfoTotal];
    [aCoder encodeObject:_pickupLatLng forKey:kBookingInfoPickupLatLng];
    [aCoder encodeObject:_extrasDisplay forKey:kBookingInfoExtrasDisplay];
    [aCoder encodeObject:_pickupDate forKey:kBookingInfoPickupDate];
    [aCoder encodeObject:_carDisplay forKey:kBookingInfoCarDisplay];
}

- (id)copyWithZone:(NSZone *)zone {
    BookingInfoResponse *copy = [[BookingInfoResponse alloc] init];
    
    
    
    if (copy) {

        copy.dropoffAddress = [self.dropoffAddress copyWithZone:zone];
        copy.displayName = [self.displayName copyWithZone:zone];
        copy.carPrice = self.carPrice;
        copy.pickupAddress = [self.pickupAddress copyWithZone:zone];
        copy.carImage = [self.carImage copyWithZone:zone];
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
        copy.pickupDate = [self.pickupDate copyWithZone:zone];
        copy.carDisplay = [self.carDisplay copyWithZone:zone];
    }
    
    return copy;
}


@end
