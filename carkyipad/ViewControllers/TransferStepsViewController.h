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
@property (strong, nonatomic) CarCategory *selectedCarCategory;
@property (strong, nonatomic) NSString *transferBookingId;

-(void)getWellKnownLocations:(NSInteger)locationId forMap:(GMSMapView *)mapView;
- (void) didSelectLocation:(NSInteger)identifier withValue:(id)value andText:(NSString *)t forMap:(GMSMapView *)mapView;
- (void) didSelectCarCategory:(NSInteger)identifier withValue:(id)value andText:(NSString *)text forMap:(GMSMapView *)mapView;
// methods

-(void)payWithCreditCard:(BlockBoolean)block;
-(void)payWithPaypal:(NSString *)confirmation;
-(TransferBookingRequest *)getPaymentRequestWithCC:(BOOL)forCC;
@end
