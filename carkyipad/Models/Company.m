//
//  Company.m
//
//  Created by   on 11/3/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "Company.h"


NSString *const kCompanyTitle = @"Title";
NSString *const kCompanyCommission = @"Commission";
NSString *const kCompanyVatNumber = @"VatNumber";
NSString *const kCompanyIdentifier = @"Id";

@interface Company ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Company

@synthesize title = _title;
@synthesize commission = _commission;
@synthesize vatNumber = _vatNumber;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.title = [self objectOrNilForKey:kCompanyTitle fromDictionary:dict];
        self.commission = [[self objectOrNilForKey:kCompanyCommission fromDictionary:dict] doubleValue];
        self.vatNumber = [self objectOrNilForKey:kCompanyVatNumber fromDictionary:dict];
        self.identifier = [[self objectOrNilForKey:kCompanyIdentifier fromDictionary:dict] integerValue];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.title forKey:kCompanyTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.commission] forKey:kCompanyCommission];
    [mutableDict setValue:self.vatNumber forKey:kCompanyVatNumber];
    [mutableDict setValue:[NSNumber numberWithInteger:self.identifier] forKey:kCompanyIdentifier];
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

    self.title = [aDecoder decodeObjectForKey:kCompanyTitle];
    self.commission = [aDecoder decodeDoubleForKey:kCompanyCommission];
    self.vatNumber = [aDecoder decodeObjectForKey:kCompanyVatNumber];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_title forKey:kCompanyTitle];
    [aCoder encodeDouble:_commission forKey:kCompanyCommission];
    [aCoder encodeObject:_vatNumber forKey:kCompanyVatNumber];
}

- (id)copyWithZone:(NSZone *)zone {
    Company *copy = [[Company alloc] init];
    
    
    
    if (copy) {

        copy.title = [self.title copyWithZone:zone];
        copy.commission = self.commission;
        copy.vatNumber = [self.vatNumber copyWithZone:zone];
    }
    
    return copy;
}


@end
