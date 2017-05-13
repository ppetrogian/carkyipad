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
@property (nonatomic, assign) NSTimeInterval pollTime;
@property (nonatomic, assign) NSTimeInterval pollTimeout;
@property (nonatomic, strong) NSTimer *pollTimer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerViewController *layerVc;
@property (nonatomic, readonly, weak) TransferStepsViewController *parentController;
@end

@implementation WaitForDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pollInterval = 5.0;
    self.pollTimeout = 60.0;
    self.pollTime = 0.0;

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
    self.pickupImageView.alpha = 0;
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
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [api GetCarkyBookingId:self.parentController.transferBookingId withBlock:^(NSString *string) {
        if (string) {
            self.bookingRequestId = string;
            [api GetCarkyBookingStatusForUser:self.parentController.userId andBooking:self.bookingRequestId withBlock:^(NSArray *array) {
                [self.pollTimer invalidate];
                 [self loadPickupImage];
                Content *responseObj = array.firstObject;
                self.driverNoLabel.text = [NSString stringWithFormat:@"%@ %.2lf", responseObj.name, responseObj.rating];
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
- (IBAction)newBookingButton_Click:(UIButton *)sender {
    //[self.parentController loadStepViewControllers];
    //[self.parentController showStepForIndex:0];
    [[AppDelegate instance] loadInitialControllerForMode:1];
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
