//
//  Company.h
//
//  Created by   on 11/3/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Company : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double commission;
@property (nonatomic, strong) NSString *vatNumber;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
