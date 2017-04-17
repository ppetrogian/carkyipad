//
//  AccountBindingModel.m
//
//  Created by   on 17/04/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "AccountBindingModel.h"


NSString *const kAccountBindingModelPhoneNumber = @"PhoneNumber";
NSString *const kAccountBindingModelEmail = @"Email";
NSString *const kAccountBindingModelFirstName = @"FirstName";
NSString *const kAccountBindingModelLastName = @"LastName";
NSString *const kAccountBindingModelConfirmEmail = @"ConfirmEmail";
NSString *const kAccountBindingModelPhoneNumberCountryCode = @"PhoneNumberCountryCode";


@interface AccountBindingModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AccountBindingModel

@synthesize phoneNumber = _phoneNumber;
@synthesize email = _email;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize confirmEmail = _confirmEmail;
@synthesize phoneNumberCountryCode = _phoneNumberCountryCode;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.phoneNumber = [self objectOrNilForKey:kAccountBindingModelPhoneNumber fromDictionary:dict];
            self.email = [self objectOrNilForKey:kAccountBindingModelEmail fromDictionary:dict];
            self.firstName = [self objectOrNilForKey:kAccountBindingModelFirstName fromDictionary:dict];
            self.lastName = [self objectOrNilForKey:kAccountBindingModelLastName fromDictionary:dict];
            self.confirmEmail = [self objectOrNilForKey:kAccountBindingModelConfirmEmail fromDictionary:dict];
            self.phoneNumberCountryCode = [self objectOrNilForKey:kAccountBindingModelPhoneNumberCountryCode fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.phoneNumber forKey:kAccountBindingModelPhoneNumber];
    [mutableDict setValue:self.email forKey:kAccountBindingModelEmail];
    [mutableDict setValue:self.firstName forKey:kAccountBindingModelFirstName];
    [mutableDict setValue:self.lastName forKey:kAccountBindingModelLastName];
    [mutableDict setValue:self.confirmEmail forKey:kAccountBindingModelConfirmEmail];
    [mutableDict setValue:self.phoneNumberCountryCode forKey:kAccountBindingModelPhoneNumberCountryCode];

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

    self.phoneNumber = [aDecoder decodeObjectForKey:kAccountBindingModelPhoneNumber];
    self.email = [aDecoder decodeObjectForKey:kAccountBindingModelEmail];
    self.firstName = [aDecoder decodeObjectForKey:kAccountBindingModelFirstName];
    self.lastName = [aDecoder decodeObjectForKey:kAccountBindingModelLastName];
    self.confirmEmail = [aDecoder decodeObjectForKey:kAccountBindingModelConfirmEmail];
    self.phoneNumberCountryCode = [aDecoder decodeObjectForKey:kAccountBindingModelPhoneNumberCountryCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_phoneNumber forKey:kAccountBindingModelPhoneNumber];
    [aCoder encodeObject:_email forKey:kAccountBindingModelEmail];
    [aCoder encodeObject:_firstName forKey:kAccountBindingModelFirstName];
    [aCoder encodeObject:_lastName forKey:kAccountBindingModelLastName];
    [aCoder encodeObject:_confirmEmail forKey:kAccountBindingModelConfirmEmail];
    [aCoder encodeObject:_phoneNumberCountryCode forKey:kAccountBindingModelPhoneNumberCountryCode];
}

- (id)copyWithZone:(NSZone *)zone {
    AccountBindingModel *copy = [[AccountBindingModel alloc] init];
    
    
    
    if (copy) {

        copy.phoneNumber = [self.phoneNumber copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.firstName = [self.firstName copyWithZone:zone];
        copy.lastName = [self.lastName copyWithZone:zone];
        copy.confirmEmail = [self.confirmEmail copyWithZone:zone];
        copy.phoneNumberCountryCode = [self.phoneNumberCountryCode copyWithZone:zone];
    }
    
    return copy;
}


@end
