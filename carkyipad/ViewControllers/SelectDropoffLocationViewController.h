//
//  SelectDropoffLocationViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 23/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>
#import "StepViewController.h"
@class Location,RequestRideViewController;

@interface SelectDropoffLocationViewController : StepViewController
@property (weak, nonatomic) IBOutlet UITextField *toLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *fromLocationTextField;
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;
@property (weak,nonatomic) RequestRideViewController *delegateRequestRide;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (strong,nonatomic) Location *currentLocation;
@property (weak, nonatomic) UITextField *activeFld;

- (void)fetchPlacesForActiveField;
@end
