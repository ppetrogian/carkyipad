//
//  PickupDateTime.m
//
//  Created by   on 24/4/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "PickupDateTime.h"


NSString *const kPickupDateTimeDate = @"Date";
NSString *const kPickupDateTimeTime = @"Time";


@interface PickupDateTime ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PickupDateTime

@synthesize date = _date;
@synthesize time = _time;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.date = [self objectOrNilForKey:kPickupDateTimeDate fromDictionary:dict];
            self.time = [self objectOrNilForKey:kPickupDateTimeTime fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.date forKey:kPickupDateTimeDate];
    [mutableDict setValue:self.time forKey:kPickupDateTimeTime];

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

    self.date = [aDecoder decodeObjectForKey:kPickupDateTimeDate];
    self.time = [aDecoder decodeObjectForKey:kPickupDateTimeTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_date forKey:kPickupDateTimeDate];
    [aCoder encodeObject:_time forKey:kPickupDateTimeTime];
}

- (id)copyWithZone:(NSZone *)zone {
    PickupDateTime *copy = [[PickupDateTime alloc] init];
    
    
    
    if (copy) {

        copy.date = [self.date copyWithZone:zone];
        copy.time = [self.time copyWithZone:zone];
    }
    
    return copy;
}


@end
