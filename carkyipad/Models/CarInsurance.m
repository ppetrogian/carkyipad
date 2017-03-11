//
//  CarInsurance.m
//
//  Created by   on 11/3/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "CarInsurance.h"
#import "Company.h"


NSString *const kBaseClassAvailability = @"Availability";
NSString *const kBaseClassTitle = @"Title";
NSString *const kBaseClassPricePerDay = @"PricePerDay";
NSString *const kBaseClassCompany = @"Company";


@interface CarInsurance ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CarInsurance

@synthesize availability = _availability;
@synthesize title = _title;
@synthesize pricePerDay = _pricePerDay;
@synthesize company = _company;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.availability = [[self objectOrNilForKey:kBaseClassAvailability fromDictionary:dict] boolValue];
            self.title = [self objectOrNilForKey:kBaseClassTitle fromDictionary:dict];
            self.pricePerDay = [[self objectOrNilForKey:kBaseClassPricePerDay fromDictionary:dict] doubleValue];
            self.company = [Company modelObjectWithDictionary:[dict objectForKey:kBaseClassCompany]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.availability] forKey:kBaseClassAvailability];
    [mutableDict setValue:self.title forKey:kBaseClassTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pricePerDay] forKey:kBaseClassPricePerDay];
    [mutableDict setValue:[self.company dictionaryRepresentation] forKey:kBaseClassCompany];

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

    self.availability = [aDecoder decodeBoolForKey:kBaseClassAvailability];
    self.title = [aDecoder decodeObjectForKey:kBaseClassTitle];
    self.pricePerDay = [aDecoder decodeDoubleForKey:kBaseClassPricePerDay];
    self.company = [aDecoder decodeObjectForKey:kBaseClassCompany];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_availability forKey:kBaseClassAvailability];
    [aCoder encodeObject:_title forKey:kBaseClassTitle];
    [aCoder encodeDouble:_pricePerDay forKey:kBaseClassPricePerDay];
    [aCoder encodeObject:_company forKey:kBaseClassCompany];
}

- (id)copyWithZone:(NSZone *)zone {
    CarInsurance *copy = [[CarInsurance alloc] init];
    
    
    
    if (copy) {

        copy.availability = self.availability;
        copy.title = [self.title copyWithZone:zone];
        copy.pricePerDay = self.pricePerDay;
        copy.company = [self.company copyWithZone:zone];
    }
    
    return copy;
}


@end
