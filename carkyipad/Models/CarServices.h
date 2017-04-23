//
//  CarServices.h
//
//  Created by   on 23/04/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CarServices : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger maxPassengers;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger mazLuggages;
@property (nonatomic, assign) NSInteger carServicesIdentifier;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
