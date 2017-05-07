//
//  SelectDropoffLocationViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 23/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "SelectDropoffLocationViewController.h"
#import "AppDelegate.h"
#import "TransferStepsViewController.h"
#import "TGRArrayDataSource.h"
#import "DataModels.h"
#import "RequestRideViewController.h"

@interface SelectDropoffLocationViewController () <UITableViewDelegate, UITextFieldDelegate, GMSAutocompleteFetcherDelegate>
@property (nonatomic,strong) TGRArrayDataSource* wellKnownLocationsDataSource;
@property (nonatomic,strong) GMSAutocompleteFetcher* fetcherPlaces;
@end

@implementation SelectDropoffLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadLocations:nil andPredictions:nil];
    self.fromLocationTextField.text = self.currentLocation.name;
    [AppDelegate addDropShadow:self.shadowView forUp:NO];
    // Set up the autocomplete filter.
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter; // kGMSPlacesAutocompleteTypeFilterEstablishment;
    filter.country = @"GR";
    // Create the fetcher.
    _fetcherPlaces = [[GMSAutocompleteFetcher alloc] initWithBounds:self.locationBounds filter:filter];
    _fetcherPlaces.delegate = self;
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // Hide both keyboard and blinking cursor.
    if (textField == self.fromLocationTextField) {
        return NO;
    }
    return YES;
}

- (IBAction)toLocationTextField_TextChanged:(UITextField *)textField {
    if (textField.text.length < 1) {
        [self loadLocations:textField.text andPredictions:nil];
        return;
    }
    [_fetcherPlaces sourceTextHasChanged:textField.text];
}

-(void)loadLocations:(NSString *)filter andPredictions:(NSArray<GMSAutocompletePrediction*> *)predictions {
    AppDelegate *app = [AppDelegate instance];
    NSMutableArray *wklList = [NSMutableArray arrayWithCapacity:app.wellKnownLocations.count+2 + predictions.count];
    
    //[wklList addObject:self.currentLocation];
    if (filter == nil || filter.length == 0) {
        [wklList addObjectsFromArray:app.wellKnownLocations];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", filter];
        [wklList addObjectsFromArray:[app.wellKnownLocations filteredArrayUsingPredicate:predicate]];
    }
    if (predictions) {
        for (GMSAutocompletePrediction *prediction in predictions) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", @"country"];
            if ([prediction.types filteredArrayUsingPredicate:predicate].count == 0) {
                [wklList addObject:prediction];
            }
        }
    }
    NSArray *sortedLocations = [wklList sortedArrayUsingComparator: ^(id a1, id a2) {
        NSString *name1 = [a1 isKindOfClass:Location.class] ? ((Location *)a1).name : [((GMSAutocompletePrediction *)a1).attributedFullText string];
        NSString *name2 = [a2 isKindOfClass:Location.class] ? ((Location *)a2).name : [((GMSAutocompletePrediction *)a2).attributedFullText string];
        return [name1 compare:name2];
    }];
    self.locationsTableView.backgroundColor = self.view.backgroundColor;
    UIFont *lightFont = [UIFont fontWithName:@"Avenir-Light" size:16.0];
    UIFont *heavyFont = [UIFont fontWithName:@"Avenir-Black" size:16.0];
    
    self.wellKnownLocationsDataSource = [[TGRArrayDataSource alloc] initWithItems:sortedLocations cellReuseIdentifier:@"locationCell" configureCellBlock:^(UITableViewCell *cell, NSObject *item) {
        cell.contentView.backgroundColor = self.view.backgroundColor;
        UIImageView *imageView = [cell.contentView viewWithTag:1];
        imageView.image = [UIImage imageNamed:@"pin-black"];
        UILabel *label = [cell.contentView viewWithTag:2];
        label.font = lightFont;
        if ([item isKindOfClass:Location.class]) {
            Location *locItem = (Location *)item;
            if ([locItem.name rangeOfString:@"Airport"].location != NSNotFound) {
                imageView.image = [UIImage imageNamed:@"pin-black"];
            } else if(locItem.identifier == -1) {
                imageView.image = [UIImage imageNamed:@"CurrLocation"];
            }
            NSMutableAttributedString *attrLoc = [[NSMutableAttributedString alloc] initWithString:locItem.name attributes:@{NSFontAttributeName:lightFont}];
            [AppDelegate highlightAttrTextCore:attrLoc term:filter withBackground:nil withBlack:NO andFont:heavyFont];
            label.attributedText = [attrLoc copy];
        } else {
            GMSAutocompletePrediction *prediction = (GMSAutocompletePrediction *)item;
            NSMutableAttributedString *attrLoc = [[NSMutableAttributedString alloc] initWithAttributedString:prediction.attributedFullText];
            [attrLoc addAttribute:NSFontAttributeName value:lightFont range:NSMakeRange(0, attrLoc.length)];
            [AppDelegate highlightGoogleText:attrLoc withBackground:nil withBlack:NO andFont:heavyFont];
            label.attributedText = [attrLoc copy];
        }

    }];
    self.locationsTableView.dataSource = self.wellKnownLocationsDataSource;
    self.locationsTableView.delegate = self;
    
    [self.locationsTableView reloadData];
}

#pragma mark - GMSAutocompleteFetcherDelegate
- (void)didAutocompleteWithPredictions:(NSArray *)predictions {
    for (GMSAutocompletePrediction *prediction in predictions) {
        NSLog(@"%@\n", [prediction.attributedFullText string]);
    }
    [self loadLocations:_toLocationTextField.text andPredictions:predictions];
}

- (void)didFailAutocompleteWithError:(NSError *)error {
    NSLog(@"Predictions error: %@", error.localizedDescription);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.locationsTableView) {
        Location *loc = self.wellKnownLocationsDataSource.items[indexPath.row];
        [self.delegate didSelectLocation:loc.identifier withValue:loc andText:loc.name];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    TGRArrayDataSource *dataSource = (TGRArrayDataSource *)self.locationsTableView.dataSource;
    NSArray<Location*> *locations = dataSource.items;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",textField.text];
    if ([locations filteredArrayUsingPredicate:predicate].count > 0) {
        Location *selectedLocation = [[locations filteredArrayUsingPredicate:predicate] objectAtIndex:0];
        [self.delegate didSelectLocation:selectedLocation.identifier withValue:selectedLocation andText:selectedLocation.name];
    }
}
- (IBAction)backButton_Click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
