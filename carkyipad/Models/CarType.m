//
//  CarType.m
//
//  Created by   on 11/3/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "CarType.h"
#import "CarCategory.h"


NSString *const kCarTypeFuel = @"Fuel";
NSString *const kCarTypeCategory = @"Category";
NSString *const kCarTypeMake = @"Make";
NSString *const kCarTypeModel = @"Model";
NSString *const kCarTypeTransmission = @"Transmission";
NSString *const kCarTypeId = @"Id";


@interface CarType ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CarType

@synthesize fuel = _fuel;
@synthesize category = _category;
@synthesize make = _make;
@synthesize model = _model;
@synthesize transmission = _transmission;
@synthesize Identifier = _Identifier;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.fuel = [[self objectOrNilForKey:kCarTypeFuel fromDictionary:dict] doubleValue];
            self.category = [CarCategory modelObjectWithDictionary:[dict objectForKey:kCarTypeCategory]];
            self.make = [self objectOrNilForKey:kCarTypeMake fromDictionary:dict];
            self.model = [self objectOrNilForKey:kCarTypeModel fromDictionary:dict];
            self.transmission = [[self objectOrNilForKey:kCarTypeTransmission fromDictionary:dict] doubleValue];
            self.Identifier = [[self objectOrNilForKey:kCarTypeId fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.fuel] forKey:kCarTypeFuel];
    [mutableDict setValue:[self.category dictionaryRepresentation] forKey:kCarTypeCategory];
    [mutableDict setValue:self.make forKey:kCarTypeMake];
    [mutableDict setValue:self.model forKey:kCarTypeModel];
    [mutableDict setValue:[NSNumber numberWithDouble:self.transmission] forKey:kCarTypeTransmission];
    [mutableDict setValue:[NSNumber numberWithDouble:self.Identifier] forKey:kCarTypeId];

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

    self.fuel = [aDecoder decodeDoubleForKey:kCarTypeFuel];
    self.category = [aDecoder decodeObjectForKey:kCarTypeCategory];
    self.make = [aDecoder decodeObjectForKey:kCarTypeMake];
    self.model = [aDecoder decodeObjectForKey:kCarTypeModel];
    self.transmission = [aDecoder decodeDoubleForKey:kCarTypeTransmission];
    self.Identifier = [aDecoder decodeDoubleForKey:kCarTypeId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_fuel forKey:kCarTypeFuel];
    [aCoder encodeObject:_category forKey:kCarTypeCategory];
    [aCoder encodeObject:_make forKey:kCarTypeMake];
    [aCoder encodeObject:_model forKey:kCarTypeModel];
    [aCoder encodeDouble:_transmission forKey:kCarTypeTransmission];
    [aCoder encodeDouble:_Identifier forKey:kCarTypeId];
}

- (id)copyWithZone:(NSZone *)zone {
    CarType *copy = [[CarType alloc] init];
    
    
    
    if (copy) {

        copy.fuel = self.fuel;
        copy.category = [self.category copyWithZone:zone];
        copy.make = [self.make copyWithZone:zone];
        copy.model = [self.model copyWithZone:zone];
        copy.transmission = self.transmission;
        copy.Identifier = self.Identifier;
    }
    
    return copy;
}


@end
