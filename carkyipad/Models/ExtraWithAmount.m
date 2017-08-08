//
//  ExtraWithAmount.m
//
//  Created by   on 08/08/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "ExtraWithAmount.h"


NSString *const kExtraWithAmountId = @"Id";
NSString *const kExtraWithAmountAmount = @"Amount";


@interface ExtraWithAmount ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ExtraWithAmount

@synthesize identifier = _identifier;
@synthesize amount = _amount;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.identifier = [[self objectOrNilForKey:kExtraWithAmountId fromDictionary:dict] integerValue];
            self.amount = [[self objectOrNilForKey:kExtraWithAmountAmount fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInteger:self.identifier] forKey:kExtraWithAmountId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.amount] forKey:kExtraWithAmountAmount];

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

    self.identifier = [aDecoder decodeIntegerForKey:kExtraWithAmountId];
    self.amount = [aDecoder decodeDoubleForKey:kExtraWithAmountAmount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeInteger:_identifier forKey:kExtraWithAmountId];
    [aCoder encodeDouble:_amount forKey:kExtraWithAmountAmount];
}

- (id)copyWithZone:(NSZone *)zone {
    ExtraWithAmount *copy = [[ExtraWithAmount alloc] init];
    
    
    
    if (copy) {

        copy.identifier = self.identifier;
        copy.amount = self.amount;
    }
    
    return copy;
}


@end
