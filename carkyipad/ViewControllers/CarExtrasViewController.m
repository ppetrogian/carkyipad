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
#import "ExtrasCollectionViewCell.h"
#import "ExtrasHeaderCollectionReusableView.h"
#import "UIController.h"

@interface CarExtrasViewController () 
{
    NSMutableArray *selectedListArray;
}
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
    _priceExtras = 0;
    _priceInsurances = 0;
    [self setupInit];
}
-(void) setupInit{
    [self.extrasCollectionView registerClass:[ExtrasCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    [self.extrasCollectionView registerClass:[ExtrasHeaderCollectionReusableView class]
                  forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
     [[UIController sharedInstance] addShadowToView:self.headerBackView withOffset:CGSizeMake(0, 5) hadowRadius:3 shadowOpacity:0.3];
    [self setPlaeceDetails];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareCarStep {
    self.mustPrepare = YES; // see view-will-appear
}
#pragma mark -
-(void) setPlaeceDetails{
    //set pick up details
    self.pickupPlaceDetailsView = [[[NSBundle mainBundle] loadNibNamed:@"PlaceDetailsView" owner:self options:nil] objectAtIndex:0];
    self.pickupPlaceDetailsView.frame = CGRectMake(0, 0, 280, 100);
    self.pickupPlaceDetailsView.center = CGPointMake(self.pickupBackView.frame.size.width/2, self.pickupBackView.frame.size.height/2);
    [self.pickupPlaceDetailsView setPlaceLableText:@"Pick up:" andImage:@"arrow_pickup"];
    [self.pickupPlaceDetailsView setAllDetails:@{KPlaceName:@"Mykonos national Airport", KDateValue:@"Tue 9 Jan",KTimeValue:@"12:00 AM"}];
    [self.pickupBackView addSubview:self.pickupPlaceDetailsView];
    //set drop off details
    self.dropOffPlaceDetailsView = [[[NSBundle mainBundle] loadNibNamed:@"PlaceDetailsView" owner:self options:nil] objectAtIndex:0];
    self.dropOffPlaceDetailsView.frame = CGRectMake(0, 0, 280, 100);
    self.dropOffPlaceDetailsView.center = CGPointMake(self.dropoffBackView.frame.size.width/2, self.dropoffBackView.frame.size.height/2);
    [self.dropOffPlaceDetailsView setPlaceLableText:@"Drop off:" andImage:@"arrow_drop"];
    [self.dropOffPlaceDetailsView setAllDetails:@{KPlaceName:@"Same as pick up", KDateValue:@"Tue 18 Jan",KTimeValue:@"12:30 AM"}];
    [self.dropoffBackView addSubview:self.dropOffPlaceDetailsView];
}
#pragma mark -
/*
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
*/
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_mustPrepare) {
//        [self showExtras];
//        [self showInsurances];
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
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellIdentifier";
    ExtrasCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [self collectionCell:cell setDetails:nil];
    /*
     //update cell appearence
     if (selectedIndexPath.row == indexPath.row && selectedIndexPath.section == indexPath.section) {
     cell.containerView.layer.borderWidth = 1;
     cell.priceBackView.backgroundColor = [UIColor blackColor];
     cell.priceLabel.textColor = [UIColor whiteColor];
     }
     else{
     cell.containerView.layer.borderWidth = 0;
     cell.priceBackView.backgroundColor = [UIColor lightGrayColor];
     cell.priceLabel.textColor = [UIColor blackColor];
     }*/
    if ([selectedListArray containsObject:indexPath]) {
        cell.selectionImageView.image = [UIImage imageNamed:@"check_on"];
        cell.containerView.layer.borderWidth = 1.0;
    }
    else{
        cell.selectionImageView.image = [UIImage imageNamed:@"check_off"];
        cell.containerView.layer.borderWidth = 0.0;
    }
    return cell;
}
-(void) collectionCell:(ExtrasCollectionViewCell *)cell setDetails:(NSDictionary *)dict{
    //set car name
    cell.extraNameLabel.text = @"iPhone";
    cell.priceLabel.text = @"Total £50";
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ExtrasHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.titleLabel.text = @"CHOOSE EXTRAS";
        }
        else{
            headerView.titleLabel.text = @"CHOOSE INSURANCE";
        }
        reusableview = headerView;
    }
    return reusableview;
}
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize headerSize = CGSizeMake(320, 44);
    return headerSize;
}*/
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (selectedListArray==nil) {
        selectedListArray = [[NSMutableArray alloc] init];
    }
    if ([selectedListArray containsObject:indexPath]) {
        [selectedListArray removeObject:indexPath];
    }
    else{
        [selectedListArray addObject:indexPath];
    }
    [collectionView reloadData];
}
@end
