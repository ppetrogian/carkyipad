//
//  Content.h
//
//  Created by   on 24/4/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LatLng;

@interface Content : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *registrationNo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double rating;
@property (nonatomic, assign) double status;
@property (nonatomic, strong) LatLng *driverPosition;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
