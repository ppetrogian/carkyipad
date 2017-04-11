//
//  Position.m
//
//  Created by   on 11/04/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "Position.h"


NSString *const kPositionLat = @"Lat";
NSString *const kPositionLng = @"Lng";


@interface Position ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Position

@synthesize lat = _lat;
@synthesize lng = _lng;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.lat = [[self objectOrNilForKey:kPositionLat fromDictionary:dict] doubleValue];
            self.lng = [[self objectOrNilForKey:kPositionLng fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lat] forKey:kPositionLat];
    [mutableDict setValue:[NSNumber numberWithDouble:self.lng] forKey:kPositionLng];

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

    self.lat = [aDecoder decodeDoubleForKey:kPositionLat];
    self.lng = [aDecoder decodeDoubleForKey:kPositionLng];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_lat forKey:kPositionLat];
    [aCoder encodeDouble:_lng forKey:kPositionLng];
}

- (id)copyWithZone:(NSZone *)zone {
    Position *copy = [[Position alloc] init];
    
    
    
    if (copy) {

        copy.lat = self.lat;
        copy.lng = self.lng;
    }
    
    return copy;
}


@end
