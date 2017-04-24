//
//  CarPrice.h
//
//  Created by   on 23/04/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CarPrice : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger carServiceId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
