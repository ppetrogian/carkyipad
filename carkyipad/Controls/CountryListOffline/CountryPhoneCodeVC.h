//
//  CountryPhoneCodeVC.h
//  DoubleUniq
//
//  Created by Pravin Mahajan on 21/10/16.
//  Copyright © 2016 ETPL. All rights reserved.
//

#import "BaseViewController.h"

@protocol SelectDelegate <NSObject>

- (void)didSelect:(BOOL)hasSelected;

@end

@interface CountryPhoneCodeVC : BaseViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, weak) id<SelectDelegate> delegate;
@end
