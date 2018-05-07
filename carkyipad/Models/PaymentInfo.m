//
//  PaymentInfo.m
//
//  Created by   on 17/05/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "PaymentInfo.h"


NSString *const kPaymentInfoPaymentMethod = @"PaymentMethod";
NSString *const kPaymentInfostripeCardToken = @"StripeCardToken";
NSString *const kPaymentInfoPayPalResponse = @"PayPalResponse";
NSString *const kPaymentInfoPayPalAuthorizationId = @"PayPalAuthorizationId";

@interface PaymentInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PaymentInfo

@synthesize paymentMethod = _paymentMethod;



+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.paymentMethod = [self objectOrNilForKey:kPaymentInfoPaymentMethod fromDictionary:dict];
        self.stripeCardToken = [self objectOrNilForKey:kPaymentInfostripeCardToken fromDictionary:dict];
        self.payPalResponse = [self objectOrNilForKey:kPaymentInfoPayPalResponse fromDictionary:dict];
        self.payPalAuthorizationId = [self objectOrNilForKey:kPaymentInfoPayPalAuthorizationId fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.paymentMethod forKey:kPaymentInfoPaymentMethod];
    [mutableDict setValue:self.stripeCardToken forKey:kPaymentInfostripeCardToken];
    [mutableDict setValue:self.payPalResponse forKey:kPaymentInfoPayPalResponse];
    [mutableDict setValue:self.payPalAuthorizationId forKey:kPaymentInfoPayPalAuthorizationId];

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

    self.paymentMethod = [aDecoder decodeObjectForKey:kPaymentInfoPaymentMethod];
    self.stripeCardToken = [aDecoder decodeObjectForKey:kPaymentInfostripeCardToken];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_paymentMethod forKey:kPaymentInfoPaymentMethod];
    [aCoder encodeObject:_stripeCardToken forKey:kPaymentInfostripeCardToken];
}

- (id)copyWithZone:(NSZone *)zone {
    PaymentInfo *copy = [[PaymentInfo alloc] init];
    
    
    
    if (copy) {

        copy.paymentMethod = self.paymentMethod;
        copy.stripeCardToken = [self.stripeCardToken copyWithZone:zone];
    }
    
    return copy;
}


@end
