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
#import "CarCollectionViewCell.h"
#import "UIController.h"

@interface CarStepViewController () <UICollectionViewDelegate>
{
    NSIndexPath *selectedIndexPath;
}
@property (nonatomic,strong) TGRArrayDataSource *carsDataSource;
@property (nonatomic,assign) BOOL mustPrepare;
@end

@implementation CarStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInit];
}
-(void) setupInit{
    [self.carsCollectionView registerClass:[CarCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    [self setCarSegment];
    [self setPlaeceDetails];
    [[UIController sharedInstance] addShadowToView:self.headerBackView withOffset:CGSizeMake(0, 5) hadowRadius:3 shadowOpacity:0.3];
}
- (NSArray<AvailableCars*> *)getAvailableCars {
   AppDelegate* app = [AppDelegate instance];
    NSMutableDictionary* results = self.stepsController.results;
    NSNumber *fleetLocationId = results[kResultsPickupFleetLocationId];
    NSArray<AvailableCars*> *availCars = app.availableCarsDict[fleetLocationId];
    return availCars;
}
-(void)prepareCarStep{
    self.mustPrepare = YES;
}

/*
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
}*/

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_mustPrepare) {
        //[self selectCarType:0];
        _mustPrepare = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<AvailableCars*> *availCarsArray = [self getAvailableCars];
    NSArray<Cars*> *cars = availCarsArray[self.carTypesSegmented.selectedSegmentIndex].cars;
    NSMutableDictionary* results = self.stepsController.results;
    DSLCalendarRange *selectedRange = results[kResultsDayRange];
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: selectedRange.startDay.date toDate: selectedRange.endDay.date options: 0];
    NSInteger totalprice = cars[indexPath.row].pricePerDay * (components.day+1);
    self.stepsController.results[kResultsDays] = @(components.day+1);
    
    [super showPrice:totalprice forKey:kResultsTotalPriceCar];
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
-(void) setCarSegment{
    CGRect f = self.carSegmentView.frame;
    f.size.width = [UIScreen mainScreen].bounds.size.width - f.origin.x*2;
    [self.carSegmentView updateSegmentFrame:f];
    [self.carSegmentView setAllSegmentList:@[@"CITY",@"HATCHBAG",@"SEDAN",@"EXECUTIVE",@"SUV"]];
    self.carSegmentView.delegate = self;
    [self.carSegmentView setSelectedSegmentIndex:0];
}
-(void) didSelectedSegmentIndex:(NSInteger)index{
    NSLog(@"Selected index = %zd", index);
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
    [self collectionCell:cell setDetails:nil];
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
    }
    return cell;
}
-(void) collectionCell:(CarCollectionViewCell *)cell setDetails:(NSDictionary *)dict{
    //set car name
    NSString *name = @"Peugeot 108 or similar";
    NSMutableAttributedString *attributtedString = [[NSMutableAttributedString alloc] initWithString:name];
    [attributtedString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:14]} range:[name rangeOfString:@"or similar"]];;
    cell.nameLabel.text = @"";
    cell.nameLabel.attributedText = attributtedString;
    //set price
    NSString *price = @"Total £585 \n (£65/days)";
    NSMutableAttributedString * priceAttributaedString = [[NSMutableAttributedString alloc] initWithString:price];
    [priceAttributaedString addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName : [UIFont systemFontOfSize:14]} range:[price rangeOfString:@"(£65/days)"]];
    cell.priceLabel.text = @"";
    cell.priceLabel.attributedText = priceAttributaedString;
}
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    selectedIndexPath = indexPath;
    [collectionView reloadData];
}
@end
