//
//  CarExtrasViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 02/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "CarExtrasViewController.h"
#import "AppDelegate.h"
#import "DataModels.h"
#import "TGRArrayDataSource.h"
#import "ExtrasTableViewCell.h"
#import "InsuranceTableViewCell.h"
#import "RMStepsController.h"
#import "CarRentalStepsViewController.h"
#import "StepViewController.h"
#import "AFNetworking.h"
#import "AFImageDownloader.h"

@interface CarExtrasViewController () <UITableViewDelegate>
@property (nonatomic,strong) TGRArrayDataSource* carExtrasDataSource;
@property (nonatomic,strong) TGRArrayDataSource* carInsurancesDataSource;
@property (nonatomic,assign) BOOL mustPrepare;
@property (nonatomic,assign) NSInteger priceExtras;
@property (nonatomic,assign) NSInteger priceInsurances;
@end

@implementation CarExtrasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // setup table properties
    self.carExtrasTableView.editing = YES;
    self.carExtrasTableView.allowsMultipleSelectionDuringEditing = YES;
    self.carExtrasTableView.allowsSelectionDuringEditing = YES;
    self.carExtrasTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.carInsurancesTableView.editing = YES;
    self.carInsurancesTableView.allowsMultipleSelectionDuringEditing = YES;
    self.carInsurancesTableView.allowsSelectionDuringEditing = YES;
    self.carInsurancesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // adjust frames for 4 items
    CGRect frame1 = self.carExtrasTableView.frame;
    frame1.size = CGSizeMake(frame1.size.width, self.carExtrasTableView.rowHeight * 4 + 2);
    self.carExtrasTableView.frame = frame1;
    CGRect frame2 = self.carInsurancesTableView.frame;
    frame2.size = CGSizeMake(frame2.size.width, self.carInsurancesTableView.rowHeight * 4 + 2);
    self.carInsurancesTableView.frame = frame2;
    _priceExtras = 0;
    _priceInsurances = 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *app = [AppDelegate instance];
    NSInteger numDays = ((NSNumber *)self.stepsController.results[kResultsDays]).integerValue;
    if (tableView == self.carExtrasTableView) {
        _priceExtras += app.carExtras[indexPath.row].pricePerDay * numDays;
        [super showPrice:_priceExtras forKey:kResultsTotalPriceExtras];
    } else {
        _priceInsurances += app.carInsurances[indexPath.row].pricePerDay * numDays;
        [super showPrice:_priceInsurances forKey:kResultsTotalPriceInsurance];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *app = [AppDelegate instance];
    NSInteger numDays = ((NSNumber *)self.stepsController.results[kResultsDays]).integerValue;
    if (tableView == self.carExtrasTableView) {
        _priceExtras -= app.carExtras[indexPath.row].pricePerDay * numDays;
        [super showPrice:_priceExtras forKey:kResultsTotalPriceExtras];
    } else {
        _priceInsurances -= app.carInsurances[indexPath.row].pricePerDay * numDays;
        [super showPrice:_priceInsurances forKey:kResultsTotalPriceInsurance];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareCarStep {
    self.mustPrepare = YES; // see view-will-appear
}

-(void)showExtras {
    AppDelegate *app = [AppDelegate instance];
    static NSString *reuseIdentifier = @"ExtrasCell";
    NSInteger lastId = app.carExtras[app.carExtras.count-1].Id;
    self.carExtrasDataSource = [[TGRArrayDataSource alloc] initWithItems:app.carExtras cellReuseIdentifier:reuseIdentifier configureCellBlock:^(ExtrasTableViewCell *cell, CarExtra *item) {
        cell.isLast = item.Id == lastId;
        cell.pricePerDayLabel.text = [NSString stringWithFormat:@"%ld€/day",item.pricePerDay];
        cell.extraTitleLabel.text = item.Name;
        NSDictionary *iconsDict = @{@"iPhone":@"carExtra_iphone",@"Wi-Fi":@"carExtra_wifi",@"Child Seat":@"carExtra_childseat",@"Sim card":@"carExtra_SimCard",@"iPhone 6":@"carExtra_iphone"};
        if (iconsDict[item.Name]) {
            cell.extraImageView.image = [UIImage imageNamed:iconsDict[item.Name]];
        } else {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:item.icon]];
            [[AFImageDownloader defaultInstance] downloadImageForURLRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse  * _Nullable response, UIImage *responseObject) {
                cell.extraImageView.image = responseObject;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error) {}];
        }
    }];
    self.carExtrasTableView.dataSource = self.carExtrasDataSource;
    self.carExtrasTableView.delegate = self;
    [self.carExtrasTableView reloadData];
}

-(void)showInsurances {
    AppDelegate *app = [AppDelegate instance];
    static NSString *reuseIdentifier = @"InsuranceCell";
    NSInteger lastId = app.carInsurances[app.carInsurances.count-1].Id;
    self.carInsurancesDataSource = [[TGRArrayDataSource alloc] initWithItems:app.carInsurances cellReuseIdentifier:reuseIdentifier configureCellBlock:^(InsuranceTableViewCell *cell, CarInsurance *item) {
        cell.isLast = item.Id == lastId;
        cell.insurancePriceLabel.text = [NSString stringWithFormat:@"%ld€/day",item.pricePerDay];
        cell.insuranceTitleLabel.text = item.title;
    }];
    self.carInsurancesTableView.dataSource = self.carInsurancesDataSource;
    self.carInsurancesTableView.delegate = self;
    [self.carInsurancesTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_mustPrepare) {
        [self showExtras];
        [self showInsurances];
        _mustPrepare = NO;
    }
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
