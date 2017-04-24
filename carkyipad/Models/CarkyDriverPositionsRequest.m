//
//  FindDriverRequest.m
//
//  Created by   on 11/04/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "CarkyDriverPositionsRequest.h"
#import "LatLng.h"


NSString *const kFindDriverRequestCarkyCategoryId = @"CarkyCategoryId";
NSString *const kFindDriverRequestPosition = @"Position";


@interface CarkyDriverPositionsRequest ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CarkyDriverPositionsRequest

@synthesize carkyCategoryId = _carkyCategoryId;
@synthesize position = _position;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.carkyCategoryId = [[self objectOrNilForKey:kFindDriverRequestCarkyCategoryId fromDictionary:dict] doubleValue];
            self.position = [LatLng modelObjectWithDictionary:[dict objectForKey:kFindDriverRequestPosition]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.carkyCategoryId] forKey:kFindDriverRequestCarkyCategoryId];
    [mutableDict setValue:[self.position dictionaryRepresentation] forKey:kFindDriverRequestPosition];

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

    self.carkyCategoryId = [aDecoder decodeDoubleForKey:kFindDriverRequestCarkyCategoryId];
    self.position = [aDecoder decodeObjectForKey:kFindDriverRequestPosition];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_carkyCategoryId forKey:kFindDriverRequestCarkyCategoryId];
    [aCoder encodeObject:_position forKey:kFindDriverRequestPosition];
}

- (id)copyWithZone:(NSZone *)zone {
    CarkyDriverPositionsRequest *copy = [[CarkyDriverPositionsRequest alloc] init];
    
    
    
    if (copy) {

        copy.carkyCategoryId = self.carkyCategoryId;
        copy.position = [self.position copyWithZone:zone];
    }
    
    return copy;
}


@end
