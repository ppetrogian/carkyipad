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
@property (strong, nonatomic) NSArray<Location*> *wellKnownLocations;
@property (strong, nonatomic) NSMutableDictionary *availableCarsDict;
@property (strong, nonatomic) CarRentalModel *carRentalModel;
@property (strong, nonatomic) GMSCoordinateBounds *locationBounds;
@property (strong, nonatomic) ClientConfigurationResponse *clientConfiguration;
@property (assign, nonatomic) BOOL isDemo;

- (void)loadInitialControllerForMode:(NSInteger)mode;
+(AppDelegate *)instance;
// helper methods
+(UITableView *) parentTableView:(UIView *)view;
+(UITableViewCell *) parentTableViewCell:(UIView *)view;
+(UICollectionView *)parentCollectionView:(UIView *)view;
+(UICollectionViewCell *)parentCollectionViewCell:(UIView *)view;
-(void)fetchInitialData:(BlockBoolean)block;
+(CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location;
+(MBProgressHUD *)showProgressNotification:(UIView *)view withText:(NSString *)text;
+(void)hideProgressNotification:(MBProgressHUD *)hud;
+(void)configurePSTextField:(UITextField *)tf withColor:(UIColor *)color;
+(GMSPolyline *)showRouteInMap:(GMSMapView *)mapView withResults:(NSDictionary *)results forMarker:(GMSMarker *)targetMarker;
+(UIImage *)imageToGreyImage:(UIImage *)image;
+(NSString *)urlencode:(NSString *)str;
+(void)addDropShadow:(UIView *)view forUp:(BOOL)up;
+(void)highlightAttrTextCore:(NSMutableAttributedString *)attrTxt term:(NSString *)term withBackground:(UIColor *)backColor withBlack:(BOOL)bBlack andFont:(UIFont *)font;
+(void)highlightGoogleText:(NSMutableAttributedString *)attrText  withBackground:(UIColor *)backColor withBlack:(BOOL)bBlack andFont:(UIFont *)font;
@end

