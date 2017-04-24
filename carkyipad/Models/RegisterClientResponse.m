//
//  RegisterClientResponse.m
//
//  Created by   on 24/4/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "RegisterClientResponse.h"


NSString *const kRegisterClientResponsePhoneConfirmed = @"PhoneConfirmed";
NSString *const kRegisterClientResponseUserId = @"UserId";


@interface RegisterClientResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation RegisterClientResponse

@synthesize phoneConfirmed = _phoneConfirmed;
@synthesize userId = _userId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
            self.phoneConfirmed = [[self objectOrNilForKey:kRegisterClientResponsePhoneConfirmed fromDictionary:dict] boolValue];
            self.userId = [self objectOrNilForKey:kRegisterClientResponseUserId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.phoneConfirmed] forKey:kRegisterClientResponsePhoneConfirmed];
    [mutableDict setValue:self.userId forKey:kRegisterClientResponseUserId];

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

    self.phoneConfirmed = [aDecoder decodeBoolForKey:kRegisterClientResponsePhoneConfirmed];
    self.userId = [aDecoder decodeObjectForKey:kRegisterClientResponseUserId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_phoneConfirmed forKey:kRegisterClientResponsePhoneConfirmed];
    [aCoder encodeObject:_userId forKey:kRegisterClientResponseUserId];
}

- (id)copyWithZone:(NSZone *)zone {
    RegisterClientResponse *copy = [[RegisterClientResponse alloc] init];
    
    
    
    if (copy) {

        copy.phoneConfirmed = self.phoneConfirmed;
        copy.userId = [self.userId copyWithZone:zone];
    }
    
    return copy;
}


@end
