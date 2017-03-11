//
//  CarExtra.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 11/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CarExtra : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double price;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Description;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
