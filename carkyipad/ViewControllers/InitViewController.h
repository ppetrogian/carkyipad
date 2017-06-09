//
//  InitViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 9/6/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InitViewController <NSObject>
-(void)initControls;
@optional
-(void)deinitControls;
@end
