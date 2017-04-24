//
//  RegisterClientRequest
//
//  Created by   on 17/04/2017
//  Copyright (c) 2017 Nessos. All rights reserved.

#import "RegisterClientRequest.h"


NSString *const kRegisterClientModelPhoneNumber = @"PhoneNumber";
NSString *const kRegisterClientModelEmail = @"Email";
NSString *const kRegisterClientModelFirstName = @"FirstName";
NSString *const kRegisterClientModelLastName = @"LastName";
NSString *const kRegisterClientModelConfirmEmail = @"ConfirmEmail";
NSString *const kRegisterClientModelPhoneNumberCountryCode = @"PhoneNumberCountryCode";


@interface RegisterClientRequest ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RegisterClientRequest

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
            self.phoneNumber = [self objectOrNilForKey:kRegisterClientModelPhoneNumber fromDictionary:dict];
            self.email = [self objectOrNilForKey:kRegisterClientModelEmail fromDictionary:dict];
            self.firstName = [self objectOrNilForKey:kRegisterClientModelFirstName fromDictionary:dict];
            self.lastName = [self objectOrNilForKey:kRegisterClientModelLastName fromDictionary:dict];
            self.confirmEmail = [self objectOrNilForKey:kRegisterClientModelConfirmEmail fromDictionary:dict];
            self.phoneNumberCountryCode = [self objectOrNilForKey:kRegisterClientModelPhoneNumberCountryCode fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.phoneNumber forKey:kRegisterClientModelPhoneNumber];
    [mutableDict setValue:self.email forKey:kRegisterClientModelEmail];
    [mutableDict setValue:self.firstName forKey:kRegisterClientModelFirstName];
    [mutableDict setValue:self.lastName forKey:kRegisterClientModelLastName];
    [mutableDict setValue:self.confirmEmail forKey:kRegisterClientModelConfirmEmail];
    [mutableDict setValue:self.phoneNumberCountryCode forKey:kRegisterClientModelPhoneNumberCountryCode];

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

    self.phoneNumber = [aDecoder decodeObjectForKey:kRegisterClientModelPhoneNumber];
    self.email = [aDecoder decodeObjectForKey:kRegisterClientModelEmail];
    self.firstName = [aDecoder decodeObjectForKey:kRegisterClientModelFirstName];
    self.lastName = [aDecoder decodeObjectForKey:kRegisterClientModelLastName];
    self.confirmEmail = [aDecoder decodeObjectForKey:kRegisterClientModelConfirmEmail];
    self.phoneNumberCountryCode = [aDecoder decodeObjectForKey:kRegisterClientModelPhoneNumberCountryCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_phoneNumber forKey:kRegisterClientModelPhoneNumber];
    [aCoder encodeObject:_email forKey:kRegisterClientModelEmail];
    [aCoder encodeObject:_firstName forKey:kRegisterClientModelFirstName];
    [aCoder encodeObject:_lastName forKey:kRegisterClientModelLastName];
    [aCoder encodeObject:_confirmEmail forKey:kRegisterClientModelConfirmEmail];
    [aCoder encodeObject:_phoneNumberCountryCode forKey:kRegisterClientModelPhoneNumberCountryCode];
}

- (id)copyWithZone:(NSZone *)zone {
    RegisterClientRequest *copy = [[RegisterClientRequest alloc] init];
    
    
    
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
