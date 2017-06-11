//
//  TransferBookingRequest.h
//
//  Created by   on 17/04/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LatLng,DateTime,Location;

@interface TransferBookingRequest : NSObject <NSCoding, NSCopying>
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *dropoffAddress;
@property (nonatomic, strong) NSString *pickupAddress;
@property (nonatomic, strong) NSString *stripeCardToken;
@property (nonatomic, strong) NSString *payPalPaymentResponse;
@property (nonatomic, strong) NSString *payPalPayerId;

@property (nonatomic, strong) NSString *notes;
@property (nonatomic, assign) NSInteger passengersNumber;
@property (nonatomic, strong) Location *dropoffLocation;
@property (nonatomic, assign) NSInteger dropoffWellKnownLocationId;
@property (nonatomic, assign) BOOL agreedToTermsAndConditions;

@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, strong) DateTime *pickupDateTime;
@property (nonatomic, assign) NSInteger paymentMethod;
@property (nonatomic, strong) LatLng *pickupLatLng;
@property (nonatomic, strong) NSArray<NSNumber*> *extras;
@property (nonatomic, assign) NSInteger carkyCategoryId;
@property (nonatomic, assign) NSInteger luggagePiecesNumber;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

/*
 {
 "UserId": "string",
 "PaymentMethod": 0,
 "StripeCardToken": "string",
 "PayPalPaymentResponse": "string",
 "CarkyCategoryId": 0,
 "Extras": [
 0
 ],
 "DropoffWellKnownLocationId": 0,
 "DropoffLocation": {
    "Address": "string",
    "Geography": {
        "Lat": 0,"Lng": 0
    }
 },
 "Notes": "string",
 "PickupDateTime": {
    "Date": "string",
    "Time": "string"
 },
 "PassengersNumber": 0,
 "LuggagePiecesNumber": 0,
 "AgreedToTermsAndConditions": true
 }
*/
