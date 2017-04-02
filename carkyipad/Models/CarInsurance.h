//
//  CarInsurance.h
//
//  Created by   on 11/3/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Company;

@interface CarInsurance : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, assign) BOOL availability;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger pricePerDay;
@property (nonatomic, strong) Company *company;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
