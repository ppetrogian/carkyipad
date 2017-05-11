//
//  CreateTransferBookingRequestPayPalPaymentResponse.m
//
//  Created by   on 11/05/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "CreateTransferBookingRequestPayPalPaymentResponse.h"


NSString *const kCreateTransferBookingRequestPayPalPaymentResponseDescription = @"Description";
NSString *const kCreateTransferBookingRequestPayPalPaymentResponseCurrency = @"Currency";
NSString *const kCreateTransferBookingRequestPayPalPaymentResponseAmount = @"Amount";


@interface CreateTransferBookingRequestPayPalPaymentResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CreateTransferBookingRequestPayPalPaymentResponse

@synthesize internalBaseClassDescription = _internalBaseClassDescription;
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
            self.internalBaseClassDescription = [self objectOrNilForKey:kCreateTransferBookingRequestPayPalPaymentResponseDescription fromDictionary:dict];
            self.currency = [self objectOrNilForKey:kCreateTransferBookingRequestPayPalPaymentResponseCurrency fromDictionary:dict];
            self.amount = [self objectOrNilForKey:kCreateTransferBookingRequestPayPalPaymentResponseAmount fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.internalBaseClassDescription forKey:kCreateTransferBookingRequestPayPalPaymentResponseDescription];
    [mutableDict setValue:self.currency forKey:kCreateTransferBookingRequestPayPalPaymentResponseCurrency];
    [mutableDict setValue:self.amount forKey:kCreateTransferBookingRequestPayPalPaymentResponseAmount];

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

    self.internalBaseClassDescription = [aDecoder decodeObjectForKey:kCreateTransferBookingRequestPayPalPaymentResponseDescription];
    self.currency = [aDecoder decodeObjectForKey:kCreateTransferBookingRequestPayPalPaymentResponseCurrency];
    self.amount = [aDecoder decodeObjectForKey:kCreateTransferBookingRequestPayPalPaymentResponseAmount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_internalBaseClassDescription forKey:kCreateTransferBookingRequestPayPalPaymentResponseDescription];
    [aCoder encodeObject:_currency forKey:kCreateTransferBookingRequestPayPalPaymentResponseCurrency];
    [aCoder encodeObject:_amount forKey:kCreateTransferBookingRequestPayPalPaymentResponseAmount];
}

- (id)copyWithZone:(NSZone *)zone {
    CreateTransferBookingRequestPayPalPaymentResponse *copy = [[CreateTransferBookingRequestPayPalPaymentResponse alloc] init];
    
    
    
    if (copy) {

        copy.internalBaseClassDescription = [self.internalBaseClassDescription copyWithZone:zone];
        copy.currency = [self.currency copyWithZone:zone];
        copy.amount = [self.amount copyWithZone:zone];
    }
    
    return copy;
}


@end
