//
//  ValidatePhoneRequest.h
//
//  Created by   on 16/6/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ValidatePhoneRequest : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *countryCode;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
