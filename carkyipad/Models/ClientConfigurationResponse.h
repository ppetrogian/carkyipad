//
//  ClientConfigurationResponse.h
//
//  Created by   on 23/04/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Location;

@interface ClientConfigurationResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *carServices;
@property (nonatomic, assign) NSInteger areaOfServiceId;
@property (nonatomic, assign) NSInteger zoneId;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSString *pickupInstructionsImage;
@property (nonatomic, assign) NSInteger tabletMode;
@property (nonatomic, strong) NSString *payPalMode;
@property (nonatomic, strong) NSString *payPalClientId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
