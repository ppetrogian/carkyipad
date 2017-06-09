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
#import "InitViewController.h"
#import "RequestRideViewController.h"
@import AVFoundation;
@import AVKit;

@interface WaitForDriverViewController () <InitViewController>
@property (nonatomic, assign) NSTimeInterval pollInterval;
@property (nonatomic, assign) NSTimeInterval pollTime; // time that has passed
@property (nonatomic, assign) NSTimeInterval pollTimeout;
@property (nonatomic, strong) NSTimer *pollTimer;

@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, readonly, weak) TransferStepsViewController *parentTransferController;
@end

@implementation WaitForDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pollInterval = 5.0;
    self.pollTimeout = 120.0;
    self.pollTime = 0.0;
    [self findDriverAndMakePayment];

    // Do any additional setup after loading the view.
    UIImage *catImage = [UIImage imageNamed: self.parentController.selectedCarCategory.image];
    self.driverCarPhotoImageView.image = catImage;
    [self initControls];
    AppDelegate *app = [AppDelegate instance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:app.qplayer. currentItem];
    self.pickupImageView.alpha = 0;
}

-(void)initControls {
    AppDelegate *app = [AppDelegate instance];
    if(!app.qplayer) {
        app.qplayer = [app loadTransferVideoPlayer];
        app.playerLayer = [AVPlayerLayer playerLayerWithPlayer:app.qplayer];
        app.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    app.playerLayer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:app.playerLayer];
    [app.qplayer seekToTime:kCMTimeZero];
    [app.qplayer play];
    app.qplayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.loaded = YES;
}

-(void)deinitControls {
    self.loaded = NO;
    AppDelegate *app = [AppDelegate instance];
    [app.qplayer pause];
    [app.playerLayer removeFromSuperlayer];
    // clear gmap resources
    RequestRideViewController *rvc = self.parentTransferController.childViewControllers[0];
    GMSMapView *mapView = rvc.mapView;
    [mapView clear] ;
    [mapView removeFromSuperview] ;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p =  [notification object];
    if (self.loaded) {
        [p seekToTime:kCMTimeZero];
    }
}

-(TransferStepsViewController *)parentTransferController {
    return (TransferStepsViewController *)self.stepsController;
}

-(void)findDriverAndMakePayment {
    if (self.parentTransferController.payPalPaymentResponse) {
        [self.parentTransferController payTransferWithPaypal:self.parentTransferController.payPalPaymentResponse withBlock:^(NSString *bookingId) {
            [self showBooking:bookingId];
        }]; // create transfer request
    }
    else {
        [self.parentTransferController payTransferWithCreditCard:^(NSString *bookingId) {
            [self showBooking:bookingId];
        }];
    }
}

-(void)showBooking:(NSString *)bookingId {
    AppDelegate *app = [AppDelegate instance];
    self.parentTransferController.transferBookingId = bookingId;
    if ([bookingId isEqualToString:@"0"]) {
        [app.qplayer pause];
        [self.parentTransferController showAlertViewWithMessage:NSLocalizedString(@"All our drivers are currently busy, please try again shortly or choose another car category. You have not been charged for this booking.",@"Drivers_busy") andTitle:@"Booking" withBlock:^(BOOL b) {
            [self newBookingButton_Click:nil];
        }];
        return;
    } else if([bookingId isEqualToString:@"-1"]) {
        [app.qplayer pause];
        // stripe error, already have shown message
        [self newBookingButton_Click:nil];
    }
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [api GetCarkyBookingStatusForUser:self.parentTransferController.userId andBooking:bookingId withBlock:^(NSArray *array) {
        if (self.pollTimer.isValid) {
            [self.pollTimer invalidate];
        }
        if (array.count > 0 && [array.firstObject isKindOfClass:Content.class]) {
            self.pollTimer = [NSTimer scheduledTimerWithTimeInterval:self.pollInterval target:self selector:@selector(handlePollTimer:) userInfo:nil repeats:YES];
            [self handlePollTimer:self.pollTimer];
            [self loadPickupImage];
            Content *responseObj = array.firstObject;
            self.driverNoLabel.text = [NSString stringWithFormat:@"%@ %.2lf", responseObj.name, responseObj.rating];
            self.registrationNoLabel.text = responseObj.registrationNo;
            if (responseObj.photo) {
                UIImage *driverImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: responseObj.photo]]];
                self.driverPhotoImageView.image = driverImg;
            }
        }
        else {
            // message should have been shown
            [self newBookingButton_Click:nil];
        }
    }];
}

- (void)loadPickupImage {
  AppDelegate *app = [AppDelegate instance];
  UIImage *waitImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: app.clientConfiguration.pickupInstructionsImage]]];
        self.pickupImageView.image = waitImg;
    [UIView animateWithDuration:0.4 animations:^{
        self.pickupImageView.alpha = 1;
    } completion:^(BOOL finished) {}];
}

- (void)handlePollTimer:(NSTimer *)theTimer {
    self.pollTime += self.pollInterval;
    if (self.pollTime > self.pollTimeout) {
        if (self.pollTimer.isValid) {
            [self.pollTimer invalidate];
        }
        [self newBookingButton_Click: self.makeBookingButton];
    }
}

-(TransferStepsViewController *)parentController {
    return (TransferStepsViewController *)self.stepsController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)newBookingButton_Click:(UIButton *)sender {
    //[self.parentController loadStepViewControllers];
    //[self.parentController showStepForIndex:0];
    if (self.pollTimer.isValid) {
        [self.pollTimer invalidate];
    }
    AppDelegate *app = [AppDelegate instance];
    [app.qplayer pause];
    [self deinitControls];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [app loadInitialControllerForMode:app.clientConfiguration.tabletMode];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
}
*/

@end
