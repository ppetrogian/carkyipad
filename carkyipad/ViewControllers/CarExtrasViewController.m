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
#import "InsurancesCollectionViewCell.h"
#import "ExtrasHeaderCollectionReusableView.h"
#import "UIController.h"
#import "CarRentalStepsViewController.h"
#import "AFNetworking.h"
#import "AFImageDownloader.h"

static NSString *extraCellIdentifier = @"extraCellIdentifier";
static NSString *insuranceCellIdentifier = @"insuranceCellIdentifier";

@interface CarExtrasViewController ()
{
    NSMutableArray *selectedExtrasListArray;
    NSIndexPath *selectedInsurance;
}
@property (nonatomic,strong) TGRArrayDataSource* carExtrasDataSource;
@property (nonatomic,strong) TGRArrayDataSource* carInsurancesDataSource;
@property (nonatomic,assign) BOOL mustPrepare;
@property (nonatomic,assign) NSInteger priceExtras;
@property (nonatomic,assign) NSInteger priceInsurances;
@property (nonatomic, weak) CarRentalStepsViewController *parentRentalController;
@end

@implementation CarExtrasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // setup table properties
    _priceExtras = 0;
    _priceInsurances = 0;
    self.parentRentalController = (CarRentalStepsViewController *)self.stepsController;
    [self setupInit];
}

-(void) setupInit{
    [self.extrasCollectionView registerClass:[ExtrasCollectionViewCell class] forCellWithReuseIdentifier:extraCellIdentifier];
    [self.extrasCollectionView registerClass:[InsurancesCollectionViewCell class] forCellWithReuseIdentifier:insuranceCellIdentifier];
     [[UIController sharedInstance] addShadowToView:self.headerBackView withOffset:CGSizeMake(0, 5) hadowRadius:3 shadowOpacity:0.3];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.stepsController.results[kResultsCarTypeIcon]]];
    [[AFImageDownloader defaultInstance] downloadImageForURLRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse  * _Nullable response, UIImage *responseObject) {
        self.carImageView.image = responseObject;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error) {}];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setPlaceDetails];
}

-(void) setPlaceDetails {
    NSDictionary *results = self.stepsController.results;
    //set pick up details
    self.pickupPlaceDetailsView = [[[NSBundle mainBundle] loadNibNamed:@"PlaceDetailsView" owner:self options:nil] objectAtIndex:0];
    self.pickupPlaceDetailsView.frame = CGRectMake(0, 0, 280, 100);
    self.pickupPlaceDetailsView.center = CGPointMake(self.pickupBackView.frame.size.width/2, self.pickupBackView.frame.size.height/2);
    [self.pickupPlaceDetailsView setPlaceLableText:@"Pick up:" andImage:@"arrow_pickup"];
    
    [self.pickupPlaceDetailsView setAllDetails:results isForPickup:YES];
    [self.pickupBackView addSubview:self.pickupPlaceDetailsView];
    //set drop off details
    self.dropOffPlaceDetailsView = [[[NSBundle mainBundle] loadNibNamed:@"PlaceDetailsView" owner:self options:nil] objectAtIndex:0];
    self.dropOffPlaceDetailsView.frame = CGRectMake(0, 0, 280, 100);
    self.dropOffPlaceDetailsView.center = CGPointMake(self.dropoffBackView.frame.size.width/2, self.dropoffBackView.frame.size.height/2);
    [self.dropOffPlaceDetailsView setPlaceLableText:@"Drop off:" andImage:@"arrow_drop"];
    [self.dropOffPlaceDetailsView setAllDetails:results isForPickup:NO];
    [self.dropoffBackView addSubview:self.dropOffPlaceDetailsView];
    selectedInsurance = [NSIndexPath indexPathForRow:0 inSection:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareCarStep {
    self.mustPrepare = YES; // see view-will-appear
}

#pragma mark -

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    AppDelegate *app = [AppDelegate instance];
    return section == 0 ? app.carExtras.count : app.carInsurances.count;
}
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *app = [AppDelegate instance];
    ExtrasCollectionViewCell *cell;
    if (indexPath.section == 0) {
        ExtrasCollectionViewCell *extraCell = [collectionView dequeueReusableCellWithReuseIdentifier:extraCellIdentifier forIndexPath:indexPath];
        [self extraCollectionCell:extraCell setDetails:app.carExtras[indexPath.row]];
        cell = extraCell;
    }
    else {
        InsurancesCollectionViewCell *insCell = [collectionView dequeueReusableCellWithReuseIdentifier:insuranceCellIdentifier forIndexPath:indexPath];
        [self insuranceCollectionCell:insCell setDetails:app.carInsurances[indexPath.row] forIndexPath:indexPath];
        cell = insCell;
    }

    if ((indexPath.section == 0 && [selectedExtrasListArray containsObject:indexPath]) ||
        (indexPath.section == 1 && selectedInsurance.row == indexPath.row)) {
        cell.containerView.layer.borderWidth = 1.0;
        cell.priceLabel.backgroundColor = [UIColor blackColor];
        cell.priceLabel.textColor = [UIColor whiteColor];
    }
    else {
        cell.containerView.layer.borderWidth = 0.0;
        cell.priceLabel.backgroundColor = [UIColor lightGrayColor];
        cell.priceLabel.textColor = [UIColor blackColor];
    }
    if (indexPath.section == 1 && app.carInsurances[indexPath.row].pricePerDay == 0) {
        cell.priceLabel.text = @"Included";
    }
    return cell;
}
-(void) extraCollectionCell:(ExtrasCollectionViewCell *)cell setDetails:(CarExtra *)extra{
    //set car extra
    cell.extraNameLabel.text = extra.Name;
    cell.extraDescriptionLabel.text = extra.Description;
    cell.priceLabel.text = [NSString stringWithFormat: @"Total €%zd", extra.pricePerDay];
    NSDictionary *iconsDict = @{@"iPhone":@"carExtra_iphone",@"Wi-Fi":@"carExtra_wifi",@"Child Seat":@"carExtra_childseat",@"Sim card":@"carExtra_SimCard",@"iPhone 6":@"carExtra_iphone"};
    if (iconsDict[extra.Name]) {
        cell.extraImageView.image = [UIImage imageNamed:iconsDict[extra.Name]];
    } else if(extra.icon.length > 0) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:extra.icon]];
        [[AFImageDownloader defaultInstance] downloadImageForURLRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse  * _Nullable response, UIImage *responseObject) {
            cell.extraImageView.image = responseObject;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error) {}];
    }
    
}

-(void) insuranceCollectionCell:(InsurancesCollectionViewCell *)cell setDetails:(CarInsurance *)ins forIndexPath:(NSIndexPath *)indexPath {
    //set car insurance
    cell.extraNameLabel.text = ins.title;
    cell.priceLabel.text = [NSString stringWithFormat: @"Total €%zd", ins.pricePerDay];
    NSArray *icons = @[@"Fill 30",@"Fill 30",@"Fill 15"];
    if (indexPath.row < icons.count) {
        cell.extraImageView.image = [UIImage imageNamed:icons[indexPath.row]];
    } else if(ins.icon.length > 0) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ins.icon]];
        [[AFImageDownloader defaultInstance] downloadImageForURLRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse  * _Nullable response, UIImage *responseObject) {
            cell.extraImageView.image = responseObject;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error) {}];
    }
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
    if (selectedExtrasListArray == nil) {
        selectedExtrasListArray = [[NSMutableArray alloc] init];
    }
    if (indexPath.section == 0) {
        if ([selectedExtrasListArray containsObject:indexPath]) {
            [selectedExtrasListArray removeObject:indexPath];
        }
        else{
            [selectedExtrasListArray addObject:indexPath];
        }
    }
    else if (indexPath.row != selectedInsurance.row) {
       selectedInsurance = indexPath;
    }
    [collectionView reloadData];
}

#pragma mark -
-(IBAction) nextButtonAction:(UIButton *)sender {
    // save selected info to parent results
    AppDelegate *app = [AppDelegate instance];
    NSMutableArray *extras = [[NSMutableArray alloc] initWithCapacity:app.carExtras.count];
    [selectedExtrasListArray enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.section == 0) {
            [extras addObject:@(app.carExtras[obj.row].Id)];
        }
    }];
    self.stepsController.results[kResultsExtras] = extras;
    NSInteger insuranceId = app.carInsurances[selectedInsurance.row].Id;
    self.stepsController.results[kResultsInsuranceId] = @(insuranceId);
    
    // call api to get charges
    CarkyApiClient *api = [CarkyApiClient sharedService];
    RentalBookingRequest *request = [self.parentRentalController getRentalRequestWithCC:YES];
    [api RentalChargesForIpad:request withBlock:^(NSArray *array) {
        if ([array.firstObject isKindOfClass:NSString.class]) {
            [self.parentRentalController showAlertViewWithMessage:array.firstObject andTitle:@"Error"];
            return;
        }
        ChargesForIPadResponse *charges = array.firstObject;
        self.parentRentalController.results[kResultsTotalPrice] = @(charges.total);
        if (self.stepDelegate && [self.stepDelegate respondsToSelector:@selector(didSelectedNext:)]) {
            [self.stepDelegate didSelectedNext:sender];
        }
    }];
}

-(IBAction)backButtonAction:(UIButton *)sender{
    if (self.stepDelegate && [self.stepDelegate respondsToSelector:@selector(didSelectedBack:)]) {
        [self.stepDelegate didSelectedBack:sender];
    }
}
@end
