//
//  CarExtra.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 11/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "CarExtra.h"


NSString *const kCarExtraPricePerDay = @"PricePerDay";
NSString *const kCarExtraPriceTotal = @"PriceTotal";
NSString *const kCarExtraPrice = @"Price";
NSString *const kCarExtraId = @"Id";
NSString *const kCarExtraName = @"Name";
NSString *const kCarExtraIcon = @"Icon";
NSString *const kCarExtraDescription = @"Description";


@interface CarExtra ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CarExtra

@synthesize pricePerDay = _pricePerDay;
@synthesize Id = _Id;
@synthesize Name = _Name;
@synthesize Description = _Description;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.pricePerDay = [[self objectOrNilForKey:kCarExtraPricePerDay fromDictionary:dict] integerValue];
        self.price = [[self objectOrNilForKey:kCarExtraPrice fromDictionary:dict] integerValue];
        self.priceTotal = [[self objectOrNilForKey:kCarExtraPriceTotal fromDictionary:dict] doubleValue];
        self.Id = [[self objectOrNilForKey:kCarExtraId fromDictionary:dict] integerValue];
        self.Name = [self objectOrNilForKey:kCarExtraName fromDictionary:dict];
        self.icon = [self objectOrNilForKey:kCarExtraIcon fromDictionary:dict];
        self.Description = [self objectOrNilForKey:kCarExtraDescription fromDictionary:dict];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInteger:self.pricePerDay] forKey:kCarExtraPricePerDay];
    [mutableDict setValue:[NSNumber numberWithInteger:self.price] forKey:kCarExtraPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.priceTotal] forKey:kCarExtraPriceTotal];
    [mutableDict setValue:[NSNumber numberWithInteger:self.Id] forKey:kCarExtraId];
    [mutableDict setValue:self.Name forKey:kCarExtraName];
    [mutableDict setValue:self.icon forKey:kCarExtraIcon];
    [mutableDict setValue:self.Description forKey:kCarExtraDescription];
    
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
    
    self.pricePerDay = [aDecoder decodeIntegerForKey:kCarExtraPricePerDay];
    self.Id = [aDecoder decodeIntegerForKey:kCarExtraId];
    self.Name = [aDecoder decodeObjectForKey:kCarExtraName];
    self.Description = [aDecoder decodeObjectForKey:kCarExtraDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeInteger:_pricePerDay forKey:kCarExtraPricePerDay];
    [aCoder encodeInteger:_Id forKey:kCarExtraId];
    [aCoder encodeObject:_Name forKey:kCarExtraName];
    [aCoder encodeObject:_Description forKey:kCarExtraDescription];
}

- (id)copyWithZone:(NSZone *)zone {
    CarExtra *copy = [[CarExtra alloc] init];
    
    
    
    if (copy) {
        
        copy.pricePerDay = self.pricePerDay;
        copy.Id = self.Id;
        copy.Name = [self.Name copyWithZone:zone];
        copy.Description = [self.Description copyWithZone:zone];
    }
    
    return copy;
}


@end
