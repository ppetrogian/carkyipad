//
//  CarkyBookingStatusResponse.m
//
//  Created by   on 24/4/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "CarkyBookingStatusResponse.h"
#import "Content.h"


NSString *const kCarkyBookingStatusResponseMessage = @"Message";
NSString *const kCarkyBookingStatusResponseContent = @"Content";


@interface CarkyBookingStatusResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CarkyBookingStatusResponse

@synthesize message = _message;
@synthesize content = _content;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.message = [self objectOrNilForKey:kCarkyBookingStatusResponseMessage fromDictionary:dict];
            self.content = [Content modelObjectWithDictionary:[dict objectForKey:kCarkyBookingStatusResponseContent]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.message forKey:kCarkyBookingStatusResponseMessage];
    [mutableDict setValue:[self.content dictionaryRepresentation] forKey:kCarkyBookingStatusResponseContent];

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

    self.message = [aDecoder decodeObjectForKey:kCarkyBookingStatusResponseMessage];
    self.content = [aDecoder decodeObjectForKey:kCarkyBookingStatusResponseContent];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_message forKey:kCarkyBookingStatusResponseMessage];
    [aCoder encodeObject:_content forKey:kCarkyBookingStatusResponseContent];
}

- (id)copyWithZone:(NSZone *)zone {
    CarkyBookingStatusResponse *copy = [[CarkyBookingStatusResponse alloc] init];
    
    
    
    if (copy) {

        copy.message = [self.message copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
    }
    
    return copy;
}


@end
