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
#import "RefreshableViewController.h"
#import "ResetsForIdle.h"
@import AVFoundation;
@import AVKit;

@interface WaitForDriverViewController () <InitViewController, RefreshableViewController, ResetsForIdle>
@property (nonatomic, assign) NSTimeInterval pollInterval;
@property (nonatomic, assign) NSTimeInterval pollTime; // time that has passed
@property (nonatomic, assign) NSTimeInterval pollTimeout;
@property (nonatomic, strong) NSTimer *timeoutTimer;

@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, assign) BOOL retriedFromBusy;
@property (nonatomic, readonly, weak) TransferStepsViewController *parentTransferController;
@end

@implementation WaitForDriverViewController

- (void)viewDidLoad {
    AppDelegate *app = [AppDelegate instance];
    [super viewDidLoad];
    self.pollInterval = 5.0;
    self.pollTimeout = 120.0;
    self.pollTime = 0.0;
    self.retriedFromBusy = NO;
    [app.idleTimer invalidate];

    // Do any additional setup after loading the view.
    UIImage *catImage = [UIImage imageNamed: self.parentController.selectedCarCategory.image];
    self.driverCarPhotoImageView.image = catImage;
    [self initControls];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:app.qplayer. currentItem];
    self.pickupImageView.alpha = 0;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.loaded) {
        [self setNeedRefresh:YES];
    }
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
    app.qplayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.loaded = YES;
}

-(void)setNeedRefresh:(BOOL)value {
    if (value) {
         AppDelegate *app = [AppDelegate instance];
        [app.qplayer play];
        [self findDriverAndMakePayment];
    }
}

-(void)deinitControls {
    if(!self.loaded) {
        return;
    }
    self.loaded = NO;
    AppDelegate *app = [AppDelegate instance];
    [app.qplayer pause];
    [app.playerLayer removeFromSuperlayer];
    // clear gmap resources
    RequestRideViewController *rvc = self.parentTransferController.childViewControllers[0];
    GMSMapView *mapView = rvc.mapView;
    [mapView clear] ;
    [mapView removeFromSuperview];
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
        if (self.parentTransferController.payWithCash) {
            [self.parentTransferController payTransferWithCash:^(NSString *bookingId) {
                [self showBooking:bookingId];
            }];
        }
        else {
            [self.parentTransferController payTransferWithCreditCard:^(NSString *bookingId) {
                [self showBooking:bookingId];
            }];
        }
    }
}

-(void)showBooking:(NSString *)bookingId {
    AppDelegate *app = [AppDelegate instance];
    NSString *retryMsg = NSLocalizedString(@"Do you want to retry again for the same car category?",@"want_retry");
    self.parentTransferController.transferBookingId = bookingId;
    if (app.clientConfiguration.booksLater) {
        [app.qplayer pause];
        [self.parentTransferController showAlertViewWithMessage:bookingId andTitle:@"Booking" withBlock:^(BOOL b) {
            [self newBookingButton_Click:nil];
        }];
        return;
    }
    if ([bookingId isEqualToString:@"-402"]) { // 402 error = payment failed
        [app.qplayer pause];
        NSString *paymentMsg = NSLocalizedString(@"Payment failed. You have not been charged for this booking.",@"Payment error");
        NSString *busyRetryMsg = [NSString stringWithFormat:@"%@\n%@", paymentMsg, retryMsg];
        [self.parentTransferController showRetryDialogViewWithMessage:busyRetryMsg andTitle:@"Booking" withBlockYes:^(BOOL b) {
            [self.parentTransferController showPreviousStep];
        } andBlockNo:^(BOOL b) {  [self newBookingButton_Click:nil]; }];
        return;
    }
    else if ([bookingId isEqualToString:@"0"]) {
          [app.qplayer pause];
        NSString *busyMsg = NSLocalizedString(@"All our drivers are currently busy, please try again shortly or choose another car category. You have not been charged for this booking.",@"Drivers_busy");
        NSString *retryMsg = NSLocalizedString(@"Do you want to retry?",@"want_retry");
        if (!self.retriedFromBusy) {
            self.retriedFromBusy = YES;
            NSString *busyRetryMsg = [NSString stringWithFormat:@"%@\n%@", busyMsg, retryMsg];
            [self.parentTransferController showRetryDialogViewWithMessage:busyRetryMsg andTitle:@"Booking" withBlockYes:^(BOOL b) {
                [self setNeedRefresh:YES];
            } andBlockNo:^(BOOL b) {  [self newBookingButton_Click:nil]; }];
        }
        else {
            [self.parentTransferController showAlertViewWithMessage:busyMsg andTitle:@"Booking" withBlock:^(BOOL b) {  [self newBookingButton_Click:nil];
            }];
        }
        return;
    }
    else if([bookingId isEqualToString:@"-1"]) {
        // stripe error, already have shown message
        [self newBookingButton_Click:nil];
    }

    CarkyApiClient *api = [CarkyApiClient sharedService];
    [api GetCarkyBookingStatusForUser:self.parentTransferController.userId andBooking:bookingId withBlock:^(NSArray *array) {
        if (self.timeoutTimer.isValid) {
            [self.timeoutTimer invalidate];
        }
        [self deinitControls];
        if (array.count > 0 && [array.firstObject isKindOfClass:Content.class]) {
            self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:self.pollInterval target:self selector:@selector(handlePollTimer:) userInfo:nil repeats:YES];
            [self handlePollTimer:self.timeoutTimer];
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
        if (self.timeoutTimer.isValid) {
            [self.timeoutTimer invalidate];
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
    id<ResetsForIdle> rvc = (id<ResetsForIdle>)self.parentTransferController;
    // transfer controller will call this self -> reset-for idle timer
    [rvc resetForIdleTimer];
}

-(void)resetForIdleTimer {
    if (self.timeoutTimer.isValid) {
        [self.timeoutTimer invalidate];
    }
    [self deinitControls];
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
