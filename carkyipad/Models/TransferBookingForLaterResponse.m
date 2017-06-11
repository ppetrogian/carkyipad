//
//  TransferBookingForLaterResponse.m
//
//  Created by   on 11/06/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "TransferBookingForLaterResponse.h"


NSString *const kTransferBookingForLaterResponseDescription = @"Description";
NSString *const kTransferBookingForLaterResponseAmount = @"Amount";
NSString *const kTransferBookingForLaterResponseCurrency = @"Currency";
NSString *const kTransferBookingForLaterResponseId = @"Id";


@interface TransferBookingForLaterResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation TransferBookingForLaterResponse

@synthesize internalBaseClassDescription = _internalBaseClassDescription;
@synthesize amount = _amount;
@synthesize currency = _currency;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.internalBaseClassDescription = [self objectOrNilForKey:kTransferBookingForLaterResponseDescription fromDictionary:dict];
            self.amount = [self objectOrNilForKey:kTransferBookingForLaterResponseAmount fromDictionary:dict];
            self.currency = [self objectOrNilForKey:kTransferBookingForLaterResponseCurrency fromDictionary:dict];
            self.internalBaseClassIdentifier = [[self objectOrNilForKey:kTransferBookingForLaterResponseId fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.internalBaseClassDescription forKey:kTransferBookingForLaterResponseDescription];
    [mutableDict setValue:self.amount forKey:kTransferBookingForLaterResponseAmount];
    [mutableDict setValue:self.currency forKey:kTransferBookingForLaterResponseCurrency];
    [mutableDict setValue:[NSNumber numberWithDouble:self.internalBaseClassIdentifier] forKey:kTransferBookingForLaterResponseId];

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

    self.internalBaseClassDescription = [aDecoder decodeObjectForKey:kTransferBookingForLaterResponseDescription];
    self.amount = [aDecoder decodeObjectForKey:kTransferBookingForLaterResponseAmount];
    self.currency = [aDecoder decodeObjectForKey:kTransferBookingForLaterResponseCurrency];
    self.internalBaseClassIdentifier = [aDecoder decodeDoubleForKey:kTransferBookingForLaterResponseId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_internalBaseClassDescription forKey:kTransferBookingForLaterResponseDescription];
    [aCoder encodeObject:_amount forKey:kTransferBookingForLaterResponseAmount];
    [aCoder encodeObject:_currency forKey:kTransferBookingForLaterResponseCurrency];
    [aCoder encodeDouble:_internalBaseClassIdentifier forKey:kTransferBookingForLaterResponseId];
}

- (id)copyWithZone:(NSZone *)zone {
    TransferBookingForLaterResponse *copy = [[TransferBookingForLaterResponse alloc] init];
    
    
    
    if (copy) {

        copy.internalBaseClassDescription = [self.internalBaseClassDescription copyWithZone:zone];
        copy.amount = [self.amount copyWithZone:zone];
        copy.currency = [self.currency copyWithZone:zone];
        copy.internalBaseClassIdentifier = self.internalBaseClassIdentifier;
    }
    
    return copy;
}


@end
