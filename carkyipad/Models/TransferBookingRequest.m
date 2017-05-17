//
//  TransferBookingRequest.m
//
//  Created by   on 17/04/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "TransferBookingRequest.h"
#import "LatLng.h"
#import "Location.h"
#import "DateTime.h"

NSString *const kTransferBookingRequestUserId = @"UserId";
NSString *const kTransferBookingRequestDropoffAddress = @"DropoffAddress";
NSString *const kTransferBookingRequestDropoffWellKnownLocationId = @"DropoffWellKnownLocationId";
NSString *const kTransferBookingRequestPickupAddress = @"PickupAddress";
NSString *const kTransferBookingRequestStripeCardToken = @"StripeCardToken";
NSString *const kTransferBookingRequestPayPalPaymentResponse = @"PayPalPaymentResponse";
NSString *const kTransferBookingRequestPayPalPayerId = @"PayPalPayerId";
NSString *const kTransferBookingRequestPassengersNumber = @"PassengersNumber";
NSString *const kTransferBookingRequestDropoffLocation = @"DropoffLocation";
NSString *const kTransferBookingRequestAgreedToTermsAndConditions = @"AgreedToTermsAndConditions";
NSString *const kTransferBookingRequestAccountBindingModel = @"AccountBindingModel";
NSString *const kTransferBookingRequestDateTime = @"DateTime";
NSString *const kTransferBookingRequestPaymentMethod = @"PaymentMethod";
NSString *const kTransferBookingRequestPickupLatLng = @"PickupLatLng";
NSString *const kTransferBookingRequestPickupDateTime = @"PickupDateTime";
NSString *const kTransferBookingRequestExtras = @"Extras";
NSString *const kTransferBookingRequestCarkyCategoryId = @"CarkyCategoryId";
NSString *const kTransferBookingRequestLuggagePiecesNumber = @"LuggagePiecesNumber";


@interface TransferBookingRequest ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation TransferBookingRequest


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.userId = [self objectOrNilForKey:kTransferBookingRequestUserId fromDictionary:dict];
        self.dropoffWellKnownLocationId = [[self objectOrNilForKey:kTransferBookingRequestDropoffWellKnownLocationId fromDictionary:dict] integerValue];
        self.dropoffLocation = [Location modelObjectWithDictionary:[dict objectForKey:kTransferBookingRequestDropoffLocation]];
        self.pickupAddress = [self objectOrNilForKey:kTransferBookingRequestPickupAddress fromDictionary:dict];
        self.stripeCardToken = [self objectOrNilForKey:kTransferBookingRequestStripeCardToken fromDictionary:dict];
        self.payPalPaymentResponse = [self objectOrNilForKey:kTransferBookingRequestPayPalPaymentResponse fromDictionary:dict];
        self.payPalPayerId = [self objectOrNilForKey:kTransferBookingRequestPayPalPayerId fromDictionary:dict];

        self.passengersNumber = [[self objectOrNilForKey:kTransferBookingRequestPassengersNumber fromDictionary:dict] integerValue];
        self.agreedToTermsAndConditions = [[self objectOrNilForKey:kTransferBookingRequestAgreedToTermsAndConditions fromDictionary:dict] boolValue];
        
        self.dateTime = [self objectOrNilForKey:kTransferBookingRequestDateTime fromDictionary:dict];
        self.pickupDateTime = [DateTime modelObjectWithDictionary:[dict objectForKey:kTransferBookingRequestPickupDateTime]];
        self.paymentMethod = [[self objectOrNilForKey:kTransferBookingRequestPaymentMethod fromDictionary:dict] integerValue];
        self.pickupLatLng = [LatLng modelObjectWithDictionary:[dict objectForKey:kTransferBookingRequestPickupLatLng]];
        self.extras = [self objectOrNilForKey:kTransferBookingRequestExtras fromDictionary:dict];
        self.carkyCategoryId = [[self objectOrNilForKey:kTransferBookingRequestCarkyCategoryId fromDictionary:dict] integerValue];
        self.luggagePiecesNumber = [[self objectOrNilForKey:kTransferBookingRequestLuggagePiecesNumber fromDictionary:dict] integerValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.userId forKey:kTransferBookingRequestUserId];
    if(self.dropoffWellKnownLocationId > 0)
        [mutableDict setValue:[NSNumber numberWithInteger:self.dropoffWellKnownLocationId] forKey:kTransferBookingRequestDropoffWellKnownLocationId];
    else
        [mutableDict setValue:[self.dropoffLocation dictionaryRepresentation] forKey:kTransferBookingRequestDropoffLocation];

    [mutableDict setValue:self.stripeCardToken forKey:kTransferBookingRequestStripeCardToken];
    [mutableDict setValue:[NSNumber numberWithInteger:self.passengersNumber] forKey:kTransferBookingRequestPassengersNumber];
    [mutableDict setValue:[NSNumber numberWithBool:self.agreedToTermsAndConditions] forKey:kTransferBookingRequestAgreedToTermsAndConditions];
    [mutableDict setValue:self.payPalPaymentResponse forKey:kTransferBookingRequestPayPalPaymentResponse];
    [mutableDict setValue:self.payPalPayerId forKey:kTransferBookingRequestPayPalPayerId];

    [mutableDict setValue:self.dateTime forKey:kTransferBookingRequestDateTime];
    [mutableDict setValue:[self.pickupDateTime dictionaryRepresentation] forKey:kTransferBookingRequestPickupDateTime];
    [mutableDict setValue:[NSNumber numberWithInteger:self.paymentMethod] forKey:kTransferBookingRequestPaymentMethod];
    [mutableDict setValue:[self.pickupLatLng dictionaryRepresentation] forKey:kTransferBookingRequestPickupLatLng];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForExtras] forKey:kTransferBookingRequestExtras];
    [mutableDict setValue:[NSNumber numberWithInteger:self.carkyCategoryId] forKey:kTransferBookingRequestCarkyCategoryId];
    [mutableDict setValue:[NSNumber numberWithInteger:self.luggagePiecesNumber] forKey:kTransferBookingRequestLuggagePiecesNumber];

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

    self.dropoffAddress = [aDecoder decodeObjectForKey:kTransferBookingRequestDropoffAddress];
    self.pickupAddress = [aDecoder decodeObjectForKey:kTransferBookingRequestPickupAddress];
    self.stripeCardToken = [aDecoder decodeObjectForKey:kTransferBookingRequestStripeCardToken];
    self.passengersNumber = [aDecoder decodeIntegerForKey:kTransferBookingRequestPassengersNumber];
    self.agreedToTermsAndConditions = [aDecoder decodeBoolForKey:kTransferBookingRequestAgreedToTermsAndConditions];
    //self.accountBindingModel = [aDecoder decodeObjectForKey:kTransferBookingRequestAccountBindingModel];
    self.dateTime = [aDecoder decodeObjectForKey:kTransferBookingRequestDateTime];
    self.paymentMethod = [aDecoder decodeIntegerForKey:kTransferBookingRequestPaymentMethod];
    self.pickupLatLng = [aDecoder decodeObjectForKey:kTransferBookingRequestPickupLatLng];
    self.extras = [aDecoder decodeObjectForKey:kTransferBookingRequestExtras];
    self.carkyCategoryId = [aDecoder decodeIntegerForKey:kTransferBookingRequestCarkyCategoryId];
    self.luggagePiecesNumber = [aDecoder decodeIntegerForKey:kTransferBookingRequestLuggagePiecesNumber];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_dropoffAddress forKey:kTransferBookingRequestDropoffAddress];
    [aCoder encodeObject:_pickupAddress forKey:kTransferBookingRequestPickupAddress];
    [aCoder encodeObject:_stripeCardToken forKey:kTransferBookingRequestStripeCardToken];
    [aCoder encodeInteger:_passengersNumber forKey:kTransferBookingRequestPassengersNumber];
    [aCoder encodeBool:_agreedToTermsAndConditions forKey:kTransferBookingRequestAgreedToTermsAndConditions];
    //[aCoder encodeObject:_accountBindingModel forKey:kTransferBookingRequestAccountBindingModel];
    [aCoder encodeObject:_dateTime forKey:kTransferBookingRequestDateTime];
    [aCoder encodeInteger:_paymentMethod forKey:kTransferBookingRequestPaymentMethod];
    [aCoder encodeObject:_pickupLatLng forKey:kTransferBookingRequestPickupLatLng];
    [aCoder encodeObject:_extras forKey:kTransferBookingRequestExtras];
    [aCoder encodeInteger:_carkyCategoryId forKey:kTransferBookingRequestCarkyCategoryId];
    [aCoder encodeInteger:_luggagePiecesNumber forKey:kTransferBookingRequestLuggagePiecesNumber];
}

- (id)copyWithZone:(NSZone *)zone {
    TransferBookingRequest *copy = [[TransferBookingRequest alloc] init];
    
    
    
    if (copy) {

        copy.dropoffAddress = [self.dropoffAddress copyWithZone:zone];
        copy.pickupAddress = [self.pickupAddress copyWithZone:zone];
        copy.stripeCardToken = [self.stripeCardToken copyWithZone:zone];
        copy.passengersNumber = self.passengersNumber;
        copy.agreedToTermsAndConditions = self.agreedToTermsAndConditions;
        //copy.accountBindingModel = [self.accountBindingModel copyWithZone:zone];
        copy.dateTime = [self.dateTime copyWithZone:zone];
        copy.paymentMethod = self.paymentMethod;
        copy.pickupLatLng = [self.pickupLatLng copyWithZone:zone];
        copy.extras = [self.extras copyWithZone:zone];
        copy.carkyCategoryId = self.carkyCategoryId;
        copy.luggagePiecesNumber = self.luggagePiecesNumber;
    }
    
    return copy;
}


@end
