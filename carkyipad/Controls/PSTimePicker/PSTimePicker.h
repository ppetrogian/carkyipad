//
//  PSTimePicker.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 26/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
//IB_DESIGNABLE
@interface PSTimePicker : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>
@property(retain, nonatomic) NSMutableArray *hoursArray;
@property(retain, nonatomic) NSMutableArray *minsArray;
@property (nonatomic) NSInteger interval;
@end
