//
//  PSTimePicker.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 26/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "PSTimePicker.h"

@implementation PSTimePicker

//Method to define how many columns/dials to show
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0.0, 50.0, 50.0)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont boldSystemFontOfSize:22.0]];

    label.text = component == 0 ? self.hoursArray[row] : self.minsArray[row];
    return label;    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *labelSelected = (UILabel*)[pickerView viewForRow:row forComponent:component];
    //labelSelected.backgroundColor = self.tintColor;
    //labelSelected.superview.backgroundColor = self.tintColor;
}

// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component
{
    if (component==0)  {
        return self.hoursArray.count;
    }
    else {
        return self.minsArray.count;
    }
}

// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return [self.hoursArray objectAtIndex:row];
            break;
        case 1:
            return [self.minsArray objectAtIndex:row];
            break;
    }
    return nil;
}


-(IBAction)calculateTimeFromPicker
{
    
    NSString *hoursStr = [NSString stringWithFormat:@"%@",[self.hoursArray objectAtIndex:[self selectedRowInComponent:0]]];
    NSString *minsStr = [NSString stringWithFormat:@"%@",[self.minsArray objectAtIndex:[self selectedRowInComponent:1]]];
    
    NSInteger hoursInt = [hoursStr intValue];
    NSInteger minsInt = [minsStr intValue];
    NSInteger secsInt = 0;
    
    self.interval = secsInt + (minsInt*60) + (hoursInt*3600);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (!self.hoursArray) {
        self.dataSource = self;
        self.delegate = self;
        //initialize arrays
        self.hoursArray = [[NSMutableArray alloc] init];
        self.minsArray = [[NSMutableArray alloc] init];
        NSString *strVal = [[NSString alloc] init];
        for(int i=0; i<60; i+=5)
        {
            strVal = [NSString stringWithFormat:@"%d", i];
            if (strVal.length == 1) {
                strVal = [NSString stringWithFormat:@"0%d", i];
            }
            [self.minsArray addObject:strVal];
        }
        for(int i=0; i<24; i++)
        {
            strVal = [NSString stringWithFormat:@"%d", i];
            if (strVal.length == 1) {
                strVal = [NSString stringWithFormat:@"0%d", i];
            }
            [self.hoursArray addObject:strVal];
        }
        [self selectRow:0 inComponent:0 animated:NO];
        self.subviews[0].subviews[0].subviews[2].backgroundColor = self.tintColor;
    }
}


@end
