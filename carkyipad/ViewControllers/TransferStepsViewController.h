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
@class LatLng, Location, STPPaymentCardTextField;

@interface TransferStepsViewController : CarRentalStepsViewController
@property (weak, nonatomic) IBOutlet UIView *viewFindDrivers;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *fromLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *toLocationTextField;
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;
@property (weak, nonatomic) IBOutlet UITableView *carCategoriesTableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIButton *flagButton;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmEmailTextField;
@property (weak, nonatomic) IBOutlet UILabel *countryPrefixLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *cashButton;
@property (weak, nonatomic) IBOutlet UIButton *creditCardButton;
@property (weak, nonatomic) IBOutlet UIButton *payNowButton;
@property (weak, nonatomic) IBOutlet UITextField *cvvTextField;
@property (weak, nonatomic) IBOutlet UITextField *creditCardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *expiryDateTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *paymentsScrollView;
@property (weak, nonatomic) IBOutlet UIView *paymentDoneView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet STPPaymentCardTextField *stpCardTextField;
@property (weak, nonatomic) IBOutlet UIView *creditCardLine;


@property (strong, nonatomic) Location *currentLocation;

-(void)loadCarCategories;
-(void)loadLocations:(NSString *)filter;
// methods
-(void)getDirectionsFrom:(LatLng *)origin to:(LatLng *)destination;

@end
