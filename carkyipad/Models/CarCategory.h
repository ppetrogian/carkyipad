//
//  CarCategory.h
//
//  Created by   on 9/3/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CarCategory : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) NSInteger maxPassengers;
@property (nonatomic, assign) NSInteger maxLuggages;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
