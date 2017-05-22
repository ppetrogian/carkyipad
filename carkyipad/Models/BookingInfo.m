//
//  BookingInfo.m
//
//  Created by   on 17/05/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "BookingInfo.h"
#import "DateTime.h"
#import "Location.h"


NSString *const kBookingInfoWellKnownDropoffLocationId = @"WellKnownDropoffLocationId";
NSString *const kBookingInfoCarTypeId = @"CarTypeId";
NSString *const kBookingInfoInsuranceId = @"InsuranceId";
NSString *const kBookingInfoCommission = @"Commission";
NSString *const kBookingInfoFleetLocationId = @"FleetLocationId";
NSString *const kBookingInfoAgreedToTermsAndConditions = @"AgreedToTermsAndConditions";
NSString *const kBookingInfoPickupDateTime = @"PickupDateTime";
NSString *const kBookingInfoPickupLocation = @"PickupLocation";
NSString *const kBookingInfoDropoffDateTime = @"DropoffDateTime";
NSString *const kBookingInfoWellKnownPickupLocationId = @"WellKnownPickupLocationId";
NSString *const kBookingInfoExtraIds = @"ExtraIds";
NSString *const kBookingInfoDropoffLocation = @"DropoffLocation";


@interface BookingInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BookingInfo

@synthesize wellKnownDropoffLocationId = _wellKnownDropoffLocationId;
@synthesize carTypeId = _carTypeId;
@synthesize insuranceId = _insuranceId;
@synthesize commission = _commission;
@synthesize fleetLocationId = _fleetLocationId;
@synthesize agreedToTermsAndConditions = _agreedToTermsAndConditions;
@synthesize pickupDateTime = _pickupDateTime;
@synthesize pickupLocation = _pickupLocation;
@synthesize dropoffDateTime = _dropoffDateTime;
@synthesize wellKnownPickupLocationId = _wellKnownPickupLocationId;
@synthesize extraIds = _extraIds;
@synthesize dropoffLocation = _dropoffLocation;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.wellKnownDropoffLocationId = [[self objectOrNilForKey:kBookingInfoWellKnownDropoffLocationId fromDictionary:dict] integerValue];
            self.carTypeId = [[self objectOrNilForKey:kBookingInfoCarTypeId fromDictionary:dict] integerValue];
            self.insuranceId = [[self objectOrNilForKey:kBookingInfoInsuranceId fromDictionary:dict] integerValue];
            self.commission = [[self objectOrNilForKey:kBookingInfoCommission fromDictionary:dict] integerValue];
            self.fleetLocationId = [[self objectOrNilForKey:kBookingInfoFleetLocationId fromDictionary:dict] integerValue];
            self.agreedToTermsAndConditions = [[self objectOrNilForKey:kBookingInfoAgreedToTermsAndConditions fromDictionary:dict] boolValue];
            self.pickupDateTime = [DateTime modelObjectWithDictionary:[dict objectForKey:kBookingInfoPickupDateTime]];
            self.pickupLocation = [Location modelObjectWithDictionary:[dict objectForKey:kBookingInfoPickupLocation]];
            self.dropoffDateTime = [DateTime modelObjectWithDictionary:[dict objectForKey:kBookingInfoDropoffDateTime]];
            self.wellKnownPickupLocationId = [[self objectOrNilForKey:kBookingInfoWellKnownPickupLocationId fromDictionary:dict] integerValue];
            self.extraIds = [self objectOrNilForKey:kBookingInfoExtraIds fromDictionary:dict];
            self.dropoffLocation = [Location modelObjectWithDictionary:[dict objectForKey:kBookingInfoDropoffLocation]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    if(self.wellKnownDropoffLocationId > 0)
        [mutableDict setValue:[NSNumber numberWithInteger:self.wellKnownDropoffLocationId] forKey:kBookingInfoWellKnownDropoffLocationId];
    [mutableDict setValue:[NSNumber numberWithInteger:self.carTypeId] forKey:kBookingInfoCarTypeId];
    if(self.insuranceId > 0)
        [mutableDict setValue:[NSNumber numberWithInteger:self.insuranceId] forKey:kBookingInfoInsuranceId];
    [mutableDict setValue:[NSNumber numberWithInteger:self.commission] forKey:kBookingInfoCommission];
    if(self.fleetLocationId > 0)
        [mutableDict setValue:[NSNumber numberWithInteger:self.fleetLocationId] forKey:kBookingInfoFleetLocationId];
    [mutableDict setValue:[NSNumber numberWithBool:self.agreedToTermsAndConditions] forKey:kBookingInfoAgreedToTermsAndConditions];
    [mutableDict setValue:[self.pickupDateTime dictionaryRepresentation] forKey:kBookingInfoPickupDateTime];
    if(self.pickupLocation)
        [mutableDict setValue:[self.pickupLocation dictionaryRepresentation] forKey:kBookingInfoPickupLocation];
    [mutableDict setValue:[self.dropoffDateTime dictionaryRepresentation] forKey:kBookingInfoDropoffDateTime];
    if(self.wellKnownPickupLocationId > 0)
        [mutableDict setValue:[NSNumber numberWithInteger:self.wellKnownPickupLocationId] forKey:kBookingInfoWellKnownPickupLocationId];
    NSMutableArray *tempArrayForExtraIds = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.extraIds) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForExtraIds addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForExtraIds addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForExtraIds] forKey:kBookingInfoExtraIds];
    if(self.dropoffLocation)
        [mutableDict setValue:[self.dropoffLocation dictionaryRepresentation] forKey:kBookingInfoDropoffLocation];

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

    self.wellKnownDropoffLocationId = [aDecoder decodeDoubleForKey:kBookingInfoWellKnownDropoffLocationId];
    self.carTypeId = [aDecoder decodeDoubleForKey:kBookingInfoCarTypeId];
    self.insuranceId = [aDecoder decodeDoubleForKey:kBookingInfoInsuranceId];
    self.commission = [aDecoder decodeDoubleForKey:kBookingInfoCommission];
    self.fleetLocationId = [aDecoder decodeDoubleForKey:kBookingInfoFleetLocationId];
    self.agreedToTermsAndConditions = [aDecoder decodeBoolForKey:kBookingInfoAgreedToTermsAndConditions];
    self.pickupDateTime = [aDecoder decodeObjectForKey:kBookingInfoPickupDateTime];
    self.pickupLocation = [aDecoder decodeObjectForKey:kBookingInfoPickupLocation];
    self.dropoffDateTime = [aDecoder decodeObjectForKey:kBookingInfoDropoffDateTime];
    self.wellKnownPickupLocationId = [aDecoder decodeDoubleForKey:kBookingInfoWellKnownPickupLocationId];
    self.extraIds = [aDecoder decodeObjectForKey:kBookingInfoExtraIds];
    self.dropoffLocation = [aDecoder decodeObjectForKey:kBookingInfoDropoffLocation];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_wellKnownDropoffLocationId forKey:kBookingInfoWellKnownDropoffLocationId];
    [aCoder encodeDouble:_carTypeId forKey:kBookingInfoCarTypeId];
    [aCoder encodeDouble:_insuranceId forKey:kBookingInfoInsuranceId];
    [aCoder encodeDouble:_commission forKey:kBookingInfoCommission];
    [aCoder encodeDouble:_fleetLocationId forKey:kBookingInfoFleetLocationId];
    [aCoder encodeBool:_agreedToTermsAndConditions forKey:kBookingInfoAgreedToTermsAndConditions];
    [aCoder encodeObject:_pickupDateTime forKey:kBookingInfoPickupDateTime];
    [aCoder encodeObject:_pickupLocation forKey:kBookingInfoPickupLocation];
    [aCoder encodeObject:_dropoffDateTime forKey:kBookingInfoDropoffDateTime];
    [aCoder encodeDouble:_wellKnownPickupLocationId forKey:kBookingInfoWellKnownPickupLocationId];
    [aCoder encodeObject:_extraIds forKey:kBookingInfoExtraIds];
    [aCoder encodeObject:_dropoffLocation forKey:kBookingInfoDropoffLocation];
}

- (id)copyWithZone:(NSZone *)zone {
    BookingInfo *copy = [[BookingInfo alloc] init];
    
    
    
    if (copy) {

        copy.wellKnownDropoffLocationId = self.wellKnownDropoffLocationId;
        copy.carTypeId = self.carTypeId;
        copy.insuranceId = self.insuranceId;
        copy.commission = self.commission;
        copy.fleetLocationId = self.fleetLocationId;
        copy.agreedToTermsAndConditions = self.agreedToTermsAndConditions;
        copy.pickupDateTime = [self.pickupDateTime copyWithZone:zone];
        copy.pickupLocation = [self.pickupLocation copyWithZone:zone];
        copy.dropoffDateTime = [self.dropoffDateTime copyWithZone:zone];
        copy.wellKnownPickupLocationId = self.wellKnownPickupLocationId;
        copy.extraIds = [self.extraIds copyWithZone:zone];
        copy.dropoffLocation = [self.dropoffLocation copyWithZone:zone];
    }
    
    return copy;
}


@end
