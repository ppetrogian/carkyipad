//
//  Locations.h
//
//  Created by   on 9/3/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LatLng;

@interface Location : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *placeId;
@property (nonatomic, strong) LatLng *latLng;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
