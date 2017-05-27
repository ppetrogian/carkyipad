//
//  Cars.h
//
//  Created by   on 1/4/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Cars : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger transmissionType;
@property (nonatomic, assign) NSInteger maxPassengers;
@property (nonatomic, assign) NSInteger maxLaggages;
@property (nonatomic, assign) NSInteger carsIdentifier;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger pricePerDay;
@property (nonatomic, assign) double priceTotal;
@property (nonatomic, strong) NSString *subDescription;
@property (nonatomic, assign) NSInteger fuelType;
@property (nonatomic, strong) NSString *carsDescription;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign) NSInteger order;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
