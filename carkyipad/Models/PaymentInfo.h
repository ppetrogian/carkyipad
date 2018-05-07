//
//  PaymentInfo.h
//
//  Created by   on 17/05/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PaymentInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSString *paymentMethod;
@property (nonatomic, strong) NSString *stripeCardToken;
@property (nonatomic, strong) NSString *payPalResponse;
@property (nonatomic, strong) NSString *payPalAuthorizationId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
