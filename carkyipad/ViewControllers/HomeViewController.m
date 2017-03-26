//
//  HomeViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 12/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeViewController.h"
#import "FlatPillButton.h"
#import "IIAsyncViewController.h"
#import "AppDelegate.h"
#import "CarkyApiClient.h"
#import "DataModels.h"
#import "MBProgressHUD/MBProgressHUD.h"

@interface HomeViewController ()
@property (nonatomic,strong) CarkyApiClient *api;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    //[super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftConstraint.constant = (self.view.bounds.size.width/2 - self.buttonCarRental.bounds.size.width)/2;
    self.rightConstraint.constant = (self.view.bounds.size.width/2 - self.buttonTransfer.bounds.size.width)/2;
    self.asyncView.data = 0; // dummy data
    
    //fetch initial data
    self.api = [CarkyApiClient sharedService];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.api.hud = [MBProgressHUD HUDForView:self.view];
    self.api.hud.label.text = NSLocalizedString(@"Fetching locations", nil);
    [self.api.hud showAnimated:YES];
    [self.api GetFleetLocations:^(NSArray *array) {
        app.fleetLocations = array;
    }];
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
