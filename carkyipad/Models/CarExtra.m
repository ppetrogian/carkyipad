//
//  CarExtra.m
//
//  Created by   on 01/06/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "CarExtra.h"
#import "Price.h"


NSString *const kCarExtraIcon = @"Icon";
NSString *const kCarExtraDescription = @"Description";
NSString *const kCarExtraName = @"Name";
NSString *const kCarExtraPrice = @"Price";
NSString *const kCarExtraPriceTotal = @"PriceTotal";
NSString *const kCarExtraId = @"Id";


@interface CarExtra ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CarExtra

@synthesize icon = _icon;
@synthesize name = _name;
@synthesize price = _price;
@synthesize priceTotal = _priceTotal;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.icon = [self objectOrNilForKey:kCarExtraIcon fromDictionary:dict];
            self.carExtraDescription = [self objectOrNilForKey:kCarExtraDescription fromDictionary:dict];
            self.name = [self objectOrNilForKey:kCarExtraName fromDictionary:dict];
            self.price = [Price modelObjectWithDictionary:[dict objectForKey:kCarExtraPrice]];
            self.priceTotal = [[self objectOrNilForKey:kCarExtraPriceTotal fromDictionary:dict] doubleValue];
            self.carExtraIdentifier = [[self objectOrNilForKey:kCarExtraId fromDictionary:dict] integerValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.icon forKey:kCarExtraIcon];
    [mutableDict setValue:self.carExtraDescription forKey:kCarExtraDescription];
    [mutableDict setValue:self.name forKey:kCarExtraName];
    [mutableDict setValue:[self.price dictionaryRepresentation] forKey:kCarExtraPrice];
    [mutableDict setValue:[NSNumber numberWithDouble:self.priceTotal] forKey:kCarExtraPriceTotal];
    [mutableDict setValue:[NSNumber numberWithInteger:self.carExtraIdentifier] forKey:kCarExtraId];

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

    self.icon = [aDecoder decodeObjectForKey:kCarExtraIcon];
    self.carExtraDescription = [aDecoder decodeObjectForKey:kCarExtraDescription];
    self.name = [aDecoder decodeObjectForKey:kCarExtraName];
    self.price = [aDecoder decodeObjectForKey:kCarExtraPrice];
    self.priceTotal = [aDecoder decodeDoubleForKey:kCarExtraPriceTotal];
    self.carExtraIdentifier = [aDecoder decodeIntegerForKey:kCarExtraId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_icon forKey:kCarExtraIcon];
    [aCoder encodeObject:_carExtraDescription forKey:kCarExtraDescription];
    [aCoder encodeObject:_name forKey:kCarExtraName];
    [aCoder encodeObject:_price forKey:kCarExtraPrice];
    [aCoder encodeDouble:_priceTotal forKey:kCarExtraPriceTotal];
    [aCoder encodeInteger:_carExtraIdentifier forKey:kCarExtraId];
}

- (id)copyWithZone:(NSZone *)zone {
    CarExtra *copy = [[CarExtra alloc] init];
    
    
    
    if (copy) {

        copy.icon = [self.icon copyWithZone:zone];
        copy.carExtraDescription = [self.carExtraDescription copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.price = [self.price copyWithZone:zone];
        copy.priceTotal = self.priceTotal;
        copy.carExtraIdentifier = self.carExtraIdentifier;
    }
    
    return copy;
}


@end
