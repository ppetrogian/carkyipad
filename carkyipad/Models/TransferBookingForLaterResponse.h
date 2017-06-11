//
//  TransferBookingForLaterResponse.h
//
//  Created by   on 11/06/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferBookingForLaterResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *internalBaseClassDescription;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, assign) double internalBaseClassIdentifier;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
