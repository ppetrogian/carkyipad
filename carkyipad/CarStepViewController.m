//
//  CarStepViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 29/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "CarStepViewController.h"
#import "ShadowViewWithText.h"
#import "MBSegmentedControl.h"
#import "AppDelegate.h"
#import "DataModels.h"
#import "TGRArrayDataSource.h"
#import "CarViewCell.h"
#import "RMStepsController.h"
#import "StepViewController.h"
#import "CarRentalStepsViewController.h"

@interface CarStepViewController () <UICollectionViewDelegate>
@property (nonatomic,strong) TGRArrayDataSource *carsDataSource;
@end

@implementation CarStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)prepareCarStep {
    // Do any additional setup after loading the view.
    self.totalView.text = [NSString stringWithFormat:@"%@: --€", NSLocalizedString(@"Total", nil)];

    
    AppDelegate* app = (AppDelegate* )[UIApplication sharedApplication].delegate;
    self.carsDataSource = [[TGRArrayDataSource alloc] initWithItems:app.carTypes cellReuseIdentifier:@"CarCell" configureCellBlock:^(CarViewCell *cell, CarType *item) {
        cell.priceLabel.text = [NSString stringWithFormat:@"30€/day"];
        cell.carDescriptionLabel.text = item.category.Description;
        // todo: image
    }];
    self.carsCollectionView.dataSource = self.carsDataSource;
    CarRentalStepsViewController *parentVc = (CarRentalStepsViewController *)self.stepsController;
    parentVc.totalView.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    
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
