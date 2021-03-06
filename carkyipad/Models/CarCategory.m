//
//  CarCategory
//
//  Created by   on 9/3/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "CarCategory.h"


NSString *const kCarCategoryPrice = @"Price";
NSString *const kCarCategoryId = @"Id";
NSString *const kCarCategoryImage = @"Image";
NSString *const kCarCategoryName = @"Name";
NSString *const kCarCategoryMaxPassengers = @"MaxPassengers";
NSString *const kCarCategoryMaxLuggages = @"MaxLuggages";


@interface CarCategory ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CarCategory


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.price = [[self objectOrNilForKey:kCarCategoryPrice fromDictionary:dict] integerValue];
        self.Id = [[self objectOrNilForKey:kCarCategoryId fromDictionary:dict] integerValue];
        self.name = [self objectOrNilForKey:kCarCategoryName fromDictionary:dict];
        self.image = [self objectOrNilForKey:kCarCategoryImage fromDictionary:dict];
        self.maxPassengers = [[self objectOrNilForKey:kCarCategoryMaxPassengers fromDictionary:dict] integerValue];
        self.maxLuggages = [[self objectOrNilForKey:kCarCategoryMaxLuggages fromDictionary:dict] integerValue];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInteger:self.price] forKey:kCarCategoryPrice];
    [mutableDict setValue:[NSNumber numberWithInteger:self.Id] forKey:kCarCategoryId];
    [mutableDict setValue:self.name forKey:kCarCategoryName];
    [mutableDict setValue:self.image forKey:kCarCategoryImage];
    [mutableDict setValue:[NSNumber numberWithInteger:self.maxPassengers] forKey:kCarCategoryMaxPassengers];
    [mutableDict setValue:[NSNumber numberWithInteger:self.maxLuggages] forKey:kCarCategoryMaxLuggages];

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

    self.price = [aDecoder decodeDoubleForKey:kCarCategoryPrice];
    self.Id = [aDecoder decodeIntegerForKey:kCarCategoryId];
    self.name = [aDecoder decodeObjectForKey:kCarCategoryName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_price forKey:kCarCategoryPrice];
    [aCoder encodeInteger:_Id forKey:kCarCategoryId];
    [aCoder encodeObject:_name forKey:kCarCategoryName];
}

- (id)copyWithZone:(NSZone *)zone {
    CarCategory *copy = [[CarCategory alloc] init];
    
    
    
    if (copy) {

        copy.price = self.price;
        copy.Id = self.Id;
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
