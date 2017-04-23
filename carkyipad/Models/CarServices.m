//
//  CarServices.m
//
//  Created by   on 23/04/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "CarServices.h"


NSString *const kCarServicesMaxPassengers = @"MaxPassengers";
NSString *const kCarServicesName = @"Name";
NSString *const kCarServicesMazLuggages = @"MazLuggages";
NSString *const kCarServicesId = @"Id";


@interface CarServices ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CarServices

@synthesize maxPassengers = _maxPassengers;
@synthesize name = _name;
@synthesize mazLuggages = _mazLuggages;
@synthesize carServicesIdentifier = _carServicesIdentifier;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.maxPassengers = [[self objectOrNilForKey:kCarServicesMaxPassengers fromDictionary:dict] integerValue];
            self.name = [self objectOrNilForKey:kCarServicesName fromDictionary:dict];
            self.mazLuggages = [[self objectOrNilForKey:kCarServicesMazLuggages fromDictionary:dict] integerValue];
            self.carServicesIdentifier = [[self objectOrNilForKey:kCarServicesId fromDictionary:dict] integerValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInteger:self.maxPassengers] forKey:kCarServicesMaxPassengers];
    [mutableDict setValue:self.name forKey:kCarServicesName];
    [mutableDict setValue:[NSNumber numberWithInteger:self.mazLuggages] forKey:kCarServicesMazLuggages];
    [mutableDict setValue:[NSNumber numberWithInteger:self.carServicesIdentifier] forKey:kCarServicesId];

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

    self.maxPassengers = [aDecoder decodeDoubleForKey:kCarServicesMaxPassengers];
    self.name = [aDecoder decodeObjectForKey:kCarServicesName];
    self.mazLuggages = [aDecoder decodeDoubleForKey:kCarServicesMazLuggages];
    self.carServicesIdentifier = [aDecoder decodeDoubleForKey:kCarServicesId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_maxPassengers forKey:kCarServicesMaxPassengers];
    [aCoder encodeObject:_name forKey:kCarServicesName];
    [aCoder encodeDouble:_mazLuggages forKey:kCarServicesMazLuggages];
    [aCoder encodeDouble:_carServicesIdentifier forKey:kCarServicesId];
}

- (id)copyWithZone:(NSZone *)zone {
    CarServices *copy = [[CarServices alloc] init];
    
    
    
    if (copy) {

        copy.maxPassengers = self.maxPassengers;
        copy.name = [self.name copyWithZone:zone];
        copy.mazLuggages = self.mazLuggages;
        copy.carServicesIdentifier = self.carServicesIdentifier;
    }
    
    return copy;
}


@end
