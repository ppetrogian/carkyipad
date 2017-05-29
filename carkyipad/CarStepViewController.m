//
//  CarStepViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 29/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "CarStepViewController.h"
#import "ShadowViewWithText.h"
#import "AppDelegate.h"
#import "DataModels.h"
#import "TGRArrayDataSource.h"
#import "CarViewCell.h"
#import "RMStepsController.h"
#import "StepViewController.h"
#import "CarRentalStepsViewController.h"
#import "AFNetworking.h"
#import "AFImageDownloader.h"
#import "CarCollectionViewCell.h"
#import "UIController.h"
#import "DetailsStepViewController.h"
#import "CalendarRange.h"
#import "ButtonUtils.h"
#import "CarTypeSegmentView.h"

@interface CarStepViewController () <UICollectionViewDelegate>
{
    CarRentalStepsViewController *parentController;
}
@property (nonatomic, assign) NSInteger selectedCarOrder;
@property (nonatomic,strong) TGRArrayDataSource *carsDataSource;
@end

@implementation CarStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    parentController = (CarRentalStepsViewController *)self.stepsController;
    [self setupInit];
}
-(void) setupInit {
    [self.carsCollectionView registerClass:[CarCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    self.selectedCarOrder = -1;
    self.selCategoryIndex = 0;
    [[UIController sharedInstance] addShadowToView:self.headerBackView withOffset:CGSizeMake(0, 5) hadowRadius:3 shadowOpacity:0.3];
}

-(void)viewWillAppear:(BOOL)animated {
    [[AppDelegate instance] hideProgressNotification];
    [super viewWillAppear:animated];
    [self setPlaceDetails];
}

-(void)prepareCarStep {
    // set number of days
    CalendarRange *selectedRange = self.stepsController.results[kResultsDayRange];
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: selectedRange.startDay.date toDate: selectedRange.endDay.date options: 0];
    self.stepsController.results[kResultsDays] = @(components.day);
    // load available cars
    AppDelegate *app = [AppDelegate instance];
    CarkyApiClient *api = [CarkyApiClient sharedService];
    CalendarRange *range = self.stepsController.results[kResultsDayRange];
    [api GetRentServiceAvailableCarsForLocation:app.clientConfiguration.areaOfServiceId andPickupDate:range.startDay.date andDropoffDate:range.endDay.date withBlock:^(NSArray *array) {
        app.availableCars = array;
        [self setCarSegments:array];
        [self selectCarType:0];
    }];
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
#pragma mark -
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
}

-(void) setCarSegments:(NSArray *)availableCars {
    CGRect f = self.carSegmentView.frame;
    f.size.width = [UIScreen mainScreen].bounds.size.width - f.origin.x*2;
    [self.carSegmentView updateSegmentFrame:f];
    NSArray *labels = [AppDelegate mapObjectsFromArray:availableCars withBlock:^id(AvailableCars *obj, NSUInteger idx) {
        return obj.name;
    }];
    [self.carSegmentView setAllSegmentList:labels];
    self.carSegmentView.delegate = self;
    [self.carSegmentView setSelectedSegmentIndex:0];
}

-(void) didSelectedSegmentIndex:(NSInteger)index{
    NSLog(@"Selected index = %zd", index);
    [self selectCarType:index];
    self.selectedCarOrder = -1;
    self.nextButton.enabled = NO;
    self.nextButton.backgroundColor = [UIColor lightGrayColor];
}

- (void)selectCarType:(NSInteger)selIndex {
    self.selCategoryIndex = selIndex;
    NSArray<AvailableCars*> *availCarsArray = [AppDelegate instance].availableCars;
    NSArray<Cars*> *cars = availCarsArray[selIndex].cars;
    [cars enumerateObjectsUsingBlock:^(Cars * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.order = idx;
    }];

    // bind cars to collection view
    self.carsDataSource = [[TGRArrayDataSource alloc] initWithItems:cars cellReuseIdentifier:@"CellIdentifier" configureCellBlock:^(CarCollectionViewCell *cell, Cars *item) {
        [self collectionCell:cell setDetails:item];
        //update cell appearence
        if (self.selectedCarOrder == item.order) {
            cell.containerView.layer.borderWidth = 1;
            cell.priceBackView.backgroundColor = [UIColor blackColor];
            cell.priceLabel.textColor = [UIColor whiteColor];
        }
        else {
            cell.containerView.layer.borderWidth = 0;
            cell.priceBackView.backgroundColor = [UIColor lightGrayColor];
            cell.priceLabel.textColor = [UIColor blackColor];
        }
        if (![item.image isEqualToString:cell.imageHiddenLabel.text]) {
            cell.imageHiddenLabel.text = item.image;
            cell.carImageView.image = nil;
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:item.image]];
            [[AFImageDownloader defaultInstance] downloadImageForURLRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse  * _Nullable response, UIImage *responseObject) {
                cell.carImageView.image = responseObject;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error) {}];
        }
    }];
    self.carsCollectionView.dataSource = self.carsDataSource;
    self.carsCollectionView.delegate = self;
    [self.carsCollectionView reloadData];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void) collectionCell:(CarCollectionViewCell *)cell setDetails:(Cars *)car {
    //set car name
    NSString *name = [NSString stringWithFormat:@"%@\n%@", car.carsDescription, car.subDescription];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:name];
    [attributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:14]} range:[name rangeOfString:car.subDescription]];
    cell.nameLabel.attributedText = attributedString;
    //set price
    NSString *priceStr = [NSString stringWithFormat: @"Total €%.2lf\n(€%zd/day)", car.priceTotal, car.pricePerDay];
    NSMutableAttributedString * priceAttributedString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [priceAttributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:12]} range:[priceStr rangeOfString:[NSString stringWithFormat:@"(€%zd/day)",car.pricePerDay]]];

    switch (car.transmissionType) {
        case 1:
             cell.modeLabel.text = NSLocalizedString(@"Manual", nil);
            break;
        case 2:
            cell.modeLabel.text = NSLocalizedString(@"Automatic", nil);
            break;
        default:
            break;
    }
    switch (car.fuelType) {
        case 1:
            cell.typeLabel.text = NSLocalizedString(@"Gas", nil);
            break;
        case 2:
            cell.typeLabel.text = NSLocalizedString(@"Diesel", nil);
            break;
        case 3:
            cell.typeLabel.text = NSLocalizedString(@"LPG", nil);
            break;
        default:
            break;
    }
    cell.priceLabel.attributedText = priceAttributedString;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.selectedCarOrder != indexPath.row) {
        [collectionView performBatchUpdates:^{
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:2];
            if(self.selectedCarOrder >= 0)
               [temp addObject:[NSIndexPath indexPathForRow:self.selectedCarOrder inSection:0]];
            [temp addObject:indexPath];
            self.selectedCarOrder = indexPath.row;
            [collectionView reloadItemsAtIndexPaths:temp];
        } completion:nil];
        //[collectionView reloadData];
    }
    if (self.selectedCarOrder >= 0) {
        [self.nextButton enableButton];
    }
}

-(void)performSelectCategory:(NSInteger)index {
    UIButton *button = [self.carSegmentView getSegmentedButtonForIndex:index];
    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)rightSGR_swipe:(UISwipeGestureRecognizer *)sender {
    NSArray<AvailableCars*> *availCarsArray = [AppDelegate instance].availableCars;
    if (self.selCategoryIndex < availCarsArray.count - 1) {
        [self performSelectCategory:self.selCategoryIndex+1];
    }
}

- (IBAction)leftSGR_swipe:(UISwipeGestureRecognizer *)sender {
    if (self.selCategoryIndex > 0) {
        [self performSelectCategory:self.selCategoryIndex - 1];
    }
}

#pragma mark -
-(IBAction) nextButtonAction:(UIButton *)sender{
    NSArray<Cars*> *cars = self.carsDataSource.items;
    NSInteger carTypeId = cars[self.selectedCarOrder].carsIdentifier;
    self.stepsController.results[kResultsCarTypeId] = @(carTypeId);
    self.stepsController.results[kResultsCarTypeIcon] = cars[self.selectedCarOrder].image;
    self.stepsController.results[kResultsTotalPriceCar] = @(cars[self.selectedCarOrder].priceTotal);
    if(!self.stepsController.results[kResultsTotalPriceExtras])
        self.stepsController.results[kResultsTotalPriceExtras] = @(0);
    if(!self.stepsController.results[kResultsTotalPriceInsurance])
        self.stepsController.results[kResultsTotalPriceInsurance] = @(0);
    CalendarRange *selectedRange = self.stepsController.results[kResultsDayRange];
    AppDelegate *app = [AppDelegate instance];
    [app fetchCarsDataForType:carTypeId andPickupDate:selectedRange.startDay.date andDropoffDate:selectedRange.endDay.date andBlock:^(NSArray *arr) {
        if ([arr.firstObject isKindOfClass:NSString.class]) {
            [parentController showAlertViewWithMessage:arr.firstObject andTitle:@"Error"];
            return;
        }
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
