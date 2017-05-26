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
@import AVFoundation;
@import AVKit;

@interface WaitForDriverViewController ()
@property (nonatomic, assign) NSTimeInterval pollInterval;
@property (nonatomic, assign) NSTimeInterval pollTime; // time that has passed
@property (nonatomic, assign) NSTimeInterval pollTimeout;
@property (nonatomic, strong) NSTimer *pollTimer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerViewController *layerVc;
@property (nonatomic, readonly, weak) TransferStepsViewController *parentTransferController;
@end

@implementation WaitForDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pollInterval = 5.0;
    self.pollTimeout = 60.0;
    self.pollTime = 0.0;
    [self findDriverAndMakePayment];

    // Do any additional setup after loading the view.
    self.pollTimer = [NSTimer scheduledTimerWithTimeInterval:self.pollInterval target:self selector:@selector(handlePollTimer:) userInfo:nil repeats:YES];
    [self handlePollTimer:self.pollTimer];
    UIImage *catImage = [UIImage imageNamed: self.parentController.selectedCarCategory.image];
    self.driverCarPhotoImageView.image = catImage;
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource: @"2848220705019691240" withExtension:@"mp4"];
    self.player = [AVPlayer playerWithURL:videoURL];
    //self.layer = [AVPlayerLayer layer];
    self.videoContainerView.frame = self.view.frame;
    self.layerVc.showsPlaybackControls = NO;
    self.layerVc.view.userInteractionEnabled = NO;
    self.layerVc.player = self.player;
    [self.player play];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    self.pickupImageView.alpha = 0;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
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
    self.parentTransferController.transferBookingId = bookingId;
    if ([bookingId isEqualToString:@"0"]) {
        [self.player pause];
        [self.parentTransferController showAlertViewWithMessage:NSLocalizedString(@"All our drivers are currently busy, please try again shortly or choose another car category. You have not been charged for this booking.",@"Drivers_busy") andTitle:@"Booking" withBlock:^(BOOL b) {
            [self newBookingButton_Click:nil];
        }];
        return;
    } else if([bookingId isEqualToString:@"-1"]) {
        [self.player pause];
        // stripe error, already have shown message
        [self newBookingButton_Click:nil];
    }
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [api GetCarkyBookingStatusForUser:self.parentTransferController.userId andBooking:bookingId withBlock:^(NSArray *array) {
        if (self.pollTimer.isValid) {
            [self.pollTimer invalidate];
        }
        if (array.count > 0 && [array.firstObject isKindOfClass:Content.class]) {
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
        self.videoContainerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.videoContainerView removeFromSuperview];
    }];
}

- (void)handlePollTimer:(NSTimer *)theTimer {
    self.pollTime += self.pollInterval;
    if (self.pollTime > self.pollTimeout) {
        if (self.pollTimer.isValid) {
            [self.pollTimer invalidate];
        }
        //[self.parentController showAlertViewWithMessage:@"Timeout" andTitle:@"Error"];
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
    [self.player pause];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    self.player = nil; self.layerVc = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AppDelegate *app = [AppDelegate instance];
    [app loadInitialControllerForMode:app.clientConfiguration.tabletMode];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"avPlayer"]) {
        self.layerVc = (AVPlayerViewController *)segue.destinationViewController;
    }
}


@end
