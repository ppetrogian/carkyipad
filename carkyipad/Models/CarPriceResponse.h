//
//  CarPriceResponse.h
//
//  Created by   on 23/04/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CarPriceResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *carPrice;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
