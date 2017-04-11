//
//  Location.m
//
//  Created by   on 9/3/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "Location.h"
#import "LatLng.h"

NSString *const kLocationsIdentifier = @"Id";
NSString *const kLocationsName = @"Name";
NSString *const kLocationsPlaceId = @"PlaceId";
NSString *const kLocationsLatLng = @"Position";


@interface Location ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Location

@synthesize name = _name;
@synthesize latLng = _latLng;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.identifier = [[self objectOrNilForKey:kLocationsIdentifier fromDictionary:dict] integerValue];
        self.name = [self objectOrNilForKey:kLocationsName fromDictionary:dict];
        self.placeId = [self objectOrNilForKey:kLocationsPlaceId fromDictionary:dict];
        self.latLng = [LatLng modelObjectWithDictionary:[dict objectForKey:kLocationsLatLng]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:@(self.identifier) forKey:kLocationsIdentifier];
    [mutableDict setValue:self.name forKey:kLocationsName];
    [mutableDict setValue:self.placeId forKey:kLocationsPlaceId];
    [mutableDict setValue:[self.latLng dictionaryRepresentation] forKey:kLocationsLatLng];

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

    self.name = [aDecoder decodeObjectForKey:kLocationsName];
    self.latLng = [aDecoder decodeObjectForKey:kLocationsLatLng];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kLocationsName];
    [aCoder encodeObject:_latLng forKey:kLocationsLatLng];
}

- (id)copyWithZone:(NSZone *)zone {
    Location *copy = [[Location alloc] init];
    
    
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.latLng = [self.latLng copyWithZone:zone];
    }
    
    return copy;
}


@end
