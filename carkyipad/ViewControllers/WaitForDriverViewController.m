//
//  WaitForDriverViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 24/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "WaitForDriverViewController.h"
#import "CarkyApiClient.h"
#import "AppDelegate.h"
#import "DataModels.h"
#import "TransferStepsViewController.h"

@interface WaitForDriverViewController ()
@property (nonatomic, assign) NSTimeInterval pollInterval;
@property (nonatomic, assign) NSTimeInterval pollTime;
@property (nonatomic, assign) NSTimeInterval pollTimeout;
@property (atomic, strong) NSTimer *pollTimer;
@property (nonatomic, readonly, weak) TransferStepsViewController *parentController;
@end

@implementation WaitForDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pollInterval = 5.0;
    self.pollTimeout = 150.0;
    self.pollTime = 0.0;

    // Do any additional setup after loading the view.
    self.pollTimer = [NSTimer scheduledTimerWithTimeInterval:self.pollInterval target:self selector:@selector(handlePollTimer:) userInfo:nil repeats:YES];
    [self handlePollTimer:self.pollTimer];
    UIImage *catImage = [UIImage imageNamed: self.parentController.selectedCarCategory.image];
    self.driverCarPhotoImageView.image = catImage;
}

- (void)handlePollTimer:(NSTimer *)theTimer {
    self.pollTime += self.pollInterval;
    if (self.pollTime > self.pollTimeout) {
        [self.pollTimer invalidate];
        [self.parentController showAlertViewWithMessage:@"Timeout" andTitle:@"Error"];
    }
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [api GetCarkyBookingId:self.parentController.transferBookingId withBlock:^(NSString *string) {
        if (string) {
            self.bookingRequestId = string;
            [api GetCarkyBookingStatusForUser:self.parentController.userId andBooking:self.bookingRequestId withBlock:^(NSArray *array) {
                [self.pollTimer invalidate];
                Content *responseObj = array.firstObject;
                self.driverNoLabel.text = [NSString stringWithFormat:@"%@ %lf", responseObj.name, responseObj.rating];
                self.registrationNoLabel.text = responseObj.registrationNo;
                if (responseObj.photo) {
                    UIImage *driverImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: responseObj.photo]]];
                    self.driverPhotoImageView.image = driverImg;
                }
            }];
        }
    }];
}

-(TransferStepsViewController *)parentController {
    return (TransferStepsViewController *)self.stepsController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
