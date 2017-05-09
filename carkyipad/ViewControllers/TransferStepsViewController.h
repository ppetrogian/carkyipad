//
//  CarRentalStepsViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 14/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMStepsController.h"
#import "CarRentalStepsViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "CarkyApiClient.h"
@class LatLng, Location, STPPaymentCardTextField, RegisterClientRequest,CarCategory,STPCardParams,GMSCoordinateBounds;

@interface TransferStepsViewController : CarRentalStepsViewController

// date properties
@property (nonatomic, strong) Location *selectedLocation;
@property (strong, nonatomic) Location *currentLocation;
@property (strong, nonatomic) CarCategory *selectedCarCategory;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) STPCardParams *cardParams;
@property (nonatomic, strong) RegisterClientRequest *clientData;
@property (strong, nonatomic) NSString *transferBookingId;
@property (strong, nonatomic) GMSCoordinateBounds *locationBounds;

-(void)getWellKnownLocations:(NSInteger)locationId forMap:(GMSMapView *)mapView;
- (void) didSelectLocation:(NSInteger)identifier withValue:(id)value andText:(NSString *)t forMap:(GMSMapView *)mapView;
- (void) didSelectCarCategory:(NSInteger)identifier withValue:(id)value andText:(NSString *)text forMap:(GMSMapView *)mapView;
// methods
-(void)showAlertViewWithMessage:(NSString *)messageStr andTitle:(NSString *)titleStr;
-(void)payWithCreditCard:(BlockBoolean)block;
-(void)payWithPaypal:(NSDictionary *)confirmation;
-(TransferBookingRequest *)getPaymentRequest:(BOOL)forCC;
@end
