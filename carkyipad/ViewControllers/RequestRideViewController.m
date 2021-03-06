//
//  RequestRideViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 21/4/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "RequestRideViewController.h"
#import "TGRArrayDataSource.h"
#import "CarkyApiClient.h"
#import "AppDelegate.h"
#import "DataModels.h"
#import "TransferStepsViewController.h"
#import "SelectDropoffLocationViewController.h"
#import <GooglePlaces/GooglePlaces.h>

@interface RequestRideViewController () <GMSMapViewDelegate, UITableViewDelegate, UICollectionViewDelegate, UITextFieldDelegate>
@property (nonatomic,strong) TGRArrayDataSource* carCategoriesDataSource;
@property (nonatomic, readonly, weak) TransferStepsViewController *parentController;
@property (nonatomic,assign) NSInteger selectedCarType;
@end

@implementation RequestRideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedCarType = -1;
    [self.dropOffLocationTextField addTarget:self action:@selector(dropOffLocationTextField_Clicked:) forControlEvents:UIControlEventTouchDown];
    // Do any additional setup after loading the view.
    CarkyApiClient *api = [CarkyApiClient sharedService];
    
    NSInteger userFleetLocationId = [AppDelegate instance].clientConfiguration.areaOfServiceId;
    AppDelegate *app = [AppDelegate instance];
    [app showProgressNotificationWithText:nil inView:self.view];
    [api GetTransferServicePartnerAvailableCars:userFleetLocationId withBlock:^(NSArray *array) {
        [app hideProgressNotification];
        [self loadCarCategories:array];
    }];
    [self.parentController getWellKnownLocations:userFleetLocationId forMap:self.mapView];

    [AppDelegate addDropShadow:self.shadowView forUp:YES];
    self.mapView.delegate = self;
    TabletMode tm = (TabletMode)[AppDelegate instance].clientConfiguration.tabletMode;
    if (tm == TabletModeTransfer) {
        self.backButton.hidden = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(TransferStepsViewController *)parentController {
    return (TransferStepsViewController *)self.stepsController;
}

-(void)dropOffLocationTextField_Clicked:(id)sender {
    [self performSegueWithIdentifier:@"selectLocationSegue" sender:self.parentController.currentLocation];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"selectLocationSegue"]) {
        SelectDropoffLocationViewController *destController = segue.destinationViewController;
        destController.delegateRequestRide = self;
        destController.currentLocation = (Location *)sender;
        destController.fromLocationTextField.text = destController.currentLocation.name;
        destController.toLocationTextField.text = [NSString stringWithFormat:@"  %@", self.dropOffLocationTextField.text];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // Hide both keyboard and blinking cursor.
    return NO;
}

-(void)loadCarCategories:(NSArray<CarCategory*> *)arrayCategories {
    if (arrayCategories.count > 0 ) {
        NSArray<NSString*> *tempImages = @[@"audi",@"range rover",@"vito"];
        [arrayCategories enumerateObjectsUsingBlock:^(CarCategory * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            arrayCategories[idx].image = tempImages[idx];
            arrayCategories[idx].order = idx;
        }];
    }
    self.carCategoriesDataSource = [[TGRArrayDataSource alloc] initWithItems:arrayCategories cellReuseIdentifier:@"carCategoryCell" configureCellBlock:^(UICollectionViewCell *cell, CarCategory *item) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *nameLabel = [cell.contentView viewWithTag:1];
        nameLabel.text = item.name;
        UILabel *passLabel = [cell.contentView viewWithTag:2];
        passLabel.text = [NSString stringWithFormat:@"%ld",(long)item.maxPassengers];
        UILabel *laggLabel = [cell.contentView viewWithTag:3];
        laggLabel.text = [NSString stringWithFormat:@"%ld",(long)item.maxLuggages];
        UILabel *numLabel = [cell.contentView viewWithTag:6];
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)0];
        UIButton *ccImageButton = [cell.contentView viewWithTag:4];
        UIImage *image = [UIImage imageNamed:item.image];
        [ccImageButton setImage:image forState:UIControlStateSelected];
        UIImage *image_blank = [UIImage imageNamed:[NSString stringWithFormat:@"%@_blank", item.image]];
        [ccImageButton setImage:image_blank forState:UIControlStateNormal];
        ccImageButton.selected = item.order == 0 ? YES : NO;
        [ccImageButton addTarget:self action:@selector(carButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        // price dependent on zone
        UILabel *priceLabel = [cell.contentView viewWithTag:8];
        if(item.price > 0)
            priceLabel.text = [NSString stringWithFormat:@"€%ld",(long)item.price];
        else
            priceLabel.text = @"€__";
    }];
    self.carCategoriesCollectionView.allowsSelection = YES;
    self.carCategoriesCollectionView.dataSource = self.carCategoriesDataSource;
    self.carCategoriesCollectionView.delegate = self;
    [self.carCategoriesCollectionView reloadData];
}

-(IBAction)requestRideButton_Click:(UIButton *)sender {
    [self.parentController showNextStep];
}

-(void)carButton_Clicked:(UIButton *)sender {
    UICollectionViewCell *cell = [AppDelegate parentCollectionViewCell:sender];
    UICollectionView* collView = [AppDelegate parentCollectionView:cell];
    NSIndexPath *indexPath = [collView indexPathForCell:cell];
    [self collectionView:collView didSelectItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.selectedCarType != indexPath.row) {
        if (self.dropOffLocationTextField.text.length == 0) {
            [self.parentController showAlertViewWithMessage:@"Please select location first!" andTitle:@"Error"];
            return;
        }
        NSIndexPath *prevPath = [NSIndexPath indexPathForItem:self.selectedCarType inSection:0];
        [collectionView cellForItemAtIndexPath:prevPath].selected = NO;
        [self collectionView:collectionView didDeselectItemAtIndexPath:prevPath]; // single selection
        self.selectedCarType = indexPath.row;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.selected = YES;
        UIButton *ccImageButton = [cell.contentView viewWithTag:4];
        ccImageButton.selected = YES;
        self.requestRideButton.enabled = YES;
        self.requestRideButton.backgroundColor = [UIColor blackColor];
        CarCategory *cCat = self.carCategoriesDataSource.items[indexPath.row];
        [self.parentController didSelectCarCategory:cCat.Id withValue:cCat andText:cCat.name forMap:self.mapView];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIButton *ccImageButton = [cell.contentView viewWithTag:4];
    ccImageButton.selected = NO;
}

//selected from popup screen
- (void)didSelectLocation:(NSInteger)identifier withValue:(id)value andText:(NSString *)t {
    if (self.mapView.selectedMarker) {
        self.mapView.selectedMarker.icon = [UIImage imageNamed:@"point-1"];
    }
    Location *loc = value;
    self.dropOffLocationTextField.text = [NSString stringWithFormat:@"        %@", loc.name];
    if (loc.identifier <= 0) {
        GMSPlacesClient *placesClient = [GMSPlacesClient sharedClient];
        [placesClient lookUpPlaceID:loc.placeId callback:^(GMSPlace *place, NSError *error) {
            loc.latLng = [[LatLng alloc] initWithDictionary:@{@"Lat":@(place.coordinate.latitude), @"Lng":@(place.coordinate.longitude) }];
            CarkyApiClient *api = [CarkyApiClient sharedService];
            AppDelegate *app = [AppDelegate instance];
            [api ValidateLocation:loc.latLng forLocation:app.clientConfiguration.areaOfServiceId withBlock:^(BOOL b) {
                if (b) {
                    [self showLocationAndRouteInMap:loc];
                }
                else {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:NSLocalizedString(@"Transfer to the selected place is not available", nil) preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
            //if ([app.locationBounds containsCoordinate:CLLocationCoordinate2DMake(loc.latLng.lat, loc.latLng.lng)]) {
        }];
    } else {
        [self showLocationAndRouteInMap:loc];
    }
}
     
-(void)showLocationAndRouteInMap:(Location *)loc {
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [api GetTransferServicePricesForZone: loc.zoneId orLatLng:loc.latLng withBlock:^(NSArray<CarPrice *> *arrayPrices) {
        [arrayPrices enumerateObjectsUsingBlock:^(CarPrice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CarCategory *iCategory = self.carCategoriesDataSource.items[idx];
            iCategory.price = obj.price;
            UICollectionViewCell *cell = [self.carCategoriesCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
            UILabel *priceLabel = [cell.contentView viewWithTag:8];
            priceLabel.hidden = NO;
            priceLabel.text = [NSString stringWithFormat:@"€%ld",(long)obj.price];
        }];
    }];
    [self.parentController didSelectLocation:loc.identifier withValue:loc andText:loc.name forMap:self.mapView];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    //[[AppDelegate instance] showProgressNotificationWithText:NSLocalizedString(@"Please wait...", nil) inView:self.view];
    if (mapView.selectedMarker) {
        mapView.selectedMarker.icon = [UIImage imageNamed:@"point-1"];
    }    
    
    id loc = marker.userData;
    if ([loc isKindOfClass:[Location class]]) {
        if (marker != mapView.selectedMarker) {
            mapView.selectedMarker = marker;
            [self didSelectLocation:0 withValue:loc andText:nil];
        }
    }
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    //[[AppDelegate instance] showProgressNotificationWithText:NSLocalizedString(@"Please wait...", nil) inView:self.view];
    if (mapView.selectedMarker) {
        mapView.selectedMarker.icon = [UIImage imageNamed:@"point-1"];
    }
    id loc = marker.userData;
    if ([loc isKindOfClass:[Location class]]) {
        if (marker != mapView.selectedMarker) {
            mapView.selectedMarker = marker;
            [self didSelectLocation:0 withValue:loc andText:nil];
        }
    }
}
- (IBAction)backButton_TouchUp:(UIButton *)sender {
    [self.stepsController showPreviousStep];
}

 
@end
