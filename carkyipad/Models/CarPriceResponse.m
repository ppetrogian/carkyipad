//
//  CarPriceResponse.m
//
//  Created by   on 23/04/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "CarPriceResponse.h"
#import "CarPrice.h"


NSString *const kCarPriceResponseCarPrice = @"CarPrice";


@interface CarPriceResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CarPriceResponse

@synthesize carPrice = _carPrice;



+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedCarPrice = [dict objectForKey:kCarPriceResponseCarPrice];
    NSMutableArray *parsedCarPrice = [NSMutableArray array];
    
    if ([receivedCarPrice isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCarPrice) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCarPrice addObject:[CarPrice modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCarPrice isKindOfClass:[NSDictionary class]]) {
       [parsedCarPrice addObject:[CarPrice modelObjectWithDictionary:(NSDictionary *)receivedCarPrice]];
    }

    self.carPrice = [NSArray arrayWithArray:parsedCarPrice];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForCarPrice = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.carPrice) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCarPrice addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCarPrice addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCarPrice] forKey:kCarPriceResponseCarPrice];

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

    self.carPrice = [aDecoder decodeObjectForKey:kCarPriceResponseCarPrice];
   
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_carPrice forKey:kCarPriceResponseCarPrice];
   
}

- (id)copyWithZone:(NSZone *)zone {
    CarPriceResponse *copy = [[CarPriceResponse alloc] init];
    
    
    
    if (copy) {

        copy.carPrice = [self.carPrice copyWithZone:zone];
       
    }
    
    return copy;
}


@end
