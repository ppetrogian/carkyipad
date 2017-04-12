//
//  WellKnownTableViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 12/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "WellKnownLocationsViewController.h"
#import "AppDelegate.h"
#import "TGRArrayDataSource.h"

@interface WellKnownLocationsViewController () <UITableViewDelegate, WellKnownLocationDelegate>
@property (nonatomic,strong) TGRArrayDataSource* wellKnownLocationsDataSource;

@end

@implementation WellKnownLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //self.locationsTableView.frame = self.view.bounds;
    [self.locationsTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Location *loc = self.wellKnownLocationsDataSource.items[indexPath.row];
    [self.delegate didSelectLocation:loc.identifier withValue:loc andText:loc.name];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
