//
//  TransferStepsViewController
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 14/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "TransferStepsViewController.h"
#import "CarkyApiClient.h"
#import "AppDelegate.h"
#import "DataModels.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "TGRArrayDataSource.h"

#define baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
NSString * const URLDirectionsFmt = @"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false";

@interface TransferStepsViewController () <CLLocationManagerDelegate,GMSMapViewDelegate, UITextFieldDelegate, UITableViewDelegate>
@property (nonatomic, strong) LatLng* userPos;
@property (nonatomic, strong) Location* selectedLocation;
@property (nonatomic, assign) NSInteger userFleetLocationId;
@property (nonatomic, strong) GMSPolyline *polyline;
@property (nonatomic,strong) TGRArrayDataSource* wellKnownLocationsDataSource;
@property (nonatomic, strong) NSMutableArray *locationMarkers;
@property (nonatomic, strong) NSMutableArray *driverMarkers;
@property (nonatomic,strong) TGRArrayDataSource* carCategoriesDataSource;
@end

@implementation TransferStepsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    _mapView.mapType = kGMSTypeNormal;
    _mapView.settings.myLocationButton = YES;
    _mapView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    // todo: remove from here
    MBProgressHUD *hud = [AppDelegate showProgressNotification:self.view];
    [[AppDelegate instance] fetchInitialData:^(BOOL b) {
        [AppDelegate hideProgressNotification:hud];
        
        [self getWellKnownLocations];
        [self loadCarCategories];
    }];
    NSDictionary *posDict = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UserDefaultLocation"];
    self.fromLocationTextField.text = posDict[@"Name"];
    _userPos = [LatLng modelObjectWithDictionary:posDict];
    Location *cl = [Location new]; cl.identifier = -1; cl.name = @"Current location"; cl.latLng = self.userPos;
    self.currentLocation = cl;
    [AppDelegate configurePSTextField:self.fromLocationTextField withColor:[UIColor whiteColor]];
    [AppDelegate configurePSTextField:self.toLocationTextField withColor:[UIColor whiteColor]];
    self.toLocationTextField.delegate = self;
    [self.view bringSubviewToFront:self.locationsTableView];
}

-(void)getWellKnownLocations {
    CarkyApiClient *api = [[AppDelegate instance] api];
    self.userFleetLocationId = ((NSNumber *)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"UserFleetLocationId"]).integerValue;
    [api GetWellKnownLocations:self.userFleetLocationId withBlock:^(NSArray<Location *> *array) {
        [AppDelegate instance].wellKnownLocations = array;
        [self loadLocations:nil];
        
        self.locationMarkers = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(Location * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(obj.latLng.lat,obj.latLng.lng);
            marker.icon = [UIImage imageNamed:@"point-1"];
            marker.userData = obj;
            marker.title = @""; // obj.name;
            marker.tappable = YES;
            marker.map = _mapView;
            [self.locationMarkers addObject:marker];
        }];
    }];
    CLLocationCoordinate2D userCoord = CLLocationCoordinate2DMake(_userPos.lat, _userPos.lng);
    self.mapView.camera = [GMSCameraPosition cameraWithTarget:userCoord zoom: 13.0];
    self.mapView.delegate = self;

}

-(void)loadLocations:(NSString *)filter {
    AppDelegate *app = [AppDelegate instance];
    NSMutableArray *wklList = [NSMutableArray arrayWithCapacity:app.wellKnownLocations.count+2];
    
    [wklList addObject:self.currentLocation];
    if (filter == nil || filter.length == 0) {
        [wklList addObjectsFromArray:app.wellKnownLocations];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", filter];
        [wklList addObjectsFromArray:[app.wellKnownLocations filteredArrayUsingPredicate:predicate]];
    }
    self.locationsTableView.backgroundColor = self.view.backgroundColor;
    
    self.wellKnownLocationsDataSource = [[TGRArrayDataSource alloc] initWithItems:[wklList copy] cellReuseIdentifier:@"locationCell" configureCellBlock:^(UITableViewCell *cell, Location *item) {
        cell.contentView.backgroundColor = self.view.backgroundColor;
        UIImageView *imageView = [cell.contentView viewWithTag:1];
        imageView.image = [UIImage imageNamed:@"locationPin"];
        if ([item.name rangeOfString:@"Airport"].location != NSNotFound) {
            imageView.image = [UIImage imageNamed:@"airlplane"];
        } else if(item.identifier == -1) {
            imageView.image = [UIImage imageNamed:@"CurrLocation"];
        }
        UILabel *label = [cell.contentView viewWithTag:2];
        label.text = item.name;
    }];
    self.locationsTableView.dataSource = self.wellKnownLocationsDataSource;
    self.locationsTableView.delegate = self;
    
    [self.locationsTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.locationsTableView) {
        Location *loc = self.wellKnownLocationsDataSource.items[indexPath.row];
        [self didSelectLocation:loc.identifier withValue:loc andText:loc.name];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        CarCategory *cCat = self.carCategoriesDataSource.items[indexPath.row];
        [self didSelectCarCategory:cCat.Id withValue:cCat andText:cCat.Description];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
    [self loadLocations:nil];
    [self.view bringSubviewToFront:self.locationsTableView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    TGRArrayDataSource *dataSource = (TGRArrayDataSource *)self.locationsTableView.dataSource;
    NSArray<Location*> *locations = dataSource.items;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",textField.text];
    if ([locations filteredArrayUsingPredicate:predicate].count > 0) {
        Location *selectedLocation = [[locations filteredArrayUsingPredicate:predicate] objectAtIndex:0];
        [self didSelectLocation:selectedLocation.identifier withValue:selectedLocation andText:selectedLocation.name];
    }
}

- (IBAction)toLocationTextChanged:(UITextField *)textField {
    [self loadLocations:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    TGRArrayDataSource *dataSource = (TGRArrayDataSource *)self.locationsTableView.dataSource;
    NSArray<Location*> *locations = dataSource.items;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",textField.text];
    return [locations filteredArrayUsingPredicate:predicate].count > 0 ? YES : NO;
}

//- (void)animateContainerViews:(UIView *)targetView {
//    NSArray *containers = @[self.locationsContainerView,self.driversContainerView];
//    [self.view bringSubviewToFront:targetView];
//    [containers enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.hidden = (obj == targetView ? YES : NO);
//        if (obj == targetView) {
//            //[self.view br
//        }
//    }];
//  [UIView animateWithDuration:0.25 animations:^{
//        self.locationsContainerView.hidden = YES;
//        self.driversContainerView.hidden = NO;
//    } completion:^(BOOL finished) {
//        //[self.view addSubview:self.driversContainerView];
//        [self.driverFindVc loadCarCategories];
//        self.driversContainerView.userInteractionEnabled = YES;
//        self.locationsContainerView.userInteractionEnabled = NO;
//    }];
//}

- (void) didSelectLocation:(NSInteger)identifier withValue:(id)value andText:(NSString *)text {
    self.selectedLocation = (Location *)value;
    self.toLocationTextField.text = text;
    [self.locationMarkers enumerateObjectsUsingBlock:^(GMSMarker *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.userData == self.selectedLocation) {
            _mapView.selectedMarker = obj;
        }
    }];
    [self getDirectionsFrom:self.userPos to:self.selectedLocation.latLng];
    [self.toLocationTextField resignFirstResponder];

    [self.view bringSubviewToFront:self.viewFindDrivers];
}

- (void) didSelectCarCategory:(NSInteger)identifier withValue:(id)value andText:(NSString *)text {
    CarkyDriverPositionsRequest *req = [self getDriversRequest:identifier];
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [self.driverMarkers enumerateObjectsUsingBlock:^(GMSMarker *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.map = nil;
    }];
    [api FindNearestCarkyDriverPositions:req withBlock:^(NSArray<CarkyDriverPositionsResponse*> *array) {
        self.driverMarkers = [NSMutableArray arrayWithCapacity:array.count];
         [array enumerateObjectsUsingBlock:^(CarkyDriverPositionsResponse * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(obj.latLng.lat,obj.latLng.lng);
            marker.icon = [UIImage imageNamed:@"car copy 3"];
            marker.userData = obj;
             marker.map = _mapView;
            //marker.title = obj.d
             [self.driverMarkers addObject:marker];
        }];
    }];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    Location *loc = marker.userData;
    _mapView.selectedMarker = marker;
    [self didSelectLocation:loc.identifier withValue:loc andText:loc.name];
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    // your code
    Location *loc = marker.userData;
    _mapView.selectedMarker = marker;
    [self didSelectLocation:loc.identifier withValue:loc andText:loc.name];
}

-(CarkyDriverPositionsRequest *)getDriversRequest:(NSInteger)carCategory {
    CarkyDriverPositionsRequest *request = [CarkyDriverPositionsRequest new];
    request.carkyCategoryId = carCategory;
    request.position = self.userPos;
    return request;
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 
 }
 

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)stepViewControllers {
    UIViewController *s0 = [self.storyboard instantiateViewControllerWithIdentifier:@"payment"];
    s0.step.title = NSLocalizedString(@"payment", nil) ;
//    UIViewController *s1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Car"];
//    s1.step.title =  NSLocalizedString(@"Car", nil) ;
//    UIViewController *s2 = [self.storyboard instantiateViewControllerWithIdentifier:@"Payment"];
//    s2.step.title =  NSLocalizedString(@"Payment", nil) ;
    
    return @[s0];
}

- (void)finishedAllSteps {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)canceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getDirectionsFrom:(LatLng *)origin to:(LatLng *)destination {
    NSString *baseUrl = [NSString stringWithFormat:URLDirectionsFmt,origin.lat,origin.lng, destination.lat, destination.lng];
    NSURL *url = [NSURL URLWithString:baseUrl];
    dispatch_async(dispatch_get_main_queue(), ^() {
        NSData *directionsData = [NSData dataWithContentsOfURL: url];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:directionsData options:NSJSONReadingMutableContainers error:&error];
        self.polyline.map = nil;
        self.polyline = [AppDelegate showRouteInMap:_mapView withResults:dict forMarker:_mapView.selectedMarker];
    });
}
// handlers
- (IBAction)gotoBack:(UIButton *)sender {
    [super showPreviousStep];
}

-(void)loadCarCategories {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    CarCategory *cc;
    cc = [CarCategory modelObjectWithDictionary:@{kCarCategoryId:@(1), kCarCategoryDescription:@"STANDARD", kCarCategoryPrice:@(50), kCarCategoryImage:@"STANDARD", kCarCategoryMaxPassengers:@(4),kCarCategoryMaxLaggages:@(3)}];
    [temp addObject:cc];
    cc = [CarCategory modelObjectWithDictionary:@{kCarCategoryId:@(2), kCarCategoryDescription:@"LUXURY SUV", kCarCategoryPrice:@(30), kCarCategoryImage:@"SUV", kCarCategoryMaxPassengers:@(4),kCarCategoryMaxLaggages:@(4)}];
    [temp addObject:cc];
    cc = [CarCategory modelObjectWithDictionary:@{kCarCategoryId:@(3), kCarCategoryDescription:@"VAN", kCarCategoryPrice:@(80), kCarCategoryImage:@"VAN", kCarCategoryMaxPassengers:@(8),kCarCategoryMaxLaggages:@(8)}];
    [temp addObject:cc];
    self.carCategoriesDataSource = [[TGRArrayDataSource alloc] initWithItems:[temp copy] cellReuseIdentifier:@"driverFindCell" configureCellBlock:^(UITableViewCell *cell, CarCategory *item) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *nameLabel = [cell.contentView viewWithTag:1];
        nameLabel.text = item.Description;
        UILabel *passLabel = [cell.contentView viewWithTag:2];
        passLabel.text = [NSString stringWithFormat:@"%ld",item.maxPassengers];
        UILabel *laggLabel = [cell.contentView viewWithTag:3];
        laggLabel.text = [NSString stringWithFormat:@"%ld",item.maxLaggages];
        UILabel *numLabel = [cell.contentView viewWithTag:6];
        numLabel.text = [NSString stringWithFormat:@"%ld",(NSInteger)0];
        UIImageView *ccImageView = [cell.contentView viewWithTag:4];
        ccImageView.image = [UIImage imageNamed:item.image];
        UILabel *priceLabel = [cell.contentView viewWithTag:8];
        priceLabel.text = [NSString stringWithFormat:@"€%ld",item.price];
        UIButton *buttonMinus = [cell.contentView viewWithTag:5];
        [buttonMinus setTitleEdgeInsets:UIEdgeInsetsMake(-5.0f, 0.0f, 0.0f, 0.0f)];
        [buttonMinus addTarget:self action:@selector(addOrSubtractCar:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *buttonPlus = [cell.contentView viewWithTag:7];
        [buttonPlus setTitleEdgeInsets:UIEdgeInsetsMake(-5.0f, 0.0f, 0.0f, 0.0f)];
        [buttonPlus addTarget:self action:@selector(addOrSubtractCar:) forControlEvents:UIControlEventTouchUpInside];
    }];
    self.carCategoriesTableView.allowsSelection = YES;
    self.carCategoriesTableView.dataSource = self.carCategoriesDataSource;
    self.carCategoriesTableView.delegate = self;
    [self.carCategoriesTableView reloadData];
}

-(void)addOrSubtractCar:(UIButton *)sender {
    UIView *parentView = sender.superview;
    UILabel *numLabel = [parentView viewWithTag:6];
    NSInteger numberValue = numLabel.text.integerValue;
    numberValue = sender.tag == 7 ? numberValue + 1 : numberValue - 1;
    if (numberValue >= 0) {
        numLabel.text = [NSString stringWithFormat:@"%ld",numberValue];
    }
}




// methods

    

@end
