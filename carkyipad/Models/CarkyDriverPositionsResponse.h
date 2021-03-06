//
//  CarkyDriverPositionsResponse.h
//
//  Created by   on 12/04/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LatLng;

@interface CarkyDriverPositionsResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double driverId;
@property (nonatomic, strong) LatLng *latLng;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
