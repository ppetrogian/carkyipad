//
//  FindDriverRequest.h
//
//  Created by   on 11/04/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LatLng;

@interface CarkyDriverPositionsRequest : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double carkyCategoryId;
@property (nonatomic, strong) LatLng *position;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
