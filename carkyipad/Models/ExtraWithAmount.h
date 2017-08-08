//
//  ExtraWithAmount.h
//
//  Created by   on 08/08/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ExtraWithAmount : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) double amount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
