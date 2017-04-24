//
//  Content.m
//
//  Created by   on 24/4/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "Content.h"
#import "LatLng.h"


NSString *const kContentPhoto = @"Photo";
NSString *const kContentRegistrationNo = @"RegistrationNo";
NSString *const kContentName = @"Name";
NSString *const kContentRating = @"Rating";
NSString *const kContentStatus = @"Status";
NSString *const kContentDriverPosition = @"DriverPosition";


@interface Content ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Content

@synthesize photo = _photo;
@synthesize registrationNo = _registrationNo;
@synthesize name = _name;
@synthesize rating = _rating;
@synthesize status = _status;
@synthesize driverPosition = _driverPosition;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.photo = [self objectOrNilForKey:kContentPhoto fromDictionary:dict];
            self.registrationNo = [self objectOrNilForKey:kContentRegistrationNo fromDictionary:dict];
            self.name = [self objectOrNilForKey:kContentName fromDictionary:dict];
            self.rating = [[self objectOrNilForKey:kContentRating fromDictionary:dict] doubleValue];
            self.status = [[self objectOrNilForKey:kContentStatus fromDictionary:dict] doubleValue];
            self.driverPosition = [LatLng modelObjectWithDictionary:[dict objectForKey:kContentDriverPosition]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.photo forKey:kContentPhoto];
    [mutableDict setValue:self.registrationNo forKey:kContentRegistrationNo];
    [mutableDict setValue:self.name forKey:kContentName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.rating] forKey:kContentRating];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kContentStatus];
    [mutableDict setValue:[self.driverPosition dictionaryRepresentation] forKey:kContentDriverPosition];

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

    self.photo = [aDecoder decodeObjectForKey:kContentPhoto];
    self.registrationNo = [aDecoder decodeObjectForKey:kContentRegistrationNo];
    self.name = [aDecoder decodeObjectForKey:kContentName];
    self.rating = [aDecoder decodeDoubleForKey:kContentRating];
    self.status = [aDecoder decodeDoubleForKey:kContentStatus];
    self.driverPosition = [aDecoder decodeObjectForKey:kContentDriverPosition];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_photo forKey:kContentPhoto];
    [aCoder encodeObject:_registrationNo forKey:kContentRegistrationNo];
    [aCoder encodeObject:_name forKey:kContentName];
    [aCoder encodeDouble:_rating forKey:kContentRating];
    [aCoder encodeDouble:_status forKey:kContentStatus];
    [aCoder encodeObject:_driverPosition forKey:kContentDriverPosition];
}

- (id)copyWithZone:(NSZone *)zone {
    Content *copy = [[Content alloc] init];
    
    
    
    if (copy) {

        copy.photo = [self.photo copyWithZone:zone];
        copy.registrationNo = [self.registrationNo copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.rating = self.rating;
        copy.status = self.status;
        copy.driverPosition = [self.driverPosition copyWithZone:zone];
    }
    
    return copy;
}


@end
