//
//  WaitForDriverViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 24/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "StepViewController.h"
@class TransferBookingResponse;

@interface WaitForDriverViewController : StepViewController
@property (nonatomic, strong) TransferBookingResponse *bookingResponse;

@property (weak, nonatomic) IBOutlet UILabel *registrationNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *etaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *driverPhotoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *driverCarPhotoImageView;
@property (weak, nonatomic) IBOutlet UIButton *makeBookingButton;
@property (weak, nonatomic) IBOutlet UIImageView *pickupImageView;

@end
