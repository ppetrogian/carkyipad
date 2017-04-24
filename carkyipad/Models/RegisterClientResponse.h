//
//  RegisterClientResponse.h
//
//  Created by   on 24/4/17
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface RegisterClientResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL phoneConfirmed;
@property (nonatomic, strong) NSString *userId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
