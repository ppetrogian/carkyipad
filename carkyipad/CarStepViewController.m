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
#import "AFNetworking.h"
#import "AFImageDownloader.h"
#import "DSLCalendarView.h"

@interface CarStepViewController () <UICollectionViewDelegate>
@property (nonatomic,strong) TGRArrayDataSource *carsDataSource;
@property (nonatomic,assign) BOOL mustPrepare;
@end

@implementation CarStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSArray<AvailableCars*> *)getAvailableCars {
   AppDelegate* app = [AppDelegate instance];
    NSMutableDictionary* results = self.stepsController.results;
    NSNumber *fleetLocationId = results[kResultsPickupFleetLocationId];
    NSArray<AvailableCars*> *availCars = app.availableCarsDict[fleetLocationId];
    return availCars;
}

- (void)selectCarType:(NSInteger)selIndex {
    NSArray<AvailableCars*> *availCarsArray = [self getAvailableCars];
    // bind cars to collection view
    self.carsDataSource = [[TGRArrayDataSource alloc] initWithItems:availCarsArray[selIndex].cars cellReuseIdentifier:@"CarCell" configureCellBlock:^(CarViewCell *cell, Cars *item) {
        cell.priceLabel.text = [NSString stringWithFormat:@"%ld€/day",item.pricePerDay];
        cell.carDescriptionLabel.text = item.carsDescription;
        cell.orSimilarLabel.text = item.subDescription;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:item.image]];
        [[AFImageDownloader defaultInstance] downloadImageForURLRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse  * _Nullable response, UIImage *responseObject) {
            cell.carImage.image = responseObject;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error) {}];
    }];
    self.carsCollectionView.dataSource = self.carsDataSource;
    self.carsCollectionView.delegate = self;
    [self.carsCollectionView reloadData];
}

- (IBAction)carTypeChanged:(MBSegmentedControl *)sender {
    [self selectCarType:sender.selectedSegmentIndex];
}

-(void)prepareCarStep {
    CarRentalStepsViewController *parentVc = (CarRentalStepsViewController *)self.stepsController;
    parentVc.totalView.text = [NSString stringWithFormat:@"%@: --€", NSLocalizedString(@"Total", nil)];
    [parentVc.totalView setNeedsDisplay];
    // fill segmented control and collection view with available cars
    NSArray<AvailableCars*> *availCars = [self getAvailableCars];
    [self.carTypesSegmented removeAllSegments];
    [availCars enumerateObjectsUsingBlock:^(AvailableCars * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_carTypesSegmented insertSegmentWithTitle:obj.name atIndex:idx animated:NO];
    }];
    self.carTypesSegmented.selectedSegmentIndex = 0;
    self.mustPrepare = YES; // see view-will-appear
    parentVc.totalView.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_mustPrepare) {
        [self selectCarType:0];
        _mustPrepare = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<AvailableCars*> *availCarsArray = [self getAvailableCars];
    NSArray<Cars*> *cars = availCarsArray[self.carTypesSegmented.selectedSegmentIndex].cars;
    NSMutableDictionary* results = self.stepsController.results;
    DSLCalendarRange *selectedRange = results[kResultsDayRange];
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: selectedRange.startDay.date toDate: selectedRange.endDay.date options: 0];
    NSInteger totalprice = cars[indexPath.row].pricePerDay * (components.day+1);
    self.stepsController.results[kResultsDays] = @(components.day+1);
    
    [super showPrice:totalprice forKey:kResultsTotalPriceCar];
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
