//
//  PaymentInfo.m
//
//  Created by   on 17/05/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "PaymentInfo.h"


NSString *const kPaymentInfoPaymentMethod = @"PaymentMethod";
NSString *const kPaymentInfoStripeCardId = @"StripeCardId";


@interface PaymentInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PaymentInfo

@synthesize paymentMethod = _paymentMethod;
@synthesize stripeCardId = _stripeCardId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.paymentMethod = [[self objectOrNilForKey:kPaymentInfoPaymentMethod fromDictionary:dict] integerValue];
            self.stripeCardId = [self objectOrNilForKey:kPaymentInfoStripeCardId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInteger:self.paymentMethod] forKey:kPaymentInfoPaymentMethod];
    [mutableDict setValue:self.stripeCardId forKey:kPaymentInfoStripeCardId];

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

    self.paymentMethod = [aDecoder decodeDoubleForKey:kPaymentInfoPaymentMethod];
    self.stripeCardId = [aDecoder decodeObjectForKey:kPaymentInfoStripeCardId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_paymentMethod forKey:kPaymentInfoPaymentMethod];
    [aCoder encodeObject:_stripeCardId forKey:kPaymentInfoStripeCardId];
}

- (id)copyWithZone:(NSZone *)zone {
    PaymentInfo *copy = [[PaymentInfo alloc] init];
    
    
    
    if (copy) {

        copy.paymentMethod = self.paymentMethod;
        copy.stripeCardId = [self.stripeCardId copyWithZone:zone];
    }
    
    return copy;
}


@end
