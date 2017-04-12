//
//  AppDelegate.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 6/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "AppDelegate.h"
#import "HockeySDK/HockeySDK.h"
#import "CarkyApiClient.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"17b2f6849c3d402d85f37c7761481c97"];
    // Do some additional configuration if needed here
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];

    [GMSServices provideAPIKey:@"AIzaSyAwAfvg1TIir4cwG3AtN2aJl3yPNAdaxGU"];
    [[NSUserDefaults standardUserDefaults] setValue:@"English" forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

+(AppDelegate *)instance {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// app methods
-(void)fetchInitialData:(BlockBoolean)block {
    //fetch initial data
    self.api = [CarkyApiClient sharedService];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //self.api.hud = [MBProgressHUD HUDForView:self.view];
    self.api.hud.label.text = NSLocalizedString(@"Fetching data...", nil);
    [self.api.hud showAnimated:YES];
    //todo: set login username
    [self.api loginWithUsername:@"phisakel@gmail.com" andPassword:@"12345678" withTokenBlock:^(BOOL result) {
        
    }];
    [self.api GetAllCarTypes:^(NSArray *array2) {
        app.carTypes = array2;
    }];
    [self.api GetCarExtras:^(NSArray *array3) {
        app.carExtras = array3;
    }];
    [self.api GetAllCarInsurances:^(NSArray *array4) {
        app.carInsurances = array4;
    }];
    // pyramid of doom, todo: make parallel
    [self.api GetFleetLocationsFull:^(NSArray *array1) {
        app.fleetLocations = array1;
        app.availableCarsDict = [NSMutableDictionary dictionaryWithCapacity:array1.count];
        [array1 enumerateObjectsUsingBlock:^(FleetLocations *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.api GetAvailableCars:obj.identifier withBlock:^(NSArray *arrayCars) {
                [app.availableCarsDict setObject:arrayCars forKey:@(obj.identifier)];
                if (idx == array1.count-1) {
                    block(YES);
                }
            }];
        }];
    }];    
}

// helper methods

+(CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location {
    double latitude = [[location objectForKey:@"lat"] doubleValue];
    double longitude = [[location objectForKey:@"lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

+(MBProgressHUD *)showProgressNotification:(UIView *)view {
    MBProgressHUD *loadingNotification = [MBProgressHUD HUDForView:view];
    loadingNotification.mode = MBProgressHUDModeIndeterminate;
    loadingNotification.label.text = @"Please wait...";
    [loadingNotification showAnimated:YES];
    return loadingNotification;
}

+(void)hideProgressNotification:(MBProgressHUD *)hud {
    [hud hideAnimated:YES];
}


@end
