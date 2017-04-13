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
NSString *const kCarCategoryDescription = @"Description";
NSString *const kCarCategoryMaxPassengers = @"MaxPassengers";
NSString *const kCarCategoryMaxLaggages = @"MaxLaggages";


@interface CarCategory ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CarCategory

@synthesize price = _price;
@synthesize Id = _Id;
@synthesize Description = _Description;


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
        self.Description = [self objectOrNilForKey:kCarCategoryDescription fromDictionary:dict];
        self.image = [self objectOrNilForKey:kCarCategoryImage fromDictionary:dict];
        self.maxPassengers = [[self objectOrNilForKey:kCarCategoryMaxPassengers fromDictionary:dict] integerValue];
        self.maxLaggages = [[self objectOrNilForKey:kCarCategoryMaxLaggages fromDictionary:dict] integerValue];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInteger:self.price] forKey:kCarCategoryPrice];
    [mutableDict setValue:[NSNumber numberWithInteger:self.Id] forKey:kCarCategoryId];
    [mutableDict setValue:self.Description forKey:kCarCategoryDescription];
    [mutableDict setValue:self.image forKey:kCarCategoryImage];
    [mutableDict setValue:[NSNumber numberWithInteger:self.maxPassengers] forKey:kCarCategoryMaxPassengers];
    [mutableDict setValue:[NSNumber numberWithInteger:self.maxLaggages] forKey:kCarCategoryMaxLaggages];

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
    self.Description = [aDecoder decodeObjectForKey:kCarCategoryDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_price forKey:kCarCategoryPrice];
    [aCoder encodeInteger:_Id forKey:kCarCategoryId];
    [aCoder encodeObject:_Description forKey:kCarCategoryDescription];
}

- (id)copyWithZone:(NSZone *)zone {
    CarCategory *copy = [[CarCategory alloc] init];
    
    
    
    if (copy) {

        copy.price = self.price;
        copy.Id = self.Id;
        copy.Description = [self.Description copyWithZone:zone];
    }
    
    return copy;
}


@end
