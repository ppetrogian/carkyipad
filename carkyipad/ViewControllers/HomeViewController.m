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
@import SafariServices;

@interface HomeViewController () <SFSafariViewControllerDelegate>
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
    self.homeMapView.mapType = kGMSTypeNormal;
    AppDelegate *app = [AppDelegate instance];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showBook:(UIButton *)sender {
    SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.booking.com"]];
    [self presentViewController:svc animated:YES completion:nil];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.booking.com"]];
}
- (IBAction)showFlight:(UIButton *)sender {
    SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.airtickets.com"]];
    [self presentViewController:svc animated:YES completion:nil];
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
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
