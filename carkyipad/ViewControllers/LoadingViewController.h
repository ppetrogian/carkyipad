//
//  LoadingViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 21/5/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface LoadingViewController : UIViewController
@property (weak, nonatomic) IBOutlet MBProgressHUD *hud;

@end
