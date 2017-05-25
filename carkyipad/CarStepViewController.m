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

@interface CarStepViewController () <UICollectionViewDelegate>
{
    NSIndexPath *selectedIndexPath;
    CarRentalStepsViewController *parentController;
}
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
    selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];

    [[UIController sharedInstance] addShadowToView:self.headerBackView withOffset:CGSizeMake(0, 5) hadowRadius:3 shadowOpacity:0.3];
}

-(void)viewWillAppear:(BOOL)animated {
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
    selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
    self.nextButton.enabled = NO;
    self.nextButton.backgroundColor = [UIColor lightGrayColor];
}

- (void)selectCarType:(NSInteger)selIndex {
    NSArray<AvailableCars*> *availCarsArray = [AppDelegate instance].availableCars;
    NSArray<Cars*> *cars = availCarsArray[selIndex].cars;

    // bind cars to collection view
    self.carsDataSource = [[TGRArrayDataSource alloc] initWithItems:cars cellReuseIdentifier:@"CellIdentifier" configureCellBlock:^(CarCollectionViewCell *cell, Cars *item) {
        //cell.priceLabel.text = [NSString stringWithFormat:@"%ld€/day",item.pricePerDay];
        //cell.carDescriptionLabel.text = item.carsDescription;
        //cell.orSimilarLabel.text = item.subDescription;
        [self collectionCell:cell setDetails:item];
        //update cell appearence
        NSIndexPath *indexPath = [self.carsCollectionView indexPathForCell:cell];
        if (selectedIndexPath.row == indexPath.row && selectedIndexPath.section == indexPath.section) {
            cell.containerView.layer.borderWidth = 1;
            cell.priceBackView.backgroundColor = [UIColor blackColor];
            cell.priceLabel.textColor = [UIColor whiteColor];
        }
        else{
            cell.containerView.layer.borderWidth = 0;
            cell.priceBackView.backgroundColor = [UIColor lightGrayColor];
            cell.priceLabel.textColor = [UIColor blackColor];
        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:item.image]];
        [[AFImageDownloader defaultInstance] downloadImageForURLRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse  * _Nullable response, UIImage *responseObject) {
            cell.carImageView.image = responseObject;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error) {}];
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
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CellIdentifier";
    CarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}
-(void) collectionCell:(CarCollectionViewCell *)cell setDetails:(Cars *)car {
    //set car name
    NSString *name = [NSString stringWithFormat:@"%@ %@", car.carsDescription, car.subDescription];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:name];
    [attributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:14]} range:[name rangeOfString:car.subDescription]];
    cell.nameLabel.attributedText = attributedString;
    //set price
    NSString *priceStr = [NSString stringWithFormat: @"Total €%.2lf \n(€%zd/day)", car.priceTotal, car.pricePerDay];
    NSMutableAttributedString * priceAttributedString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [priceAttributedString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:12]} range:[priceStr rangeOfString:[NSString stringWithFormat:@"(€%zd/day)",car.pricePerDay]]];
    cell.priceLabel.attributedText = priceAttributedString;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    selectedIndexPath = indexPath;
    [collectionView reloadData];
    self.nextButton.enabled = YES;
    self.nextButton.backgroundColor = [UIColor blackColor];
}
#pragma mark -
-(IBAction) nextButtonAction:(UIButton *)sender{
    NSArray<Cars*> *cars = self.carsDataSource.items;
    NSInteger carTypeId = cars[selectedIndexPath.row].carsIdentifier;
    self.stepsController.results[kResultsCarTypeId] = @(carTypeId);
    self.stepsController.results[kResultsCarTypeIcon] = cars[selectedIndexPath.row].image;
    self.stepsController.results[kResultsTotalPriceCar] = @(cars[selectedIndexPath.row].priceTotal);
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
