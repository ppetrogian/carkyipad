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

@interface SelectDropoffLocationViewController () <UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic,strong) TGRArrayDataSource* wellKnownLocationsDataSource;
@end

@implementation SelectDropoffLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadLocations:nil];
    self.fromLocationTextField.text = self.currentLocation.name;

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
    [self loadLocations:textField.text];
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

@end
