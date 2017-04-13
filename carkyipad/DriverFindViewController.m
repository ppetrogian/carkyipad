//
//  DriverFindViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 13/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "DriverFindViewController.h"
#import "TGRArrayDataSource.h"
#import "DataModels.h"
#import "CarCategoryViewCell.h"

@interface DriverFindViewController () <UITableViewDelegate>
@property (nonatomic,strong) TGRArrayDataSource* carCategoriesDataSource;

@end

@implementation DriverFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapClick:(id)sender {
    NSLog(@"tapClick");
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
