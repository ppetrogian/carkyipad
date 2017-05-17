//
//  PickupDateTime.h
//
//  Created by   on 24/4/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DateTime : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
+ (instancetype)modelObjectWithDate:(NSDate *)date;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
