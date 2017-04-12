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
@class LatLng;

@interface TransferStepsViewController : CarRentalStepsViewController
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *fromLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *toLocationTextField;
@property (weak, nonatomic) IBOutlet UIView *locationsContainerView;
@property (weak, nonatomic) IBOutlet UIView *driversContainerView;



// methods
-(void)getDirectionsFrom:(LatLng *)origin to:(LatLng *)destination;

@end
