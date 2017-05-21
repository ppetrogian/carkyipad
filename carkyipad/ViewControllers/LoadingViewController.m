//
//  LoadingViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 21/5/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "LoadingViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _hud.label.text = NSLocalizedString(@"Loading...", nil);
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
