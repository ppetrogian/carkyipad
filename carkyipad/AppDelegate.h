//
//  AppDelegate.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 6/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModels.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "CarkyApiClient.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) CarkyApiClient *api;

@property (strong, nonatomic) NSArray<FleetLocations*> *fleetLocations;
@property (strong, nonatomic) NSArray<CarType*> *carTypes;
@property (strong, nonatomic) NSArray<CarCategory*> *carCategories;
@property (strong, nonatomic) NSArray<CarExtra*> *carExtras;
@property (strong, nonatomic) NSArray<CarInsurance*> *carInsurances;
@property (strong, nonatomic) NSMutableDictionary *availableCarsDict;
@property (strong, nonatomic) CarRentalModel *carRentalModel;
+(AppDelegate *)instance;
// helper methods
-(void)fetchInitialData:(BlockBoolean)block;
+(CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location;
+(MBProgressHUD *)showProgressNotification:(UIView *)view;
+(void)hideProgressNotification:(MBProgressHUD *)hud;
@end

