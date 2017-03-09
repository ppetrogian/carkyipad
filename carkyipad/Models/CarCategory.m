//
//  CarCategory
//
//  Created by   on 9/3/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "CarCategory.h"


NSString *const kPrice = @"Price";
NSString *const kId = @"Id";
NSString *const kDescription = @"Description";


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
            self.price = [[self objectOrNilForKey:kPrice fromDictionary:dict] doubleValue];
            self.Id = [[self objectOrNilForKey:kId fromDictionary:dict] integerValue];
            self.Description = [self objectOrNilForKey:kDescription fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.price] forKey:kPrice];
    [mutableDict setValue:[NSNumber numberWithInteger:self.Id] forKey:kId];
    [mutableDict setValue:self.Description forKey:kDescription];

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

    self.price = [aDecoder decodeDoubleForKey:kPrice];
    self.Id = [aDecoder decodeIntegerForKey:kId];
    self.Description = [aDecoder decodeObjectForKey:kDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_price forKey:kPrice];
    [aCoder encodeInteger:_Id forKey:kId];
    [aCoder encodeObject:_Description forKey:kDescription];
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
