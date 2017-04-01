//
//  FleetLocation.h
//
//  Created by   on 9/3/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Location;


@interface FleetLocations : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSNumber *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSArray<Location *> *locations;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
