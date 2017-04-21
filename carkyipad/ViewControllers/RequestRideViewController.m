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

@interface RequestRideViewController () <UITableViewDelegate, UICollectionViewDelegate>
@property (nonatomic,strong) TGRArrayDataSource* carCategoriesDataSource;

@end

@implementation RequestRideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadCarCategories];
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

-(void)loadCarCategories {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    CarCategory *cc;
    cc = [CarCategory modelObjectWithDictionary:@{kCarCategoryId:@(1), kCarCategoryDescription:@"STANDARD", kCarCategoryPrice:@(50), kCarCategoryImage:@"audi", kCarCategoryMaxPassengers:@(4),kCarCategoryMaxLaggages:@(3)}];
    [temp addObject:cc];
    cc = [CarCategory modelObjectWithDictionary:@{kCarCategoryId:@(2), kCarCategoryDescription:@"LUXURY SUV", kCarCategoryPrice:@(30), kCarCategoryImage:@"range rover", kCarCategoryMaxPassengers:@(4),kCarCategoryMaxLaggages:@(4)}];
    [temp addObject:cc];
    cc = [CarCategory modelObjectWithDictionary:@{kCarCategoryId:@(3), kCarCategoryDescription:@"VAN", kCarCategoryPrice:@(80), kCarCategoryImage:@"vito", kCarCategoryMaxPassengers:@(8),kCarCategoryMaxLaggages:@(8)}];
    [temp addObject:cc];
    self.carCategoriesDataSource = [[TGRArrayDataSource alloc] initWithItems:[temp copy] cellReuseIdentifier:@"carCategoryCell" configureCellBlock:^(UICollectionViewCell *cell, CarCategory *item) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *nameLabel = [cell.contentView viewWithTag:1];
        nameLabel.text = item.Description;
        UILabel *passLabel = [cell.contentView viewWithTag:2];
        passLabel.text = [NSString stringWithFormat:@"%ld",(long)item.maxPassengers];
        UILabel *laggLabel = [cell.contentView viewWithTag:3];
        laggLabel.text = [NSString stringWithFormat:@"%ld",(long)item.maxLaggages];
        UILabel *numLabel = [cell.contentView viewWithTag:6];
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)0];
        UIImageView *ccImageView = [cell.contentView viewWithTag:4];
        ccImageView.image = [UIImage imageNamed:item.image];
        UILabel *priceLabel = [cell.contentView viewWithTag:8];
        priceLabel.text = [NSString stringWithFormat:@"€%ld",(long)item.price];
        UIButton *buttonMinus = [cell.contentView viewWithTag:5];
        [buttonMinus setTitleEdgeInsets:UIEdgeInsetsMake(-5.0f, 0.0f, 0.0f, 0.0f)];
        [buttonMinus addTarget:self action:@selector(addOrSubtractCar:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *buttonPlus = [cell.contentView viewWithTag:7];
        [buttonPlus setTitleEdgeInsets:UIEdgeInsetsMake(-5.0f, 0.0f, 0.0f, 0.0f)];
        [buttonPlus addTarget:self action:@selector(addOrSubtractCar:) forControlEvents:UIControlEventTouchUpInside];
    }];
    self.carCategoriesCollectionView.allowsSelection = YES;
    self.carCategoriesCollectionView.dataSource = self.carCategoriesDataSource;
    self.carCategoriesCollectionView.delegate = self;
    [self.carCategoriesCollectionView reloadData];
}

-(void)addOrSubtractCar:(UIButton *)sender {
    UIView *parentView = sender.superview;
    UILabel *numLabel = [parentView viewWithTag:6];
    NSInteger numberValue = numLabel.text.integerValue;
    NSInteger diff = sender.tag == 7 ? 1 : - 1;
    numberValue = numberValue + diff;
    UICollectionViewCell* cell = [AppDelegate parentCollectionViewCell:parentView];
    cell.selected = YES;
    //UICollectionView* cl = [AppDelegate parentCollectionView:cell];
    //NSIndexPath* pathOfTheCell = [table indexPathForCell:cell];
    if (numberValue >= 0) {
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)numberValue];
        UILabel *priceLabel = [parentView viewWithTag:8];
        NSInteger price = [priceLabel.text substringFromIndex:1].integerValue;
        self.totalPrice += (price * diff);
        NSInteger value = self.selectedCarType;
        self.selectedCarType = value + diff;
       // [self uiBindWithCard:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedCarType != indexPath.row) {
        self.selectedCarType = indexPath.row;
        self.totalPrice = 0;
    }
    
}
@end
