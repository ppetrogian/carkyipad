//
//  PickupDateTime.m
//
//  Created by   on 24/4/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "DateTime.h"


NSString *const kDateTimeDate = @"Date";
NSString *const kDateTimeTime = @"Time";


@interface DateTime ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DateTime

@synthesize date = _date;
@synthesize time = _time;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

+ (instancetype)modelObjectWithDate:(NSDate *)date {
    DateTime *result = [[self alloc] init];
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd";
    result.date = [df stringFromDate:date];
    df.dateFormat = @"HH:mm";
    result.time = [df stringFromDate:date];
    return result;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.date = [self objectOrNilForKey:kDateTimeDate fromDictionary:dict];
            self.time = [self objectOrNilForKey:kDateTimeTime fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.date forKey:kDateTimeDate];
    [mutableDict setValue:self.time forKey:kDateTimeTime];

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

    self.date = [aDecoder decodeObjectForKey:kDateTimeDate];
    self.time = [aDecoder decodeObjectForKey:kDateTimeTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_date forKey:kDateTimeDate];
    [aCoder encodeObject:_time forKey:kDateTimeTime];
}

- (id)copyWithZone:(NSZone *)zone {
    DateTime *copy = [[DateTime alloc] init];
    
    
    
    if (copy) {

        copy.date = [self.date copyWithZone:zone];
        copy.time = [self.time copyWithZone:zone];
    }
    
    return copy;
}


@end
