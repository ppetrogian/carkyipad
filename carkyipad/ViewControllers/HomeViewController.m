//
//  HomeViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 12/3/17.
//  Copyright © 2017 Nessos. All rights reserved.

#import "BaseViewController.h"
#import "HomeViewController.h"
#import "FlatPillButton.h"
#import "AppDelegate.h"
#import "CarkyApiClient.h"
#import "DataModels.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "SVWebViewController.h"
#import "UIViewController_Additions.h"

@interface HomeViewController ()
@property (nonatomic,strong) CarkyApiClient *api;

@end

@implementation HomeViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.asyncView.data = 0; // dummy data
    //self.buttonTransfer.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:35];
    if (self.circularMap) {
        self.homeMapView.layer.cornerRadius = self.homeMapView.frame.size.width / 2;
        self.homeMapView.layer.borderWidth = 4.0;
        self.homeMapView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    AppDelegate *app = [AppDelegate instance];
    if (app.heartbeatTimer)
        [app.heartbeatTimer invalidate];
    app.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:kHeartBeatInterval target:self selector:@selector(sendHeartbeat) userInfo:nil repeats:YES];
    NSString *backImageUrlForMainButton = nil;
    TabletMode tm = (TabletMode)[AppDelegate instance].clientConfiguration.tabletMode;
    if (tm == TabletModeTransfer || tm == TabletModeReception) {
        backImageUrlForMainButton = app.clientConfiguration.transferBackgroundImage;
    }
    if (backImageUrlForMainButton) {
        UIImage *showImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: backImageUrlForMainButton]]];
        if (showImg.size.width > 0) {
            UIButton *mainButton = [self.view viewWithTag:1];
            [mainButton setImage:showImg forState:UIControlStateNormal];
        }
    }
    if (self.ticketsButton) {
        UIImage *ticketsImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: app.clientConfiguration.airTicketsImage]]];
        if (ticketsImg.size.width > 0) {
            [self.ticketsButton setImage:ticketsImg forState:UIControlStateNormal];
        }
    }
    if (self.bookHotelButton) {
        UIImage *bookHotelImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: app.clientConfiguration.hotelBookingImage]]];
        if (bookHotelImg.size.width > 0) {
            [self.bookHotelButton setImage:bookHotelImg forState:UIControlStateNormal];
        }
    }
    self.homeMapView.mapType = kGMSTypeNormal;
    self.homeMapView.settings.myLocationButton = NO;
    self.homeMapView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    CLLocationCoordinate2D positionCenter = CLLocationCoordinate2DMake(app.clientConfiguration.location.latLng.lat, app.clientConfiguration.location.latLng.lng);
    self.homeMapView.camera = [GMSCameraPosition cameraWithTarget:positionCenter zoom: 13.0];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = positionCenter;
    marker.map  = self.homeMapView;
    marker.title = app.clientConfiguration.location.name;
    marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
}


-(void)sendHeartbeat {
    if ([self isVisible]) {
        CarkyApiClient *api = [CarkyApiClient sharedService];
        [api Heartbeat];
        NSLog(@"Sending heartbeat...");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showBook:(UIButton *)sender {
    AppDelegate *app = [AppDelegate instance];
    NSString *url = @"https://www.airshop.gr/hotels?micro=true&app_ipad=1";
    if (app.clientConfiguration.hotelBookingUrl) {
        url = app.clientConfiguration.hotelBookingUrl;
    }
    NSURL *nsUrl = [NSURL URLWithString:url];
    SVModalWebViewController *svc = [[SVModalWebViewController alloc] initWithURL:nsUrl];
    [self presentViewController:svc animated:YES completion:nil];
}

- (IBAction)showFlight:(UIButton *)sender {
    AppDelegate *app = [AppDelegate instance];
    NSString *url = @"https://www.airshop.gr/airtickets?micro=true&app_ipad=1";
    if (app.clientConfiguration.airTicketsUrl) {
        url = app.clientConfiguration.airTicketsUrl;
    }
    NSURL *nsUrl = [NSURL URLWithString:url];
    SVModalWebViewController *svc = [[SVModalWebViewController alloc] initWithURL:nsUrl];
    [self presentViewController:svc animated:YES completion:nil];
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
