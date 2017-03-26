//
//  AppDelegate.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 6/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModels.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSArray<FleetLocations*> *fleetLocations;
@property (strong, nonatomic) NSArray<CarCategory*> *carCategories;
@property (strong, nonatomic) NSArray<CarExtra*> *carExtras;
@property (strong, nonatomic) NSArray<CarInsurance*> *carInsurances;


@end

