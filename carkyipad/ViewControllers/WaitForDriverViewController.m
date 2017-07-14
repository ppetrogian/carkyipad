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
#import "Constants.h"
@import AVFoundation;
@import AVKit;
@import MapKit;

@interface WaitForDriverViewController () <InitViewController, RefreshableViewController, ResetsForIdle> {
    TransferBookingResponse* _bookingResponse;
}
@property (nonatomic, assign) NSTimeInterval pollInterval;
@property (nonatomic, assign) NSTimeInterval pollTime; // time that has passed
@property (nonatomic, strong) NSTimer *pollTimer;
@property (nonatomic, strong) NSTimer *timeoutTimer;

@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, assign) BOOL retriedFromBusy;
@property (nonatomic, readonly, weak) TransferStepsViewController *parentTransferController;
@end

@implementation WaitForDriverViewController

- (void)viewDidLoad {
    AppDelegate *app = [AppDelegate instance];
    [super viewDidLoad];
    self.pollInterval = 3.0;
    self.pollTime = 0.0;
    self.retriedFromBusy = NO;

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
    [self.pollTimer invalidate];
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
    self.bookingResponse = nil;
    self.etaLabel.text = @"";
    if ([CarkyApiClient sharedService].isOffline) {
        [self.parentTransferController showAlertViewWithMessage:NSLocalizedString(NO_INTERNET, @"no_internet") andTitle:@"Offline" withBlock:^(BOOL b) {
            [self newBookingButton_Click:nil];
        }];
    }
    if (self.parentTransferController.payPalPaymentResponse) {
        [self.parentTransferController payTransferWithPaypal:self.parentTransferController.payPalPaymentResponse withBlock:^(NSArray *array) {
            if ([array.firstObject isKindOfClass:TransferBookingResponse.class]) {
                TransferBookingResponse *response = array.firstObject;
                self.bookingResponse = response;
            }
        }]; // create transfer request
    }
    else {
        if (self.parentTransferController.payWithCash) {
            [self.parentTransferController payTransferWithCash:^(NSArray *array) {
                if ([array.firstObject isKindOfClass:TransferBookingResponse.class]) {
                    TransferBookingResponse *response = array.firstObject;
                    self.bookingResponse = response;
                }
            }];
        }
        else {
            [self.parentTransferController payTransferWithCreditCard:^(NSArray *array) {
                if ([array.firstObject isKindOfClass:TransferBookingResponse.class]) {
                    TransferBookingResponse *response = array.firstObject;
                    self.bookingResponse = response;
                }
            }];
        }
    }
}

-(TransferBookingResponse *)bookingResponse {
    return _bookingResponse;
}

-(void)setBookingResponse:(TransferBookingResponse *)value {
    NSLog(@"Received bookingRequestId: %@", value);
    _bookingResponse = value;
    self.pollTime = 0;
    if (!value) {
        return;
    }
    AppDelegate *app = [AppDelegate instance];
    if (app.clientConfiguration.booksLater) {
        [self showBooking:value.bookingRequestId andMessage:value.errorDescription];
    }
    else {
        self.pollTimer = [NSTimer scheduledTimerWithTimeInterval:self.pollInterval target:self selector:@selector(handlePollTimer:) userInfo:nil repeats:YES];
    }
}

-(void)showBooking:(NSString *)bookingId andMessage:(NSString *)message {
    AppDelegate *app = [AppDelegate instance];
    [app.qplayer pause];
    [self.pollTimer invalidate];

    if (app.clientConfiguration.booksLater) {
        NSString *detail = message ? message : NSLocalizedString(@"Booking is confirmed", nil);
        NSString *title = [bookingId isEqualToString:@"-1"] ? @"Error" : @"Booking";
        [self.parentTransferController showAlertViewWithMessage:detail andTitle:title withBlock:^(BOOL b) {
            [self newBookingButton_Click:nil];
        }];
        return;
    }
    if ([bookingId isEqualToString:@"-402"]) { // 402 error = payment failed
        NSString *paymentRetryMsg = message ? message : NSLocalizedString(@"Payment failed. You have not been charged for this booking. Do you want to retry again for the same car category?",@"Payment Failed");
        [self.parentTransferController showRetryDialogViewWithMessage:paymentRetryMsg andTitle:@"Payment Failed" withBlockYes:^(BOOL b) {
            [self.parentTransferController showPreviousStep];
        } andBlockNo:^(BOOL b) {  [self newBookingButton_Click:nil]; }];
        return;
    }
    else if ([bookingId isEqualToString:@"0"] || [bookingId isEqualToString:@"-403"]) {
       CarkyApiClient *api = [CarkyApiClient sharedService];
       NSString *retry1Msg = message ? message : (api.isOffline ? NSLocalizedString(@"The Internet connection appears to be offline. If a driver has been found, an SMS was sent to your cell phone", @"no_conn") :
            NSLocalizedString(@"All our drivers are currently busy, please try again shortly or choose another car category. You have not been charged for this booking.",@"drivers_busy"));
        NSString *retry2Msg = NSLocalizedString(@"Do you want to retry?",@"want_retry");
        if (!self.retriedFromBusy && ![CarkyApiClient sharedService].isOffline) {
            self.retriedFromBusy = YES;
            NSString *retryFullMsg = [NSString stringWithFormat:@"%@\n%@", retry1Msg, retry2Msg];
            [self.parentTransferController showRetryDialogViewWithMessage:retryFullMsg andTitle:@"Booking" withBlockYes:^(BOOL b) {
                if (self.parentTransferController.payPalPaymentResponse) {
                    [self.parentTransferController showPreviousStep];
                }
                else {
                    [self setNeedRefresh:YES];
                }
            } andBlockNo:^(BOOL b) {  [self newBookingButton_Click:nil]; }];
        }
        else {
            [self.parentTransferController showAlertViewWithMessage:retry1Msg andTitle:@"Booking" withBlock:^(BOOL b) {  [self newBookingButton_Click:nil];
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
        [self deinitControls];
        if (array.count > 0 && [array.firstObject isKindOfClass:Content.class]) {
            self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(handleTimoutTimer:) userInfo:nil repeats:NO];
            [self loadPickupImage];
            AppDelegate *app = [AppDelegate instance];
            Content *responseObj = array.firstObject;
            self.driverNoLabel.text = responseObj.name;
            [AppDelegate getEtaFrom: responseObj.driverPosition to:app.clientConfiguration.location.latLng andBlock:^(NSArray *array) {
                MKRoute *route = array.firstObject;
                self.etaLabel.text = [NSString stringWithFormat:@"ETA:%.0f min", route.expectedTravelTime/60.0];
            }];
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
    if (self.pollTime > TRANSFER_TIMEOUT || !self.bookingResponse) {
        [self.pollTimer invalidate];
        [self showBooking:@"0" andMessage:nil];
    }
    else {
        CarkyApiClient *api = [CarkyApiClient sharedService];
        [api CheckTransferBookingRequest:self.bookingResponse.bookingRequestId withBlock:^(NSArray *array) {
            if ([array.firstObject isKindOfClass:TransferBookingResponse.class]) {
                TransferBookingResponse *obj = array.firstObject;
                NSLog(@"Received bookingId %@", obj.bookingId);
                if (obj.bookingId && ![obj.bookingId isEqualToString:@"0"]) {
                    [self showBooking:obj.bookingId andMessage:obj.errorDescription];
                }
            }
        }];
    }
}

- (void)handleTimoutTimer:(NSTimer *)theTimer {
    [self newBookingButton_Click: self.makeBookingButton];
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
