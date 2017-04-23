//
//  CarPrice.m
//
//  Created by   on 23/04/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "CarPrice.h"


NSString *const kCarPricePrice = @"Price";
NSString *const kCarPriceCarServiceId = @"CarServiceId";


@interface CarPrice ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CarPrice

@synthesize price = _price;
@synthesize carServiceId = _carServiceId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.price = [[self objectOrNilForKey:kCarPricePrice fromDictionary:dict] integerValue];
            self.carServiceId = [[self objectOrNilForKey:kCarPriceCarServiceId fromDictionary:dict] integerValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInteger:self.price] forKey:kCarPricePrice];
    [mutableDict setValue:[NSNumber numberWithInteger:self.carServiceId] forKey:kCarPriceCarServiceId];

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

    self.price = [aDecoder decodeDoubleForKey:kCarPricePrice];
    self.carServiceId = [aDecoder decodeDoubleForKey:kCarPriceCarServiceId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_price forKey:kCarPricePrice];
    [aCoder encodeDouble:_carServiceId forKey:kCarPriceCarServiceId];
}

- (id)copyWithZone:(NSZone *)zone {
    CarPrice *copy = [[CarPrice alloc] init];
    
    
    
    if (copy) {

        copy.price = self.price;
        copy.carServiceId = self.carServiceId;
    }
    
    return copy;
}


@end
