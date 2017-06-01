//
//  Price.m
//
//  Created by   on 01/06/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "Price.h"


NSString *const kPricePrice = @"Price";
NSString *const kPriceType = @"Type";


@interface Price ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Price

@synthesize price = _price;
@synthesize type = _type;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.price = [[self objectOrNilForKey:kPricePrice fromDictionary:dict] integerValue];
            self.type = [self objectOrNilForKey:kPriceType fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInteger:self.price] forKey:kPricePrice];
    [mutableDict setValue:self.type forKey:kPriceType];

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

    self.price = [aDecoder decodeIntegerForKey:kPricePrice];
    self.type = [aDecoder decodeObjectForKey:kPriceType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeInteger:_price forKey:kPricePrice];
    [aCoder encodeObject:_type forKey:kPriceType];
}

- (id)copyWithZone:(NSZone *)zone {
    Price *copy = [[Price alloc] init];
    
    
    
    if (copy) {

        copy.price = self.price;
        copy.type = [self.type copyWithZone:zone];
    }
    
    return copy;
}


@end
