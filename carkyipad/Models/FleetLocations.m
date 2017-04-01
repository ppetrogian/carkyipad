//
//  FleetLocations.m
//
//  Created by   on 9/3/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "FleetLocations.h"
#import "Location.h"

NSString *const kFleetLocationsIdentifier = @"Id";
NSString *const kFleetLocationsName = @"Name";
NSString *const kFleetLocationsLocations = @"WellKnownLocations";
NSString *const kFleetLocationsIcon = @"Icon";

@interface FleetLocations ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FleetLocations

@synthesize name = _name;
@synthesize locations = _locations;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.identifier = [[self objectOrNilForKey:kFleetLocationsIdentifier fromDictionary:dict] integerValue];
        self.name = [self objectOrNilForKey:kFleetLocationsName fromDictionary:dict];
        self.icon = [self objectOrNilForKey:kFleetLocationsIcon fromDictionary:dict];
    NSObject *receivedLocations = [dict objectForKey:kFleetLocationsLocations];
    NSMutableArray *parsedLocations = [NSMutableArray array];
    
    if ([receivedLocations isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedLocations) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedLocations addObject:[Location modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedLocations isKindOfClass:[NSDictionary class]]) {
       [parsedLocations addObject:[Location modelObjectWithDictionary:(NSDictionary *)receivedLocations]];
    }

    self.locations = [NSArray arrayWithArray:parsedLocations];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:@(self.identifier) forKey:kFleetLocationsIdentifier];
    [mutableDict setValue:self.name forKey:kFleetLocationsName];
    [mutableDict setValue:self.icon forKey:kFleetLocationsIcon];
    NSMutableArray *tempArrayForLocations = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.locations) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForLocations addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForLocations addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLocations] forKey:kFleetLocationsLocations];

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

    self.identifier = [aDecoder decodeIntegerForKey:kFleetLocationsName];
    self.name = [aDecoder decodeObjectForKey:kFleetLocationsName];
    self.locations = [aDecoder decodeObjectForKey:kFleetLocationsLocations];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_identifier forKey:kFleetLocationsIdentifier];
    [aCoder encodeObject:_name forKey:kFleetLocationsName];
    [aCoder encodeObject:_locations forKey:kFleetLocationsLocations];
}

- (id)copyWithZone:(NSZone *)zone {
    FleetLocations *copy = [[FleetLocations alloc] init];
    
    
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.locations = [self.locations copyWithZone:zone];
    }
    
    return copy;
}


@end
