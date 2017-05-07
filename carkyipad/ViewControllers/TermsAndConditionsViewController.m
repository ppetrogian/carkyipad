//
//  TermsAndConditionsViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 08/05/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "TermsAndConditionsViewController.h"

@interface TermsAndConditionsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *termsLabel;

@end

@implementation TermsAndConditionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.termsLabel.text = self.terms;
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
- (IBAction)IAgree_Click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
