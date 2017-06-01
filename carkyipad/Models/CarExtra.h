//
//  CarExtra.h
//
//  Created by   on 01/06/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Price;

@interface CarExtra : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *carExtraDescription;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Price *price;
@property (nonatomic, assign) double priceTotal;
@property (nonatomic, assign) NSInteger carExtraIdentifier;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
