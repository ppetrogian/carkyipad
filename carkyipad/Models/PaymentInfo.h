//
//  PaymentInfo.h
//
//  Created by   on 17/05/2017
//  Copyright (c) 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PaymentInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger paymentMethod;
@property (nonatomic, strong) NSString *stripeCardId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
