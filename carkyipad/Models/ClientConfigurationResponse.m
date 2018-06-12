//
//  ClientConfigurationResponse.m
//
//  Created by   on 23/04/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import "ClientConfigurationResponse.h"
#import "CarServices.h"
#import "Location.h"
#import "LatLng.h"

NSString *const kClientConfigurationResponseCarServices = @"CarServices";
NSString *const kClientConfigurationResponseLocation = @"Location";
NSString *const kClientConfigurationResponseTradingName = @"TradingName";
NSString *const kClientConfigurationResponseEmail = @"Email";
NSString *const kClientConfigurationResponseName = @"Name";
NSString *const kClientConfigurationResponseLastName = @"LastName";
NSString *const kClientConfigurationResponseTelephone = @"Telephone";
NSString *const kClientConfigurationResponseFirstName = @"FirstName";
NSString *const kClientConfigurationResponseAreaOfServiceId = @"AreaOfServiceId";
NSString *const kClientConfigurationResponseZoneId = @"ZoneId";
NSString *const kClientConfigurationResponsePickupInstructionsImage = @"PickupInstructionsImage";
NSString *const kClientConfigurationResponseTabletMode = @"TabletMode";
NSString *const kClientConfigurationResponsePayPalMode = @"PayPalMode";
NSString *const kClientConfigurationResponsePayPalClientId = @"PayPalClientId";
NSString *const kClientConfigurationResponseBooksLater = @"BooksLater";
NSString *const kClientConfigurationResponseRentalBackgroundImage = @"RentalBackgroundImage";
NSString *const kClientConfigurationResponseTransferBackgroundImage = @"TransferBackgroundImage";
NSString *const kClientConfigurationResponseConfirmationVideo = @"ConfirmationVideo";
NSString *const kClientConfigurationResponseAcceptsCash = @"AcceptsCash";
NSString *const kClientConfigurationResponseAirTicketsUrl = @"AirTicketsUrl";
NSString *const kClientConfigurationResponseHotelBookingImage = @"HotelBookingImage";
NSString *const kClientConfigurationResponseHotelBookingUrl = @"HotelBookingUrl";
NSString *const kClientConfigurationResponseAirTicketsImage = @"AirTicketsImage";
NSString *const kClientConfigurationResponseAllowCash = @"AllowCash";

@interface ClientConfigurationResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ClientConfigurationResponse

@synthesize carServices = _carServices;
@synthesize areaOfServiceId = _areaOfServiceId;
@synthesize zoneId = _zoneId;
@synthesize pickupInstructionsImage = _pickupInstructionsImage;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedCarServices = [dict objectForKey:kClientConfigurationResponseCarServices];
    NSMutableArray *parsedCarServices = [NSMutableArray array];
    
    if ([receivedCarServices isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCarServices) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCarServices addObject:[CarServices modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCarServices isKindOfClass:[NSDictionary class]]) {
       [parsedCarServices addObject:[CarServices modelObjectWithDictionary:(NSDictionary *)receivedCarServices]];
    }

        self.carServices = [NSArray arrayWithArray:parsedCarServices];
        NSDictionary *locDictionary = [dict objectForKey:kClientConfigurationResponseLocation];
        self.location = [Location modelObjectWithDictionary:locDictionary];
        self.location.latLng = [LatLng modelObjectWithDictionary:[locDictionary objectForKey:@"Geography"]];
        self.tradingName = [self objectOrNilForKey:kClientConfigurationResponseTradingName fromDictionary:dict];
        self.email = [self objectOrNilForKey:kClientConfigurationResponseEmail fromDictionary:dict];
        self.name = [self objectOrNilForKey:kClientConfigurationResponseName fromDictionary:dict];
        self.lastName = [self objectOrNilForKey:kClientConfigurationResponseLastName fromDictionary:dict];
        self.telephone = [self objectOrNilForKey:kClientConfigurationResponseTelephone fromDictionary:dict];
        self.firstName = [self objectOrNilForKey:kClientConfigurationResponseFirstName fromDictionary:dict];
        self.areaOfServiceId = [[self objectOrNilForKey:kClientConfigurationResponseAreaOfServiceId fromDictionary:dict] integerValue];
        self.zoneId = [[self objectOrNilForKey:kClientConfigurationResponseZoneId fromDictionary:dict] integerValue];
        self.pickupInstructionsImage = [self objectOrNilForKey:kClientConfigurationResponsePickupInstructionsImage fromDictionary:dict];
        self.tabletMode = [self objectOrNilForKey:kClientConfigurationResponseTabletMode fromDictionary:dict];
        self.payPalMode = [self objectOrNilForKey:kClientConfigurationResponsePayPalMode fromDictionary:dict];
        self.payPalClientId = [self objectOrNilForKey:kClientConfigurationResponsePayPalClientId fromDictionary:dict];
        self.booksLater = [[self objectOrNilForKey:kClientConfigurationResponseBooksLater fromDictionary:dict] boolValue];
        self.rentalBackgroundImage = [self objectOrNilForKey:kClientConfigurationResponseRentalBackgroundImage fromDictionary:dict];
        self.transferBackgroundImage = [self objectOrNilForKey:kClientConfigurationResponseTransferBackgroundImage fromDictionary:dict];
        self.confirmationVideo = [self objectOrNilForKey:kClientConfigurationResponseConfirmationVideo fromDictionary:dict];
        self.airTicketsUrl = [self objectOrNilForKey:kClientConfigurationResponseAirTicketsUrl fromDictionary:dict];
        self.hotelBookingImage = [self objectOrNilForKey:kClientConfigurationResponseHotelBookingImage fromDictionary:dict];
        self.hotelBookingUrl = [self objectOrNilForKey:kClientConfigurationResponseHotelBookingUrl fromDictionary:dict];
        self.airTicketsImage = [self objectOrNilForKey:kClientConfigurationResponseAirTicketsImage fromDictionary:dict];
        self.allowCash = [[self objectOrNilForKey:kClientConfigurationResponseAllowCash fromDictionary:dict] boolValue];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForCarServices = [NSMutableArray array];
    
    for (NSObject *subArrayObject in self.carServices) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCarServices addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCarServices addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCarServices] forKey:kClientConfigurationResponseCarServices];
    [mutableDict setValue:[self.location dictionaryRepresentation] forKey:kClientConfigurationResponseLocation];
    [mutableDict setValue:self.tradingName forKey:kClientConfigurationResponseTradingName];
    [mutableDict setValue:self.email forKey:kClientConfigurationResponseEmail];
    [mutableDict setValue:self.name forKey:kClientConfigurationResponseName];
    [mutableDict setValue:self.lastName forKey:kClientConfigurationResponseLastName];
    [mutableDict setValue:self.telephone forKey:kClientConfigurationResponseTelephone];
    [mutableDict setValue:self.firstName forKey:kClientConfigurationResponseFirstName];
    [mutableDict setValue:[NSNumber numberWithInteger:self.areaOfServiceId] forKey:kClientConfigurationResponseAreaOfServiceId];
    [mutableDict setValue:[NSNumber numberWithInteger:self.zoneId] forKey:kClientConfigurationResponseZoneId];
    [mutableDict setValue:self.pickupInstructionsImage forKey:kClientConfigurationResponsePickupInstructionsImage];
    [mutableDict setValue:self.tabletMode forKey:kClientConfigurationResponseTabletMode];
    [mutableDict setValue:self.payPalMode forKey:kClientConfigurationResponsePayPalMode];
    [mutableDict setValue:self.payPalClientId forKey:kClientConfigurationResponsePayPalClientId];
    [mutableDict setValue:[NSNumber numberWithBool:self.booksLater] forKey:kClientConfigurationResponseBooksLater];
    [mutableDict setValue:self.rentalBackgroundImage forKey:kClientConfigurationResponseRentalBackgroundImage];
    [mutableDict setValue:self.transferBackgroundImage forKey:kClientConfigurationResponseTransferBackgroundImage];
    [mutableDict setValue:self.confirmationVideo forKey:kClientConfigurationResponseConfirmationVideo];
    [mutableDict setValue:self.airTicketsUrl forKey:kClientConfigurationResponseAirTicketsUrl];
    [mutableDict setValue:self.hotelBookingImage forKey:kClientConfigurationResponseHotelBookingImage];
    [mutableDict setValue:self.hotelBookingUrl forKey:kClientConfigurationResponseHotelBookingUrl];
    [mutableDict setValue:self.airTicketsImage forKey:kClientConfigurationResponseAirTicketsImage];
    [mutableDict setValue:[NSNumber numberWithBool:self.allowCash] forKey:kClientConfigurationResponseAllowCash];
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

    self.carServices = [aDecoder decodeObjectForKey:kClientConfigurationResponseCarServices];
    self.areaOfServiceId = [aDecoder decodeDoubleForKey:kClientConfigurationResponseAreaOfServiceId];
    self.zoneId = [aDecoder decodeDoubleForKey:kClientConfigurationResponseZoneId];
    self.pickupInstructionsImage = [aDecoder decodeObjectForKey:kClientConfigurationResponsePickupInstructionsImage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_carServices forKey:kClientConfigurationResponseCarServices];
    [aCoder encodeDouble:_areaOfServiceId forKey:kClientConfigurationResponseAreaOfServiceId];
    [aCoder encodeDouble:_zoneId forKey:kClientConfigurationResponseZoneId];
    [aCoder encodeObject:_pickupInstructionsImage forKey:kClientConfigurationResponsePickupInstructionsImage];
    [aCoder encodeObject:_tradingName forKey:kClientConfigurationResponseTradingName];
    [aCoder encodeObject:_email forKey:kClientConfigurationResponseEmail];
    [aCoder encodeObject:_name forKey:kClientConfigurationResponseName];
    [aCoder encodeObject:_lastName forKey:kClientConfigurationResponseLastName];
    [aCoder encodeObject:_telephone forKey:kClientConfigurationResponseTelephone];
    [aCoder encodeObject:_firstName forKey:kClientConfigurationResponseFirstName];
    [aCoder encodeObject:_rentalBackgroundImage forKey:kClientConfigurationResponseRentalBackgroundImage];
    [aCoder encodeObject:_transferBackgroundImage forKey:kClientConfigurationResponseTransferBackgroundImage];
    [aCoder encodeObject:_confirmationVideo forKey:kClientConfigurationResponseConfirmationVideo];
    [aCoder encodeObject:_tabletMode forKey:kClientConfigurationResponseTabletMode];
}

- (id)copyWithZone:(NSZone *)zone {
    ClientConfigurationResponse *copy = [[ClientConfigurationResponse alloc] init];
    
    
    
    if (copy) {
        copy.tradingName = [self.tradingName copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.lastName = [self.lastName copyWithZone:zone];
        copy.telephone = [self.telephone copyWithZone:zone];
        copy.firstName = [self.firstName copyWithZone:zone];
        copy.carServices = [self.carServices copyWithZone:zone];
        copy.areaOfServiceId = self.areaOfServiceId;
        copy.zoneId = self.zoneId;
        copy.pickupInstructionsImage = [self.pickupInstructionsImage copyWithZone:zone];
        copy.rentalBackgroundImage = [self.rentalBackgroundImage copyWithZone:zone];
        copy.transferBackgroundImage = [self.transferBackgroundImage copyWithZone:zone];
        copy.confirmationVideo = [self.confirmationVideo copyWithZone:zone];
        copy.tabletMode = [self.tabletMode copyWithZone:zone];
    }
    
    return copy;
}


@end
