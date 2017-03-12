//
//  SharedData.m
//  OnGraviti
//
//  Created by Pravin Mahajan on 27/07/16.
//  Copyright © 2016 Exceptionaire. All rights reserved.
//

#import "SharedInstance.h"

@implementation SharedInstance

+(SharedInstance *)sharedInstance
{
    static SharedInstance *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[SharedInstance alloc] init];
    });
    
    return sharedInstance;
}
@end
