//
//  CarRentalStepsViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 14/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMStepsController.h"
#import "StepSegmentControllerView.h"
#import "CarkyApiClient.h"

@class ShadowViewWithText, Location, STPCardParams, RegisterClientRequest;

@interface CarRentalStepsViewController : RMStepsController <RMStepsBarDelegate, RMStepsBarDataSource>
@property (weak, nonatomic) IBOutlet UIStackView *stepButtonsStack;
@property (weak, nonatomic) IBOutlet UIStackView *stepLabelsStack;
@property (nonatomic, strong) NSString *stripeCardToken;
@property (nonatomic, strong) Location *selectedPickupLocation;
@property (nonatomic, strong) Location *selectedDropoffLocation;
@property (strong, nonatomic) Location *currentLocation;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) STPCardParams *cardParams;
@property (nonatomic, strong) RegisterClientRequest *clientData;
@property (nonatomic, assign) BOOL payWithCash;

-(void)payRentalWithCreditCard:(BlockBoolean)b;
-(void)payRentalWithPaypal:(NSString *)confirmationString andResponse:(NSDictionary *)confirmDict andBlock:(BlockBoolean)block;
- (IBAction)gotoBack:(id)sender;
- (IBAction)gotoNext:(id)sender;
-(void)showAlertViewWithMessage:(NSString *)messageStr andTitle:(NSString *)titleStr;
-(void)showAlertViewWithMessage:(NSString *)messageStr andTitle:(NSString *)titleStr withBlock:(BlockBoolean)block;
-(RentalBookingRequest *)getRentalRequestWithCC:(BOOL)forCC;
@property (nonatomic, weak) IBOutlet StepSegmentControllerView *segmentController;
@end
