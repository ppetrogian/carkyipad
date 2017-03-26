//
//  DetailsStepViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 26/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "DetailsStepViewController.h"

@interface DetailsStepViewController ()


@end

@implementation DetailsStepViewController

-(UIView *)pickerViews{
    
    return ([self.timePicker.subviews objectAtIndex:0]);
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [[self pickerViews].subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        //NSLog(@"%@ --- > %i",obj, idx);
        if(idx == 0)
          view.backgroundColor = [UIColor blueColor];
    }];
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

@end
