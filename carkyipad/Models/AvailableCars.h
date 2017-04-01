//
//  AvailableCars.h
//
//  Created by   on 1/4/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AvailableCars : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *cars;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
