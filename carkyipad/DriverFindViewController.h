//
//  DriverFindViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 13/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DriverFindFromCarCategoryDelegate <NSObject>
@optional
- (void) didSelectCarCategory:(NSInteger)identifier withValue:(id)value andText:(NSString *)text;
@end

@interface DriverFindViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *carCategoriesTableView;
-(void)loadCarCategories;
@property (weak,nonatomic) id<DriverFindFromCarCategoryDelegate> delegate;
// methods

@end
