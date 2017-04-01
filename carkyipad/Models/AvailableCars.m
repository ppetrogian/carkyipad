//
//  AvailableCars.m
//
//  Created by   on 1/4/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "AvailableCars.h"
#import "Cars.h"


NSString *const kAvailableCarsName = @"Name";
NSString *const kAvailableCarsCars = @"Cars";


@interface AvailableCars ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AvailableCars

@synthesize name = _name;
@synthesize cars = _cars;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.name = [self objectOrNilForKey:kAvailableCarsName fromDictionary:dict];
    NSObject *receivedCars = [dict objectForKey:kAvailableCarsCars];
    NSMutableArray *parsedCars = [NSMutableArray array];
    
    if ([receivedCars isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCars) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCars addObject:[Cars modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCars isKindOfClass:[NSDictionary class]]) {
       [parsedCars addObject:[Cars modelObjectWithDictionary:(NSDictionary *)receivedCars]];
    }

    self.cars = [NSArray arrayWithArray:parsedCars];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kAvailableCarsName];
    NSMutableArray *tempArrayForCars = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.cars) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCars addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCars addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCars] forKey:kAvailableCarsCars];

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

    self.name = [aDecoder decodeObjectForKey:kAvailableCarsName];
    self.cars = [aDecoder decodeObjectForKey:kAvailableCarsCars];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kAvailableCarsName];
    [aCoder encodeObject:_cars forKey:kAvailableCarsCars];
}

- (id)copyWithZone:(NSZone *)zone {
    AvailableCars *copy = [[AvailableCars alloc] init];
    
    
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.cars = [self.cars copyWithZone:zone];
    }
    
    return copy;
}


@end
