//
//  CarType.h
//
//  Created by   on 11/3/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CarCategory;

@interface CarType : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double fuel;
@property (nonatomic, strong) CarCategory *category;
@property (nonatomic, strong) NSString *make;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, assign) double transmission;
@property (nonatomic, assign) double Identifier;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
