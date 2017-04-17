//
//  TransferBookingRequest.h
//
//  Created by   on 17/04/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccountBindingModel, LatLng;

@interface TransferBookingRequest : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *dropoffAddress;
@property (nonatomic, strong) NSString *pickupAddress;
@property (nonatomic, strong) NSString *stripeCardToken;
@property (nonatomic, assign) NSInteger passengersNumber;
@property (nonatomic, strong) LatLng *dropoffLatLng;
@property (nonatomic, assign) BOOL agreedToTermsAndConditions;
@property (nonatomic, strong) AccountBindingModel *accountBindingModel;
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, assign) NSInteger paymentMethod;
@property (nonatomic, strong) LatLng *pickupLatLng;
@property (nonatomic, strong) NSArray<NSNumber*> *extras;
@property (nonatomic, assign) NSInteger carTypeId;
@property (nonatomic, assign) NSInteger luggagePiecesNumber;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
