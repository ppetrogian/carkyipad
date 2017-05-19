//
//  ChargesForIPadResponse.h
//
//  Created by   on 19/5/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ChargesForIPadResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double total;
@property (nonatomic, assign) double extras;
@property (nonatomic, assign) double insurance;
@property (nonatomic, assign) double car;
@property (nonatomic, strong) NSString *chargesDescription;
@property (nonatomic, strong) NSString *currency;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
