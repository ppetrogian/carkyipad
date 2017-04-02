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
#import "RMStepsController.h"
#import "CarRentalStepsViewController.h"
#import "StepViewController.h"
#import "AFNetworking.h"
#import "AFImageDownloader.h"

@interface CarExtrasViewController () <UITableViewDelegate>
@property (nonatomic,strong) TGRArrayDataSource* carExtrasDataSource;
@property (nonatomic,assign) BOOL mustPrepare;
@end

@implementation CarExtrasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.carExtrasTableView.editing = YES;
    self.carExtrasTableView.allowsMultipleSelectionDuringEditing = YES;
    self.carExtrasTableView.allowsSelectionDuringEditing = YES;
    self.carExtrasTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGRect frame = self.carExtrasTableView.frame;
    frame.size = CGSizeMake(frame.size.width, self.carExtrasTableView.rowHeight * 4 + 2);
    self.carExtrasTableView.frame = frame;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
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
        cell.pricePerDayLabel.text = [NSString stringWithFormat:@"%ld€/day",item.price];
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_mustPrepare) {
        [self showExtras];
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
