//
//  PayPalPaymentInfo.h
//
//  Created by   on 19/5/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PayPalPaymentInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *payPalPaymentInfoDescription;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *amount;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
