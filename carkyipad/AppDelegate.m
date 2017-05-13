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
#import <Stripe/Stripe.h>
#import <GooglePlaces/GooglePlaces.h>
#import "PayPalMobile.h"

@import  HockeySDK;

@interface AppDelegate ()
@property (nonatomic,strong) NSArray *screensData;
@end

@implementation AppDelegate

- (void)loadInitialControllerForMode:(NSInteger)mode {
    NSArray *scrData = self.screensData[mode];
    [self loadInitialController:scrData[1] FromStoryboard:scrData[0]];
}

- (void)loadInitialController:(NSString *)controllerIdentifier FromStoryboard:(NSString *)storyboardName {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.screensData =@[@[], @[@"Main",@"home"],@[@"Transfer",@"transferSteps"],@[@"Landing",@"Landing"],@[@"CarRental",@"CarRentalSteps"]];
    [[NSUserDefaults standardUserDefaults] registerDefaults: @{@"username_preference":@"phisakel@gmail.com"}];
    [[NSUserDefaults standardUserDefaults] registerDefaults: @{@"password_preference":@"12345678"}];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"enabled_preference": @(YES)}];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"demo_preference": @(YES)}];
    // Override point for customization after application launch.
    NSBundle *main = [NSBundle mainBundle];
    //NSString *stripeApiKey = [main objectForInfoDictionaryKey:@"StripeApiKey"];
    //[[STPPaymentConfiguration sharedConfiguration] setPublishableKey: stripeApiKey];
    
    NSString *googleApiKey = [main objectForInfoDictionaryKey:@"GoogleApiKey"];
    [GMSServices provideAPIKey:googleApiKey];
    [GMSPlacesClient provideAPIKey:googleApiKey];
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"bafb4bfd3a514cdbb91b676e8a384daa"];
    // Do some additional configuration if needed here
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];

    [[NSUserDefaults standardUserDefaults] setValue:@"English" forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //PayPalEnvironmentProduction : @"YOUR_CLIENT_ID_FOR_PRODUCTION",
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox : @"AXQpJ2wZii3nT3iJhO2OCFUEv_7zRk9SkO6PgGeR3lUegEOetVeBkanC1bqEWi9EggNe2NQwtEg1pVOs"}];
    [self fetchInitialData:nil];
    
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

// app methods to load data
-(void)fetchInitialData:(BlockBoolean)block {
    //fetch initial data
    self.api = [CarkyApiClient sharedService];
    //self.api.hud = [MBProgressHUD HUDForView:self.view];
    self.api.hud.label.text = NSLocalizedString(@"Fetching data...", nil);
    [self.api.hud showAnimated:YES];
    //todo: set login username
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username_preference"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password_preference"];
    BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_preference"];
    [AppDelegate instance].isDemo = [[NSUserDefaults standardUserDefaults] boolForKey:@"demo_preference"];
    if (!enabled) {
        return;
    }
    
    [self.api loginWithUsername:userName andPassword:password withTokenBlock:^(BOOL result) {
        [self.api GetClientConfiguration:^(NSArray *array) {
            if (array.count > 0) {
                AppDelegate *app = [AppDelegate instance];
                app.clientConfiguration = array.firstObject;
                [self loadInitialControllerForMode:app.clientConfiguration.tabletMode];
                if(block)
                { block(YES); }
            }
        }];
    }];
}

-(void)fetchCarsData:(BlockBoolean)block {
    AppDelegate *app = [AppDelegate instance];
    [self.api GetAllCarTypes:^(NSArray *array2) {
        app.carTypes = array2;
    }];
    [self.api GetCarExtras:^(NSArray *array3) {
        app.carExtras = array3;
    }];
    [self.api GetAllCarInsurances:^(NSArray *array4) {
        app.carInsurances = array4;
    }];
    block(YES);
}


// ------------ utility functions here ---------------------------

+(CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location {
    double latitude = [[location objectForKey:@"lat"] doubleValue];
    double longitude = [[location objectForKey:@"lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

+(MBProgressHUD *)showProgressNotification:(UIView *)view withText:(NSString *)text {
    MBProgressHUD *loadingNotification = [MBProgressHUD HUDForView:view];
    loadingNotification.mode = MBProgressHUDModeIndeterminate;
    loadingNotification.label.text = text != nil ? text : @"Please wait...";
    [loadingNotification showAnimated:YES];
    return loadingNotification;
}

+(void)hideProgressNotification:(MBProgressHUD *)hud {
    [hud hideAnimated:YES];
}

+(void)configurePSTextField:(UITextField *)tf withColor:(UIColor *)color {
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    tf.borderStyle = UITextBorderStyleNone;
    CGRect rect = tf.frame;
    border.borderColor = color.CGColor; // [UIColor groupTableViewBackgroundColor].CGColor;
    border.frame = CGRectMake(0, rect.size.height - borderWidth, rect.size.width, rect.size.height);
    border.borderWidth = borderWidth;
    [tf.layer addSublayer:border];
    tf.layer.masksToBounds = YES;
}

+(GMSPolyline *)showRouteInMap:(GMSMapView *)mapView withResults:(NSDictionary *)results forMarker:(GMSMarker *)targetMarker  {
    NSArray *routes = [results objectForKey:@"routes"];
    if(routes.count == 0) {
        return nil;
    }
    GMSMutablePath *path = [GMSMutablePath path];
    NSDictionary *firstRoute = [routes objectAtIndex:0];
    NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
    
    NSMutableArray * legRouteArray=[routes valueForKey:@"legs"];
//    NSMutableString *startLocationLat=[[[legRouteArray valueForKeyPath:@"start_location.lat"] objectAtIndex:0] objectAtIndex:0];
//    NSMutableString *startLocationLong=[[[legRouteArray valueForKeyPath:@"start_location.lng"]objectAtIndex:0] objectAtIndex:0];
    //NSMutableString *endLocationLat=[[[legRouteArray valueForKeyPath:@"end_location.lat"] objectAtIndex:0] objectAtIndex:0];
    //NSMutableString *endLocationLong=[[[legRouteArray valueForKeyPath:@"end_location.lng"]objectAtIndex:0] objectAtIndex:0];
    
    NSLog(@"duration %@",[[[legRouteArray objectAtIndex:0]valueForKey:@"duration"]valueForKey:@"text"]);
    NSArray *steps = [leg objectForKey:@"steps"];
    NSLog(@"end address: %@", [leg objectForKey:@"end_address"]);
    int stepIndex = 0;
    CLLocationCoordinate2D stepCoordinates[1  + [steps count] + 1];
    
    for (NSDictionary *step in steps) {
        
        NSDictionary *start_location = [step objectForKey:@"start_location"];
        stepCoordinates[++stepIndex] = [AppDelegate coordinateWithLocation:start_location];
        [path addCoordinate:[AppDelegate coordinateWithLocation:start_location]];
        
        NSString *polyLinePoints = [[step objectForKey:@"polyline"] objectForKey:@"points"];
        GMSPath *polyLinePath = [GMSPath pathFromEncodedPath:polyLinePoints];
        for (int p=0; p<polyLinePath.count; p++) {
            [path addCoordinate:[polyLinePath coordinateAtIndex:p]];
        }
        
        if ([steps count] == stepIndex){
            NSDictionary *end_location = [step objectForKey:@"end_location"];
            stepCoordinates[++stepIndex] = [AppDelegate coordinateWithLocation:end_location];
            [path addCoordinate:[AppDelegate coordinateWithLocation:end_location]];
        }
    }
    
    GMSPolyline *polyline = nil;
    polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blackColor]; //     [UIColor colorWithRed:0.2 green:0.2 blue:1 alpha:1];
    polyline.strokeWidth = 3.f;
    polyline.map = mapView;
    //show image for starting point and destination point
    if(targetMarker != nil)
    {
        NSArray *locationArray=[[[legRouteArray objectAtIndex:0]valueForKey:@"duration"]valueForKey:@"text"];
        targetMarker.title = [NSString stringWithFormat:@"%@",[locationArray objectAtIndex:0]];
        targetMarker.map = mapView;
        mapView.selectedMarker = targetMarker;
    }
    return  polyline;
}

+(void)highlightAttrTextCore:(NSMutableAttributedString *)attrTxt term:(NSString *)term withBackground:(UIColor *)backColor withBlack:(BOOL)bBlack andFont:(UIFont *)font  {
    if (term.length == 0) {
        return;
    }
    NSString *text = attrTxt.string;
    NSUInteger textLen = attrTxt.length;
    NSUInteger termLen = term.length;
    int idx = 0;
    
    while (textLen >= termLen && idx < (textLen - termLen)) {
        NSRange srcRange = NSMakeRange(idx, termLen);
        NSComparisonResult result = [[text substringWithRange:srcRange] compare:term options:NSRegularExpressionSearch | NSCaseInsensitiveSearch];
        if (result == NSOrderedSame) {
            if(backColor)
                [attrTxt addAttribute:NSBackgroundColorAttributeName value:backColor range:srcRange];
            if (bBlack)
                [attrTxt addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:srcRange];
            if(font)
                [attrTxt addAttribute:NSFontAttributeName value:font range:srcRange];
            idx += termLen;
        } else {
            idx++;
        }
    }
}

+(void)highlightGoogleText:(NSMutableAttributedString *)attrText  withBackground:(UIColor *)backColor withBlack:(BOOL)bBlack andFont:(UIFont *)font {
   [attrText enumerateAttribute:kGMSAutocompleteMatchAttribute inRange:NSMakeRange(0, attrText.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
       if (value) {
           if(backColor)
           [attrText addAttribute:NSBackgroundColorAttributeName value:backColor range:range];
           if (bBlack)
           [attrText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
           if(font)
           [attrText addAttribute:NSFontAttributeName value:font range:range];
       }
   }];
}

+(UITableView *)parentTableView:(UIView *)view {
    // iterate up the view hierarchy to find the table containing this cell/view
    UIView *aView = view.superview;
    while(aView != nil) {
        if([aView isKindOfClass:[UITableView class]]) {
            return (UITableView *)aView;
        }
        aView = aView.superview;
    }
    return nil; // this view is not within a tableView
}

+(UITableViewCell *)parentTableViewCell:(UIView *)view {
    // iterate up the view hierarchy to find the table containing this cell/view
    UIView *aView = view.superview;
    while(aView != nil) {
        if([aView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)aView;
        }
        aView = aView.superview;
    }
    return nil; // this view is not within a tableView
}

+(UICollectionView *)parentCollectionView:(UIView *)view {
    // iterate up the view hierarchy to find the table containing this cell/view
    UIView *aView = view.superview;
    while(aView != nil) {
        if([aView isKindOfClass:[UICollectionView class]]) {
            return (UICollectionView *)aView;
        }
        aView = aView.superview;
    }
    return nil; // this view is not within a collection view
}

+(UICollectionViewCell *)parentCollectionViewCell:(UIView *)view {
    // iterate up the view hierarchy to find the table containing this cell/view
    UIView *aView = view.superview;
    while(aView != nil) {
        if([aView isKindOfClass:[UICollectionViewCell class]]) {
            return (UICollectionViewCell *)aView;
        }
        aView = aView.superview;
    }
    return nil; // this view is not within a collection view
}

+(void)addDropShadow:(UIView *)view forUp:(BOOL)up {
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, up ? -4 : 4);
    view.layer.shadowRadius = 4;
    view.layer.shadowOpacity = 1.0;
    view.layer.masksToBounds = NO;
}

+(UIImage *)imageToGreyImage:(UIImage *)image {
    // Create image rectangle with current image width/height
    CGFloat actualWidth = image.size.width;
    CGFloat actualHeight = image.size.height;
    
    CGRect imageRect = CGRectMake(0, 0, actualWidth, actualHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate(nil, actualWidth, actualHeight, 8, 0, colorSpace, kCGImageAlphaNone);
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    CGImageRef grayImage = CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    context = CGBitmapContextCreate(nil, actualWidth, actualHeight, 8, 0, nil, kCGImageAlphaOnly);
    CGContextDrawImage(context, imageRect, [image CGImage]);
    CGImageRef mask = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *grayScaleImage = [UIImage imageWithCGImage:CGImageCreateWithMask(grayImage, mask) scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(grayImage);
    CGImageRelease(mask);
    
    // Return the new grayscale image
    return grayScaleImage;
}

+(NSString *)urlencode:(NSString *)str {
    if (!str) {
        return nil;
    }
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[str UTF8String];
    NSUInteger sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}


@end
