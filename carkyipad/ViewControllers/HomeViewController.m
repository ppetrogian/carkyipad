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
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftConstraint.constant = (self.view.bounds.size.width/2 - self.buttonCarRental.bounds.size.width)/2;
    self.rightConstraint.constant = (self.view.bounds.size.width/2 - self.buttonTransfer.bounds.size.width)/2;
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