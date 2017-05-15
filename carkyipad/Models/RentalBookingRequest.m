//
//  RentalBookingRequest.m
//
//  Created by   on 15/05/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "RentalBookingRequest.h"
#import "LatLng.h"

NSString *const kRentalBookingRequestDropoffAddress = @"DropoffAddress";
NSString *const kRentalBookingRequestPickupAddress = @"PickupAddress";
NSString *const kRentalBookingRequestWellKnowPickupLocationId = @"WellKnowPickupLocationId";
NSString *const kRentalBookingRequestCarInsuranceId = @"CarInsuranceId";
NSString *const kRentalBookingRequestCommission = @"Commission";
NSString *const kRentalBookingRequestFleetLocationId = @"FleetLocationId";
NSString *const kRentalBookingRequestPickupTime = @"PickupTime";
NSString *const kRentalBookingRequestUserId = @"UserId";
NSString *const kRentalBookingRequestDropoffLatLng = @"DropoffLatLng";
NSString *const kRentalBookingRequestDropoffTime = @"DropoffTime";
NSString *const kRentalBookingRequestWellKnowDropoffLocationId = @"WellKnowDropoffLocationId";
NSString *const kRentalBookingRequestDropoffDate = @"DropoffDate";
NSString *const kRentalBookingRequestStripeCardId = @"StripeCardId";
NSString *const kRentalBookingRequestAgreedToTermsAndConditions = @"AgreedToTermsAndConditions";
NSString *const kRentalBookingRequestPickupLatLng = @"PickupLatLng";
NSString *const kRentalBookingRequestPaymentMethod = @"PaymentMethod";
NSString *const kRentalBookingRequestExtras = @"Extras";
NSString *const kRentalBookingRequestCarTypeId = @"CarTypeId";
NSString *const kRentalBookingRequestPickupDate = @"PickupDate";


@interface RentalBookingRequest ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RentalBookingRequest

@synthesize dropoffAddress = _dropoffAddress;
@synthesize pickupAddress = _pickupAddress;
@synthesize wellKnowPickupLocationId = _wellKnowPickupLocationId;
@synthesize carInsuranceId = _carInsuranceId;
@synthesize commission = _commission;
@synthesize fleetLocationId = _fleetLocationId;
@synthesize pickupTime = _pickupTime;
@synthesize userId = _userId;
@synthesize dropoffLatLng = _dropoffLatLng;
@synthesize dropoffTime = _dropoffTime;
@synthesize wellKnowDropoffLocationId = _wellKnowDropoffLocationId;
@synthesize dropoffDate = _dropoffDate;
@synthesize stripeCardId = _stripeCardId;
@synthesize agreedToTermsAndConditions = _agreedToTermsAndConditions;
@synthesize pickupLatLng = _pickupLatLng;
@synthesize paymentMethod = _paymentMethod;
@synthesize extras = _extras;
@synthesize carTypeId = _carTypeId;
@synthesize pickupDate = _pickupDate;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.dropoffAddress = [self objectOrNilForKey:kRentalBookingRequestDropoffAddress fromDictionary:dict];
            self.pickupAddress = [self objectOrNilForKey:kRentalBookingRequestPickupAddress fromDictionary:dict];
            self.wellKnowPickupLocationId = [[self objectOrNilForKey:kRentalBookingRequestWellKnowPickupLocationId fromDictionary:dict] integerValue];
            self.carInsuranceId = [[self objectOrNilForKey:kRentalBookingRequestCarInsuranceId fromDictionary:dict] integerValue];
            self.commission = [[self objectOrNilForKey:kRentalBookingRequestCommission fromDictionary:dict] integerValue];
            self.fleetLocationId = [[self objectOrNilForKey:kRentalBookingRequestFleetLocationId fromDictionary:dict] integerValue];
            self.pickupTime = [self objectOrNilForKey:kRentalBookingRequestPickupTime fromDictionary:dict];
            self.userId = [self objectOrNilForKey:kRentalBookingRequestUserId fromDictionary:dict];
            self.dropoffLatLng = [LatLng modelObjectWithDictionary:[dict objectForKey:kRentalBookingRequestDropoffLatLng]];
            self.dropoffTime = [self objectOrNilForKey:kRentalBookingRequestDropoffTime fromDictionary:dict];
            self.wellKnowDropoffLocationId = [[self objectOrNilForKey:kRentalBookingRequestWellKnowDropoffLocationId fromDictionary:dict] integerValue];
            self.dropoffDate = [self objectOrNilForKey:kRentalBookingRequestDropoffDate fromDictionary:dict];
            self.stripeCardId = [self objectOrNilForKey:kRentalBookingRequestStripeCardId fromDictionary:dict];
            self.agreedToTermsAndConditions = [[self objectOrNilForKey:kRentalBookingRequestAgreedToTermsAndConditions fromDictionary:dict] boolValue];
            self.pickupLatLng = [LatLng modelObjectWithDictionary:[dict objectForKey:kRentalBookingRequestPickupLatLng]];
            self.paymentMethod = [[self objectOrNilForKey:kRentalBookingRequestPaymentMethod fromDictionary:dict] integerValue];
            self.extras = [self objectOrNilForKey:kRentalBookingRequestExtras fromDictionary:dict];
            self.carTypeId = [[self objectOrNilForKey:kRentalBookingRequestCarTypeId fromDictionary:dict] integerValue];
            self.pickupDate = [self objectOrNilForKey:kRentalBookingRequestPickupDate fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.dropoffAddress forKey:kRentalBookingRequestDropoffAddress];
    [mutableDict setValue:self.pickupAddress forKey:kRentalBookingRequestPickupAddress];
    [mutableDict setValue:[NSNumber numberWithInteger:self.wellKnowPickupLocationId] forKey:kRentalBookingRequestWellKnowPickupLocationId];
    [mutableDict setValue:[NSNumber numberWithInteger:self.carInsuranceId] forKey:kRentalBookingRequestCarInsuranceId];
    [mutableDict setValue:[NSNumber numberWithInteger:self.commission] forKey:kRentalBookingRequestCommission];
    [mutableDict setValue:[NSNumber numberWithInteger:self.fleetLocationId] forKey:kRentalBookingRequestFleetLocationId];
    [mutableDict setValue:self.pickupTime forKey:kRentalBookingRequestPickupTime];
    [mutableDict setValue:self.userId forKey:kRentalBookingRequestUserId];
    [mutableDict setValue:[self.dropoffLatLng dictionaryRepresentation] forKey:kRentalBookingRequestDropoffLatLng];
    [mutableDict setValue:self.dropoffTime forKey:kRentalBookingRequestDropoffTime];
    [mutableDict setValue:[NSNumber numberWithInteger:self.wellKnowDropoffLocationId] forKey:kRentalBookingRequestWellKnowDropoffLocationId];
    [mutableDict setValue:self.dropoffDate forKey:kRentalBookingRequestDropoffDate];
    [mutableDict setValue:self.stripeCardId forKey:kRentalBookingRequestStripeCardId];
    [mutableDict setValue:[NSNumber numberWithBool:self.agreedToTermsAndConditions] forKey:kRentalBookingRequestAgreedToTermsAndConditions];
    [mutableDict setValue:[self.pickupLatLng dictionaryRepresentation] forKey:kRentalBookingRequestPickupLatLng];
    [mutableDict setValue:[NSNumber numberWithInteger:self.paymentMethod] forKey:kRentalBookingRequestPaymentMethod];
    NSMutableArray *tempArrayForExtras = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.extras) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForExtras addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForExtras addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForExtras] forKey:kRentalBookingRequestExtras];
    [mutableDict setValue:[NSNumber numberWithInteger:self.carTypeId] forKey:kRentalBookingRequestCarTypeId];
    [mutableDict setValue:self.pickupDate forKey:kRentalBookingRequestPickupDate];

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

    self.dropoffAddress = [aDecoder decodeObjectForKey:kRentalBookingRequestDropoffAddress];
    self.pickupAddress = [aDecoder decodeObjectForKey:kRentalBookingRequestPickupAddress];
    self.wellKnowPickupLocationId = [aDecoder decodeDoubleForKey:kRentalBookingRequestWellKnowPickupLocationId];
    self.carInsuranceId = [aDecoder decodeDoubleForKey:kRentalBookingRequestCarInsuranceId];
    self.commission = [aDecoder decodeDoubleForKey:kRentalBookingRequestCommission];
    self.fleetLocationId = [aDecoder decodeDoubleForKey:kRentalBookingRequestFleetLocationId];
    self.pickupTime = [aDecoder decodeObjectForKey:kRentalBookingRequestPickupTime];
    self.userId = [aDecoder decodeObjectForKey:kRentalBookingRequestUserId];
    self.dropoffLatLng = [aDecoder decodeObjectForKey:kRentalBookingRequestDropoffLatLng];
    self.dropoffTime = [aDecoder decodeObjectForKey:kRentalBookingRequestDropoffTime];
    self.wellKnowDropoffLocationId = [aDecoder decodeDoubleForKey:kRentalBookingRequestWellKnowDropoffLocationId];
    self.dropoffDate = [aDecoder decodeObjectForKey:kRentalBookingRequestDropoffDate];
    self.stripeCardId = [aDecoder decodeObjectForKey:kRentalBookingRequestStripeCardId];
    self.agreedToTermsAndConditions = [aDecoder decodeBoolForKey:kRentalBookingRequestAgreedToTermsAndConditions];
    self.pickupLatLng = [aDecoder decodeObjectForKey:kRentalBookingRequestPickupLatLng];
    self.paymentMethod = [aDecoder decodeDoubleForKey:kRentalBookingRequestPaymentMethod];
    self.extras = [aDecoder decodeObjectForKey:kRentalBookingRequestExtras];
    self.carTypeId = [aDecoder decodeDoubleForKey:kRentalBookingRequestCarTypeId];
    self.pickupDate = [aDecoder decodeObjectForKey:kRentalBookingRequestPickupDate];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_dropoffAddress forKey:kRentalBookingRequestDropoffAddress];
    [aCoder encodeObject:_pickupAddress forKey:kRentalBookingRequestPickupAddress];
    [aCoder encodeDouble:_wellKnowPickupLocationId forKey:kRentalBookingRequestWellKnowPickupLocationId];
    [aCoder encodeDouble:_carInsuranceId forKey:kRentalBookingRequestCarInsuranceId];
    [aCoder encodeDouble:_commission forKey:kRentalBookingRequestCommission];
    [aCoder encodeDouble:_fleetLocationId forKey:kRentalBookingRequestFleetLocationId];
    [aCoder encodeObject:_pickupTime forKey:kRentalBookingRequestPickupTime];
    [aCoder encodeObject:_userId forKey:kRentalBookingRequestUserId];
    [aCoder encodeObject:_dropoffLatLng forKey:kRentalBookingRequestDropoffLatLng];
    [aCoder encodeObject:_dropoffTime forKey:kRentalBookingRequestDropoffTime];
    [aCoder encodeDouble:_wellKnowDropoffLocationId forKey:kRentalBookingRequestWellKnowDropoffLocationId];
    [aCoder encodeObject:_dropoffDate forKey:kRentalBookingRequestDropoffDate];
    [aCoder encodeObject:_stripeCardId forKey:kRentalBookingRequestStripeCardId];
    [aCoder encodeBool:_agreedToTermsAndConditions forKey:kRentalBookingRequestAgreedToTermsAndConditions];
    [aCoder encodeObject:_pickupLatLng forKey:kRentalBookingRequestPickupLatLng];
    [aCoder encodeDouble:_paymentMethod forKey:kRentalBookingRequestPaymentMethod];
    [aCoder encodeObject:_extras forKey:kRentalBookingRequestExtras];
    [aCoder encodeDouble:_carTypeId forKey:kRentalBookingRequestCarTypeId];
    [aCoder encodeObject:_pickupDate forKey:kRentalBookingRequestPickupDate];
}

- (id)copyWithZone:(NSZone *)zone {
    RentalBookingRequest *copy = [[RentalBookingRequest alloc] init];
    
    
    
    if (copy) {

        copy.dropoffAddress = [self.dropoffAddress copyWithZone:zone];
        copy.pickupAddress = [self.pickupAddress copyWithZone:zone];
        copy.wellKnowPickupLocationId = self.wellKnowPickupLocationId;
        copy.carInsuranceId = self.carInsuranceId;
        copy.commission = self.commission;
        copy.fleetLocationId = self.fleetLocationId;
        copy.pickupTime = [self.pickupTime copyWithZone:zone];
        copy.userId = [self.userId copyWithZone:zone];
        copy.dropoffLatLng = [self.dropoffLatLng copyWithZone:zone];
        copy.dropoffTime = [self.dropoffTime copyWithZone:zone];
        copy.wellKnowDropoffLocationId = self.wellKnowDropoffLocationId;
        copy.dropoffDate = [self.dropoffDate copyWithZone:zone];
        copy.stripeCardId = [self.stripeCardId copyWithZone:zone];
        copy.agreedToTermsAndConditions = self.agreedToTermsAndConditions;
        copy.pickupLatLng = [self.pickupLatLng copyWithZone:zone];
        copy.paymentMethod = self.paymentMethod;
        copy.extras = [self.extras copyWithZone:zone];
        copy.carTypeId = self.carTypeId;
        copy.pickupDate = [self.pickupDate copyWithZone:zone];
    }
    
    return copy;
}


@end
