//
//  ChargesForIPadResponse.m
//
//  Created by   on 19/5/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "ChargesForIPadResponse.h"


NSString *const kChargesForIPadResponseTotal = @"Total";
NSString *const kChargesForIPadResponseExtras = @"Extras";
NSString *const kChargesForIPadResponseInsurance = @"Insurance";
NSString *const kChargesForIPadResponseCar = @"Car";
NSString *const kChargesForIPadResponseChargesDescription = @"Description";
NSString *const kChargesForIPadResponseCurrency = @"Currency";

@interface ChargesForIPadResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ChargesForIPadResponse

@synthesize total = _total;
@synthesize extras = _extras;
@synthesize insurance = _insurance;
@synthesize car = _car;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.total = [[self objectOrNilForKey:kChargesForIPadResponseTotal fromDictionary:dict] doubleValue];
            self.extras = [[self objectOrNilForKey:kChargesForIPadResponseExtras fromDictionary:dict] doubleValue];
            self.insurance = [[self objectOrNilForKey:kChargesForIPadResponseInsurance fromDictionary:dict] doubleValue];
            self.car = [[self objectOrNilForKey:kChargesForIPadResponseCar fromDictionary:dict] doubleValue];
            self.chargesDescription = [self objectOrNilForKey:kChargesForIPadResponseChargesDescription fromDictionary:dict];
            self.currency = [self objectOrNilForKey:kChargesForIPadResponseCurrency fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.chargesDescription forKey:kChargesForIPadResponseChargesDescription];
    [mutableDict setValue:self.currency forKey:kChargesForIPadResponseCurrency];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kChargesForIPadResponseTotal];
    [mutableDict setValue:[NSNumber numberWithDouble:self.extras] forKey:kChargesForIPadResponseExtras];
    [mutableDict setValue:[NSNumber numberWithDouble:self.insurance] forKey:kChargesForIPadResponseInsurance];
    [mutableDict setValue:[NSNumber numberWithDouble:self.car] forKey:kChargesForIPadResponseCar];

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

    self.total = [aDecoder decodeDoubleForKey:kChargesForIPadResponseTotal];
    self.extras = [aDecoder decodeDoubleForKey:kChargesForIPadResponseExtras];
    self.insurance = [aDecoder decodeDoubleForKey:kChargesForIPadResponseInsurance];
    self.car = [aDecoder decodeDoubleForKey:kChargesForIPadResponseCar];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_total forKey:kChargesForIPadResponseTotal];
    [aCoder encodeDouble:_extras forKey:kChargesForIPadResponseExtras];
    [aCoder encodeDouble:_insurance forKey:kChargesForIPadResponseInsurance];
    [aCoder encodeDouble:_car forKey:kChargesForIPadResponseCar];
}

- (id)copyWithZone:(NSZone *)zone {
    ChargesForIPadResponse *copy = [[ChargesForIPadResponse alloc] init];
    
    
    
    if (copy) {

        copy.total = self.total;
        copy.extras = self.extras;
        copy.insurance = self.insurance;
        copy.car = self.car;
    }
    
    return copy;
}


@end
