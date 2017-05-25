//
//  CarInsurance.m
//
//  Created by   on 11/3/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "CarInsurance.h"
#import "Company.h"


NSString *const kCarInsuranceId = @"Id";
NSString *const kBCarInsuranceAvailability = @"Availability";
NSString *const kBCarInsuranceTitle = @"Title";
NSString *const kBCarInsurancePricePerDay = @"PricePerDay";
NSString *const kBCarInsurancePriceTotal = @"PriceTotal";
NSString *const kBCarInsuranceCompany = @"Company";
NSString *const kBCarInsuranceDescription = @"Description";
NSString *const kBCarInsuranceDetails = @"Details";
NSString *const kBCarInsuranceIcon = @"Icon";

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
        self.availability = [[self objectOrNilForKey:kBCarInsuranceAvailability fromDictionary:dict] boolValue];
        self.Id = [[self objectOrNilForKey:kCarInsuranceId fromDictionary:dict] integerValue];
        self.title = [self objectOrNilForKey:kBCarInsuranceTitle fromDictionary:dict];
        self.pricePerDay = [[self objectOrNilForKey:kBCarInsurancePricePerDay fromDictionary:dict] integerValue];
        self.priceTotal = [[self objectOrNilForKey:kBCarInsurancePriceTotal fromDictionary:dict] doubleValue];
        self.company = [Company modelObjectWithDictionary:[dict objectForKey:kBCarInsuranceCompany]];
        self.insuranceDescription = [self objectOrNilForKey:kBCarInsuranceDescription fromDictionary:dict];
        self.details = [self objectOrNilForKey:kBCarInsuranceDetails fromDictionary:dict];
        self.icon = [self objectOrNilForKey:kBCarInsuranceIcon fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.availability] forKey:kBCarInsuranceAvailability];
    [mutableDict setValue:[NSNumber numberWithInteger:self.Id] forKey:kCarInsuranceId];
    [mutableDict setValue:self.title forKey:kBCarInsuranceTitle];
    [mutableDict setValue:[NSNumber numberWithInteger:self.pricePerDay] forKey:kBCarInsurancePricePerDay];
    [mutableDict setValue:[NSNumber numberWithDouble:self.priceTotal] forKey:kBCarInsurancePriceTotal];
    [mutableDict setValue:[self.company dictionaryRepresentation] forKey:kBCarInsuranceCompany];
     [mutableDict setValue:self.insuranceDescription forKey:kBCarInsuranceDescription];
     [mutableDict setValue:self.details forKey:kBCarInsuranceDetails];
     [mutableDict setValue:self.icon forKey:kBCarInsuranceIcon];

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

    self.availability = [aDecoder decodeBoolForKey:kBCarInsuranceAvailability];
    self.title = [aDecoder decodeObjectForKey:kBCarInsuranceTitle];
    self.pricePerDay = [aDecoder decodeDoubleForKey:kBCarInsurancePricePerDay];
    self.company = [aDecoder decodeObjectForKey:kBCarInsuranceCompany];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_availability forKey:kBCarInsuranceAvailability];
    [aCoder encodeObject:_title forKey:kBCarInsuranceTitle];
    [aCoder encodeDouble:_pricePerDay forKey:kBCarInsurancePricePerDay];
    [aCoder encodeObject:_company forKey:kBCarInsuranceCompany];
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
