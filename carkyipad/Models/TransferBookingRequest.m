//
//  TransferBookingRequest.m
//
//  Created by   on 17/04/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "TransferBookingRequest.h"
#import "LatLng.h"
#import "AccountBindingModel.h"


NSString *const kTransferBookingRequestDropoffAddress = @"DropoffAddress";
NSString *const kTransferBookingRequestPickupAddress = @"PickupAddress";
NSString *const kTransferBookingRequestStripeCardToken = @"StripeCardToken";
NSString *const kTransferBookingRequestPassengersNumber = @"PassengersNumber";
NSString *const kTransferBookingRequestDropoffLatLng = @"DropoffLatLng";
NSString *const kTransferBookingRequestAgreedToTermsAndConditions = @"AgreedToTermsAndConditions";
NSString *const kTransferBookingRequestAccountBindingModel = @"AccountBindingModel";
NSString *const kTransferBookingRequestDateTime = @"DateTime";
NSString *const kTransferBookingRequestPaymentMethod = @"PaymentMethod";
NSString *const kTransferBookingRequestPickupLatLng = @"PickupLatLng";
NSString *const kTransferBookingRequestExtras = @"Extras";
NSString *const kTransferBookingRequestCarTypeId = @"CarTypeId";
NSString *const kTransferBookingRequestLuggagePiecesNumber = @"LuggagePiecesNumber";


@interface TransferBookingRequest ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation TransferBookingRequest

@synthesize dropoffAddress = _dropoffAddress;
@synthesize pickupAddress = _pickupAddress;
@synthesize stripeCardToken = _stripeCardToken;
@synthesize passengersNumber = _passengersNumber;
@synthesize dropoffLatLng = _dropoffLatLng;
@synthesize agreedToTermsAndConditions = _agreedToTermsAndConditions;
@synthesize accountBindingModel = _accountBindingModel;
@synthesize dateTime = _dateTime;
@synthesize paymentMethod = _paymentMethod;
@synthesize pickupLatLng = _pickupLatLng;
@synthesize extras = _extras;
@synthesize carTypeId = _carTypeId;
@synthesize luggagePiecesNumber = _luggagePiecesNumber;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.dropoffAddress = [self objectOrNilForKey:kTransferBookingRequestDropoffAddress fromDictionary:dict];
            self.pickupAddress = [self objectOrNilForKey:kTransferBookingRequestPickupAddress fromDictionary:dict];
            self.stripeCardToken = [self objectOrNilForKey:kTransferBookingRequestStripeCardToken fromDictionary:dict];
            self.passengersNumber = [[self objectOrNilForKey:kTransferBookingRequestPassengersNumber fromDictionary:dict] integerValue];
            self.dropoffLatLng = [LatLng modelObjectWithDictionary:[dict objectForKey:kTransferBookingRequestDropoffLatLng]];
            self.agreedToTermsAndConditions = [[self objectOrNilForKey:kTransferBookingRequestAgreedToTermsAndConditions fromDictionary:dict] boolValue];
            self.accountBindingModel = [AccountBindingModel modelObjectWithDictionary:[dict objectForKey:kTransferBookingRequestAccountBindingModel]];
            self.dateTime = [self objectOrNilForKey:kTransferBookingRequestDateTime fromDictionary:dict];
            self.paymentMethod = [[self objectOrNilForKey:kTransferBookingRequestPaymentMethod fromDictionary:dict] integerValue];
            self.pickupLatLng = [LatLng modelObjectWithDictionary:[dict objectForKey:kTransferBookingRequestPickupLatLng]];
            self.extras = [self objectOrNilForKey:kTransferBookingRequestExtras fromDictionary:dict];
            self.carTypeId = [[self objectOrNilForKey:kTransferBookingRequestCarTypeId fromDictionary:dict] integerValue];
            self.luggagePiecesNumber = [[self objectOrNilForKey:kTransferBookingRequestLuggagePiecesNumber fromDictionary:dict] integerValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.dropoffAddress forKey:kTransferBookingRequestDropoffAddress];
    [mutableDict setValue:self.pickupAddress forKey:kTransferBookingRequestPickupAddress];
    [mutableDict setValue:self.stripeCardToken forKey:kTransferBookingRequestStripeCardToken];
    [mutableDict setValue:[NSNumber numberWithInteger:self.passengersNumber] forKey:kTransferBookingRequestPassengersNumber];
    [mutableDict setValue:[self.dropoffLatLng dictionaryRepresentation] forKey:kTransferBookingRequestDropoffLatLng];
    [mutableDict setValue:[NSNumber numberWithBool:self.agreedToTermsAndConditions] forKey:kTransferBookingRequestAgreedToTermsAndConditions];
    [mutableDict setValue:[self.accountBindingModel dictionaryRepresentation] forKey:kTransferBookingRequestAccountBindingModel];
    [mutableDict setValue:self.dateTime forKey:kTransferBookingRequestDateTime];
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
    [mutableDict setValue:[NSNumber numberWithInteger:self.carTypeId] forKey:kTransferBookingRequestCarTypeId];
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
    self.dropoffLatLng = [aDecoder decodeObjectForKey:kTransferBookingRequestDropoffLatLng];
    self.agreedToTermsAndConditions = [aDecoder decodeBoolForKey:kTransferBookingRequestAgreedToTermsAndConditions];
    self.accountBindingModel = [aDecoder decodeObjectForKey:kTransferBookingRequestAccountBindingModel];
    self.dateTime = [aDecoder decodeObjectForKey:kTransferBookingRequestDateTime];
    self.paymentMethod = [aDecoder decodeIntegerForKey:kTransferBookingRequestPaymentMethod];
    self.pickupLatLng = [aDecoder decodeObjectForKey:kTransferBookingRequestPickupLatLng];
    self.extras = [aDecoder decodeObjectForKey:kTransferBookingRequestExtras];
    self.carTypeId = [aDecoder decodeIntegerForKey:kTransferBookingRequestCarTypeId];
    self.luggagePiecesNumber = [aDecoder decodeIntegerForKey:kTransferBookingRequestLuggagePiecesNumber];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_dropoffAddress forKey:kTransferBookingRequestDropoffAddress];
    [aCoder encodeObject:_pickupAddress forKey:kTransferBookingRequestPickupAddress];
    [aCoder encodeObject:_stripeCardToken forKey:kTransferBookingRequestStripeCardToken];
    [aCoder encodeInteger:_passengersNumber forKey:kTransferBookingRequestPassengersNumber];
    [aCoder encodeObject:_dropoffLatLng forKey:kTransferBookingRequestDropoffLatLng];
    [aCoder encodeBool:_agreedToTermsAndConditions forKey:kTransferBookingRequestAgreedToTermsAndConditions];
    [aCoder encodeObject:_accountBindingModel forKey:kTransferBookingRequestAccountBindingModel];
    [aCoder encodeObject:_dateTime forKey:kTransferBookingRequestDateTime];
    [aCoder encodeInteger:_paymentMethod forKey:kTransferBookingRequestPaymentMethod];
    [aCoder encodeObject:_pickupLatLng forKey:kTransferBookingRequestPickupLatLng];
    [aCoder encodeObject:_extras forKey:kTransferBookingRequestExtras];
    [aCoder encodeInteger:_carTypeId forKey:kTransferBookingRequestCarTypeId];
    [aCoder encodeInteger:_luggagePiecesNumber forKey:kTransferBookingRequestLuggagePiecesNumber];
}

- (id)copyWithZone:(NSZone *)zone {
    TransferBookingRequest *copy = [[TransferBookingRequest alloc] init];
    
    
    
    if (copy) {

        copy.dropoffAddress = [self.dropoffAddress copyWithZone:zone];
        copy.pickupAddress = [self.pickupAddress copyWithZone:zone];
        copy.stripeCardToken = [self.stripeCardToken copyWithZone:zone];
        copy.passengersNumber = self.passengersNumber;
        copy.dropoffLatLng = [self.dropoffLatLng copyWithZone:zone];
        copy.agreedToTermsAndConditions = self.agreedToTermsAndConditions;
        copy.accountBindingModel = [self.accountBindingModel copyWithZone:zone];
        copy.dateTime = [self.dateTime copyWithZone:zone];
        copy.paymentMethod = self.paymentMethod;
        copy.pickupLatLng = [self.pickupLatLng copyWithZone:zone];
        copy.extras = [self.extras copyWithZone:zone];
        copy.carTypeId = self.carTypeId;
        copy.luggagePiecesNumber = self.luggagePiecesNumber;
    }
    
    return copy;
}


@end
