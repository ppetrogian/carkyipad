//
//  Cars.m
//
//  Created by   on 1/4/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "Cars.h"


NSString *const kCarsTransmissionType = @"TransmissionType";
NSString *const kCarsMaxPassengers = @"MaxPassengers";
NSString *const kCarsMaxLaggages = @"MaxLaggages";
NSString *const kCarsId = @"Id";
NSString *const kCarsPrice = @"Price";
NSString *const kCarsPricePerDay = @"PricePerDay";
NSString *const kCarsPriceTotal = @"PriceTotal";
NSString *const kCarsSubDescription = @"SubDescription";
NSString *const kCarsFuelType = @"FuelType";
NSString *const kCarsDescription = @"Description";
NSString *const kCarsImage = @"Image";


@interface Cars ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Cars

@synthesize transmissionType = _transmissionType;
@synthesize maxPassengers = _maxPassengers;
@synthesize carsIdentifier = _carsIdentifier;
@synthesize pricePerDay = _pricePerDay;
@synthesize subDescription = _subDescription;
@synthesize fuelType = _fuelType;
@synthesize maxLaggages = _maxLaggages;
@synthesize carsDescription = _carsDescription;
@synthesize image = _image;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.transmissionType = [self objectOrNilForKey:kCarsTransmissionType fromDictionary:dict];
        self.maxPassengers = [[self objectOrNilForKey:kCarsMaxPassengers fromDictionary:dict] integerValue];
        self.maxLaggages = [[self objectOrNilForKey:kCarsMaxLaggages fromDictionary:dict] integerValue];
        self.carsIdentifier = [[self objectOrNilForKey:kCarsId fromDictionary:dict] integerValue];
        self.price = [[self objectOrNilForKey:kCarsPrice fromDictionary:dict] integerValue];
        self.pricePerDay = [[self objectOrNilForKey:kCarsPricePerDay fromDictionary:dict] integerValue];
        self.priceTotal = [[self objectOrNilForKey:kCarsPriceTotal fromDictionary:dict] doubleValue];
        self.subDescription = [self objectOrNilForKey:kCarsSubDescription fromDictionary:dict];
        self.fuelType = [self objectOrNilForKey:kCarsFuelType fromDictionary:dict];
        self.carsDescription = [self objectOrNilForKey:kCarsDescription fromDictionary:dict];
        self.image = [self objectOrNilForKey:kCarsImage fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.transmissionType forKey:kCarsTransmissionType];
    [mutableDict setValue:[NSNumber numberWithInteger:self.maxPassengers] forKey:kCarsMaxPassengers];
    [mutableDict setValue:[NSNumber numberWithInteger:self.maxLaggages] forKey:kCarsMaxLaggages];
    [mutableDict setValue:[NSNumber numberWithInteger:self.carsIdentifier] forKey:kCarsId];
    [mutableDict setValue:[NSNumber numberWithInteger:self.price] forKey:kCarsPrice];
    [mutableDict setValue:[NSNumber numberWithInteger:self.pricePerDay] forKey:kCarsPricePerDay];
    [mutableDict setValue:[NSNumber numberWithDouble:self.priceTotal] forKey:kCarsPriceTotal];
    [mutableDict setValue:self.subDescription forKey:kCarsSubDescription];
    [mutableDict setValue:self.fuelType forKey:kCarsFuelType];
    [mutableDict setValue:self.carsDescription forKey:kCarsDescription];
    [mutableDict setValue:self.image forKey:kCarsImage];

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

    self.transmissionType = [aDecoder decodeObjectForKey:kCarsTransmissionType];
    self.maxPassengers = [aDecoder decodeIntegerForKey:kCarsMaxPassengers];
    self.carsIdentifier = [aDecoder decodeIntegerForKey:kCarsId];
    self.pricePerDay = [aDecoder decodeIntegerForKey:kCarsPricePerDay];
    self.subDescription = [aDecoder decodeObjectForKey:kCarsSubDescription];
    self.fuelType = [aDecoder decodeObjectForKey:kCarsFuelType];
    self.maxLaggages = [aDecoder decodeIntegerForKey:kCarsMaxLaggages];
    self.carsDescription = [aDecoder decodeObjectForKey:kCarsDescription];
    self.image = [aDecoder decodeObjectForKey:kCarsImage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_transmissionType forKey:kCarsTransmissionType];
    [aCoder encodeDouble:_maxPassengers forKey:kCarsMaxPassengers];
    [aCoder encodeDouble:_carsIdentifier forKey:kCarsId];
    [aCoder encodeDouble:_pricePerDay forKey:kCarsPricePerDay];
    [aCoder encodeObject:_subDescription forKey:kCarsSubDescription];
    [aCoder encodeObject:_fuelType forKey:kCarsFuelType];
    [aCoder encodeDouble:_maxLaggages forKey:kCarsMaxLaggages];
    [aCoder encodeObject:_carsDescription forKey:kCarsDescription];
    [aCoder encodeObject:_image forKey:kCarsImage];
}

- (id)copyWithZone:(NSZone *)zone {
    Cars *copy = [[Cars alloc] init];
    
    
    
    if (copy) {

        copy.transmissionType = [self.transmissionType copyWithZone:zone];
        copy.maxPassengers = self.maxPassengers;
        copy.carsIdentifier = self.carsIdentifier;
        copy.pricePerDay = self.pricePerDay;
        copy.subDescription = [self.subDescription copyWithZone:zone];
        copy.fuelType = [self.fuelType copyWithZone:zone];
        copy.maxLaggages = self.maxLaggages;
        copy.carsDescription = [self.carsDescription copyWithZone:zone];
        copy.image = [self.image copyWithZone:zone];
    }
    
    return copy;
}


@end
