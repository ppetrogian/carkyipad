//
//  PayPalPaymentInfo.m
//
//  Created by   on 19/5/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "PayPalPaymentInfo.h"


NSString *const kPayPalPaymentInfoDescription = @"Description";
NSString *const kPayPalPaymentInfoCurrency = @"Currency";
NSString *const kPayPalPaymentInfoAmount = @"Amount";


@interface PayPalPaymentInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PayPalPaymentInfo

@synthesize payPalPaymentInfoDescription = _payPalPaymentInfoDescription;
@synthesize currency = _currency;
@synthesize amount = _amount;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.payPalPaymentInfoDescription = [self objectOrNilForKey:kPayPalPaymentInfoDescription fromDictionary:dict];
            self.currency = [self objectOrNilForKey:kPayPalPaymentInfoCurrency fromDictionary:dict];
            self.amount = [self objectOrNilForKey:kPayPalPaymentInfoAmount fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.payPalPaymentInfoDescription forKey:kPayPalPaymentInfoDescription];
    [mutableDict setValue:self.currency forKey:kPayPalPaymentInfoCurrency];
    [mutableDict setValue:self.amount forKey:kPayPalPaymentInfoAmount];

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

    self.payPalPaymentInfoDescription = [aDecoder decodeObjectForKey:kPayPalPaymentInfoDescription];
    self.currency = [aDecoder decodeObjectForKey:kPayPalPaymentInfoCurrency];
    self.amount = [aDecoder decodeObjectForKey:kPayPalPaymentInfoAmount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_payPalPaymentInfoDescription forKey:kPayPalPaymentInfoDescription];
    [aCoder encodeObject:_currency forKey:kPayPalPaymentInfoCurrency];
    [aCoder encodeObject:_amount forKey:kPayPalPaymentInfoAmount];
}

- (id)copyWithZone:(NSZone *)zone {
    PayPalPaymentInfo *copy = [[PayPalPaymentInfo alloc] init];
    
    
    
    if (copy) {

        copy.payPalPaymentInfoDescription = [self.payPalPaymentInfoDescription copyWithZone:zone];
        copy.currency = [self.currency copyWithZone:zone];
        copy.amount = [self.amount copyWithZone:zone];
    }
    
    return copy;
}


@end
