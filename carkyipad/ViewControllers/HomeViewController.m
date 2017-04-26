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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftConstraint.constant = (self.view.bounds.size.width/2 - self.buttonCarRental.bounds.size.width)/2;
    self.rightConstraint.constant = (self.view.bounds.size.width/2 - self.buttonTransfer.bounds.size.width)/2;
    //self.asyncView.data = 0; // dummy data
    self.buttonTransfer.hidden = YES;
    self.buttonCarRental.hidden = YES;
    //self.buttonTransfer.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:35];

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
