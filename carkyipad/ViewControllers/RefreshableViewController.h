//
//  RefreshableViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 03/06/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RefreshableViewController <NSObject>
-(void)setNeedRefresh:(BOOL)value;
@end
