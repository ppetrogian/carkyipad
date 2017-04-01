//
//  CarTransferModel.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 01/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DSLCalendarRange;

extern NSString *const kResultsDayRange;
extern NSString *const kResultsPickupFleetLocationId;
extern NSString *const kResultsDropoffFleetLocationId;
extern NSString *const kResultsPickupLocationId;
extern NSString *const kResultsDropoffLocationId;

@interface CarRentalModel : NSObject
@property (nonatomic,assign) DSLCalendarRange *dayRange;
@end
