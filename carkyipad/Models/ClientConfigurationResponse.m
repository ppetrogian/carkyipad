//
//  ClientConfigurationResponse.m
//
//  Created by   on 23/04/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "ClientConfigurationResponse.h"
#import "CarServices.h"
#import "Location.h"
#import "LatLng.h"

NSString *const kClientConfigurationResponseCarServices = @"CarServices";
NSString *const kClientConfigurationResponseLocation = @"Location";
NSString *const kClientConfigurationResponseAreaOfServiceId = @"AreaOfServiceId";
NSString *const kClientConfigurationResponseZoneId = @"ZoneId";
NSString *const kClientConfigurationResponsePickupInstructionsImage = @"PickupInstructionsImage";


@interface ClientConfigurationResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ClientConfigurationResponse

@synthesize carServices = _carServices;
@synthesize areaOfServiceId = _areaOfServiceId;
@synthesize zoneId = _zoneId;
@synthesize pickupInstructionsImage = _pickupInstructionsImage;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedCarServices = [dict objectForKey:kClientConfigurationResponseCarServices];
    NSMutableArray *parsedCarServices = [NSMutableArray array];
    
    if ([receivedCarServices isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCarServices) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCarServices addObject:[CarServices modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCarServices isKindOfClass:[NSDictionary class]]) {
       [parsedCarServices addObject:[CarServices modelObjectWithDictionary:(NSDictionary *)receivedCarServices]];
    }

        self.carServices = [NSArray arrayWithArray:parsedCarServices];
        NSDictionary *locDictionary = [dict objectForKey:kClientConfigurationResponseLocation];
        self.location = [Location modelObjectWithDictionary:locDictionary];
        self.location.latLng = [LatLng modelObjectWithDictionary:[locDictionary objectForKey:@"Geography"]];
        self.areaOfServiceId = [[self objectOrNilForKey:kClientConfigurationResponseAreaOfServiceId fromDictionary:dict] integerValue];
        self.zoneId = [[self objectOrNilForKey:kClientConfigurationResponseZoneId fromDictionary:dict] integerValue];
        self.pickupInstructionsImage = [self objectOrNilForKey:kClientConfigurationResponsePickupInstructionsImage fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForCarServices = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.carServices) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCarServices addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCarServices addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCarServices] forKey:kClientConfigurationResponseCarServices];
    [mutableDict setValue:[self.location dictionaryRepresentation] forKey:kClientConfigurationResponseLocation];
    [mutableDict setValue:[NSNumber numberWithInteger:self.areaOfServiceId] forKey:kClientConfigurationResponseAreaOfServiceId];
    [mutableDict setValue:[NSNumber numberWithInteger:self.zoneId] forKey:kClientConfigurationResponseZoneId];
    [mutableDict setValue:self.pickupInstructionsImage forKey:kClientConfigurationResponsePickupInstructionsImage];

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

    self.carServices = [aDecoder decodeObjectForKey:kClientConfigurationResponseCarServices];
    self.areaOfServiceId = [aDecoder decodeDoubleForKey:kClientConfigurationResponseAreaOfServiceId];
    self.zoneId = [aDecoder decodeDoubleForKey:kClientConfigurationResponseZoneId];
    self.pickupInstructionsImage = [aDecoder decodeObjectForKey:kClientConfigurationResponsePickupInstructionsImage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_carServices forKey:kClientConfigurationResponseCarServices];
    [aCoder encodeDouble:_areaOfServiceId forKey:kClientConfigurationResponseAreaOfServiceId];
    [aCoder encodeDouble:_zoneId forKey:kClientConfigurationResponseZoneId];
    [aCoder encodeObject:_pickupInstructionsImage forKey:kClientConfigurationResponsePickupInstructionsImage];
}

- (id)copyWithZone:(NSZone *)zone {
    ClientConfigurationResponse *copy = [[ClientConfigurationResponse alloc] init];
    
    
    
    if (copy) {

        copy.carServices = [self.carServices copyWithZone:zone];
        copy.areaOfServiceId = self.areaOfServiceId;
        copy.zoneId = self.zoneId;
        copy.pickupInstructionsImage = [self.pickupInstructionsImage copyWithZone:zone];
    }
    
    return copy;
}


@end
