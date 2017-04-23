//
//  ClientConfigurationResponse.h
//
//  Created by   on 23/04/2017
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ClientConfigurationResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *carServices;
@property (nonatomic, assign) NSInteger areaOfServiceId;
@property (nonatomic, assign) NSInteger zoneId;
@property (nonatomic, strong) NSString *pickupInstructionsImage;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
