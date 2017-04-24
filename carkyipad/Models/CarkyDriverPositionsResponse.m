//
//  CarkyDriverPositionsResponse.m
//
//  Created by   on 12/04/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "CarkyDriverPositionsResponse.h"
#import "LatLng.h"


NSString *const kCarkyDriverPositionsResponseDriverId = @"DriverId";
NSString *const kCarkyDriverPositionsResponseLatLng = @"LatLng";


@interface CarkyDriverPositionsResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CarkyDriverPositionsResponse

@synthesize driverId = _driverId;
@synthesize latLng = _latLng;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.driverId = [[self objectOrNilForKey:kCarkyDriverPositionsResponseDriverId fromDictionary:dict] doubleValue];
            self.latLng = [LatLng modelObjectWithDictionary:[dict objectForKey:kCarkyDriverPositionsResponseLatLng]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.driverId] forKey:kCarkyDriverPositionsResponseDriverId];
    [mutableDict setValue:[self.latLng dictionaryRepresentation] forKey:kCarkyDriverPositionsResponseLatLng];

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

    self.driverId = [aDecoder decodeDoubleForKey:kCarkyDriverPositionsResponseDriverId];
    self.latLng = [aDecoder decodeObjectForKey:kCarkyDriverPositionsResponseLatLng];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_driverId forKey:kCarkyDriverPositionsResponseDriverId];
    [aCoder encodeObject:_latLng forKey:kCarkyDriverPositionsResponseLatLng];
}

- (id)copyWithZone:(NSZone *)zone {
    CarkyDriverPositionsResponse *copy = [[CarkyDriverPositionsResponse alloc] init];
    
    
    
    if (copy) {

        copy.driverId = self.driverId;
        copy.latLng = [self.latLng copyWithZone:zone];
    }
    
    return copy;
}


@end
