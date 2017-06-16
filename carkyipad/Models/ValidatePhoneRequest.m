//
//  ValidatePhoneRequest.m
//
//  Created by   on 16/6/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "ValidatePhoneRequest.h"


NSString *const kValidatePhoneRequestNumber = @"Number";
NSString *const kValidatePhoneRequestCountryCode = @"CountryCode";


@interface ValidatePhoneRequest ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ValidatePhoneRequest

@synthesize number = _number;
@synthesize countryCode = _countryCode;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.number = [self objectOrNilForKey:kValidatePhoneRequestNumber fromDictionary:dict];
            self.countryCode = [self objectOrNilForKey:kValidatePhoneRequestCountryCode fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.number forKey:kValidatePhoneRequestNumber];
    [mutableDict setValue:self.countryCode forKey:kValidatePhoneRequestCountryCode];

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

    self.number = [aDecoder decodeObjectForKey:kValidatePhoneRequestNumber];
    self.countryCode = [aDecoder decodeObjectForKey:kValidatePhoneRequestCountryCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_number forKey:kValidatePhoneRequestNumber];
    [aCoder encodeObject:_countryCode forKey:kValidatePhoneRequestCountryCode];
}

- (id)copyWithZone:(NSZone *)zone {
    ValidatePhoneRequest *copy = [[ValidatePhoneRequest alloc] init];
    
    
    
    if (copy) {

        copy.number = [self.number copyWithZone:zone];
        copy.countryCode = [self.countryCode copyWithZone:zone];
    }
    
    return copy;
}


@end
