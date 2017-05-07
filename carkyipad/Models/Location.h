//
//  Locations.h
//
//  Created by   on 9/3/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LatLng;
extern NSString *const kLocationsIdentifier;
extern NSString *const kLocationsZoneId;
extern NSString *const kLocationsName;
extern NSString *const kLocationsAdress;
extern NSString *const kLocationsPlaceId;
extern NSString *const kLocationsLatLng;

@interface Location : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger zoneId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *placeId;
@property (nonatomic, strong) LatLng *latLng;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
