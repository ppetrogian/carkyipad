//
//  BaseClass.h
//
//  Created by   on 9/3/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CarCategory : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double price;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSString *Description;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
