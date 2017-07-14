//
//  AppDelegate.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 6/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "AppDelegate.h"
#import "HockeySDK/HockeySDK.h"
#import <TCBlobDownload/TCBlobDownload.h>
#import "CarkyApiClient.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <Stripe/Stripe.h>
#import <GooglePlaces/GooglePlaces.h>
#import "PayPalMobile.h"
#import "ViewControllers/InitViewController.h"
@import AVFoundation;
@import AVKit;
@import  HockeySDK;
@import MapKit;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)loadInitialControllerForMode:(NSInteger)mode {
    NSArray *scrData = self.screensData[mode];
    [self loadInitialController:scrData[1] FromStoryboard:scrData[0]];
}

- (void)loadInitialController:(NSString *)controllerIdentifier FromStoryboard:(NSString *)storyboardName {

    UIViewController *viewController = nil;
    if (!self.viewControllersDict[storyboardName]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        viewController = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
        // todo: investigate caching view controller
        //self.viewControllersDict[storyboardName] = viewController;
    } else {
        viewController = self.viewControllersDict[storyboardName];
        if ([viewController conformsToProtocol:@protocol(InitViewController)]) {
            id<InitViewController> initVc = (id<InitViewController>)viewController;
            [initVc initControls];
        }
    }
    if(!self.loaded) {
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        self.window.rootViewController = viewController;
        //self.loaded = YES;
    }
    else {
        return;
    }
    if(!self.mHud) {
        // Should be initialized with the windows frame so the HUD disables all user input by covering the entire screen
        self.mHud = [[MBProgressHUD alloc] initWithView:viewController.view];
        self.mHud.removeFromSuperViewOnHide = YES;
        _mHud.bezelView.color = [UIColor blackColor];
        _mHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _mHud.contentColor = [UIColor whiteColor];
        _mHud.tintColor = [UIColor whiteColor];
        [CarkyApiClient sharedService].hud = self.mHud;
    }
    [self.window makeKeyAndVisible];
    [self checkDownloadVideoInView:viewController.view];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.loaded = NO;
    self.screensData =@[@[], @[@"Main",@"home"],@[@"TransferLanding",@"home"],@[@"Landing",@"home"],@[@"TransferLanding",@"home"]]; // 4 is transfer with cash (reception)
    self.viewControllersDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [[NSUserDefaults standardUserDefaults] registerDefaults: @{@"username_preference":@"phisakel2@gmail.com"}];
    [[NSUserDefaults standardUserDefaults] registerDefaults: @{@"password_preference":@"12345678"}];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"enabled_preference": @(YES)}];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"hotel_prefilled": @(NO)}];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"environment_preference": @(0)}];
    // Override point for customization after application launch.
    NSBundle *main = [NSBundle mainBundle];
    
    NSString *googleApiKey = [main objectForInfoDictionaryKey:@"GoogleApiKey"];
    [GMSServices provideAPIKey:googleApiKey];
    [GMSPlacesClient provideAPIKey:googleApiKey];
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"a129e5fddb2541efb97119cbc33e389a"];
    // Do some additional configuration if needed here
    [BITHockeyManager sharedHockeyManager].disableUpdateManager = YES;
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];

    [[NSUserDefaults standardUserDefaults] setValue:@"English" forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
    //self.api.hud = [MBProgressHUD HUDForView:self.view];
    self.api.hud.label.text = NSLocalizedString(@"Fetching data...", nil);
    [self.api.hud showAnimated:YES];
    //todo: set login username
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username_preference"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password_preference"];
    BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_preference"];
    self.hotelPrefilled = NO; //[[NSUserDefaults standardUserDefaults] boolForKey:@"hotel_prefilled"];
    if ([userName containsString:@"phisakel"] && [userName containsString:@"@gmail.com"]) {
        self.environment = [[NSUserDefaults standardUserDefaults] integerForKey:@"environment_preference"];
    } else {
        self.environment = CarkyBackendTypeLive;
    }
    //init api client
    self.api = [CarkyApiClient sharedService];
    if (!enabled) {
        return;
    }
    [self.api loginWithUsername:userName andPassword:password withTokenBlock:^(BOOL result) {
        [self refreshClientConfiguration:block];
    }];
}

-(void)refreshClientConfiguration:(BlockBoolean)block {
    [self.api GetClientConfiguration:^(NSArray *array) {
        if (array.count > 0) {
            ClientConfigurationResponse *clientConf = array.firstObject;
            AppDelegate *app = [AppDelegate instance];
            BOOL isInitial = (app.clientConfiguration == nil);
            
            // debug only SOS
            //app.clientConfiguration.location.latLng.lat = 37.421932;
            //app.clientConfiguration.location.latLng.lng = 25.396646;
            CarkyApiClient *api = [CarkyApiClient sharedService];
            // paypal configuration
            if (isInitial || clientConf.payPalMode != app.clientConfiguration.payPalMode || clientConf.areaOfServiceId != app.clientConfiguration.areaOfServiceId) {
                if ([clientConf.payPalMode caseInsensitiveCompare:@"sandbox"] == NSOrderedSame) {
                    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox : clientConf.payPalClientId}];
                } else {
                    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : clientConf.payPalClientId}];
                }
                [api GetStripePublishableApiKey:^(NSString *str) {
                    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey: [str substringWithRange:NSMakeRange(1, str.length-2)]];
                    [api GetTransferServicePartnerAvailableCars:clientConf.areaOfServiceId withBlock:^(NSArray *array) {
                        self.carCategories = array;
                    }];
                    [api GetWellKnownLocations:clientConf.areaOfServiceId withBlock:^(NSArray<Location *> *array) {
                        self.wellKnownLocations = array;
                        self.locationBounds = [AppDelegate findCoordBounds:self.wellKnownLocations];
                    }];
                }];
            }
            BOOL bNeedReload = isInitial || NO == [app.clientConfiguration.description isEqualToString:clientConf.description];
            app.clientConfiguration = clientConf;
            if (bNeedReload) {
                [self loadInitialControllerForMode:app.clientConfiguration.tabletMode];
                if(block)
                { block(YES); }
            }
        }
    }];
}

// used in rental
-(void)fetchCarsDataForType:(NSInteger)carTypeId andPickupDate:(NSDate *)pickupDate andDropoffDate:(NSDate *)dropoffDate andBlock:(BlockArray)block{
    [self.api GetCarExtrasForRental:pickupDate andDropoffDate:dropoffDate withBlock:^(NSArray *array3) {
        if ([array3.firstObject isKindOfClass:CarExtra.class]) {
            self.carExtras = array3;
        }
        [self.api GetAllCarInsurancesForType:carTypeId andPickupDate:pickupDate andDropoffDate:dropoffDate withBlock:^(NSArray *array4) {
            if ([array4.firstObject isKindOfClass:CarInsurance.class]) {
                self.carInsurances = array4;
            }
            block(array4);
        }];
    }];
}

-(AVQueuePlayer *)loadTransferVideoPlayer {
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource: @"SearchingForDrivers_Mykonos" withExtension:@"mp4"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (self.confirmationVideoLocalPath && [fm fileExistsAtPath:self.confirmationVideoLocalPath]) {
        videoURL = [NSURL fileURLWithPath:self.confirmationVideoLocalPath];
    }
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    AVPlayerItem *avPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
    AVQueuePlayer *queuePlayer = [AVQueuePlayer playerWithPlayerItem:avPlayerItem];
    return queuePlayer;
}

-(void)checkDownloadVideoInView:(UIView *)view {
    AppDelegate *app = self;
    if (app.clientConfiguration.confirmationVideo) {
        TCBlobDownloadManager *sharedManager = [TCBlobDownloadManager sharedInstance];
        NSURL *url = [NSURL URLWithString:app.clientConfiguration.confirmationVideo];
        NSString *fileName = [[NSURL URLWithString:[url absoluteString]] lastPathComponent];
        NSString *filePath = [sharedManager.defaultDownloadPath stringByAppendingPathComponent:fileName];
        app.confirmationVideoLocalPath = filePath;
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:filePath]) {
            [app startDownloadVideoInView:view];
        }
        else {
            NSURL *movieURL = [NSURL fileURLWithPath:filePath];
            AVURLAsset *avUrl = [AVURLAsset assetWithURL:movieURL];
            CMTime time1 = [avUrl duration];
            if (time1.value == 0) {
                [app startDownloadVideoInView:view];
            }
        }
    }
}

-(void)startDownloadVideoInView:(UIView *)view {
    AppDelegate *app = self;
    NSFileManager *fm = [NSFileManager defaultManager];
    TCBlobDownloadManager *sharedManager = [TCBlobDownloadManager sharedInstance];
    NSURL *urlVideo = [NSURL URLWithString:app.clientConfiguration.confirmationVideo];
    [sharedManager startDownloadWithURL:urlVideo customPath:nil firstResponse:^(NSURLResponse *response) {
        [app showProgressNotificationWithText:nil inView:view];
    } progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress) {
        NSString *strFmt = [NSString stringWithFormat: @"Downloading %.0f%%...",progress * 100];
        app.mHud.label.text = strFmt;
        [app.mHud.label sizeToFit];
    } error:^(NSError *error) {
        if([fm fileExistsAtPath:app.confirmationVideoLocalPath])
            [fm removeItemAtPath:app.confirmationVideoLocalPath error:nil];
        [app hideProgressNotification];
    } complete:^(BOOL downloadFinished, NSString *pathToFile) {
        [app hideProgressNotification];
    }];
}

// ------------ utility functions here ---------------------------
+(NSDate *)dateOnlyPart:(NSDate *)dt {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *theDate = [dateFormat stringFromDate:dt];
    NSDate *result = [dateFormat dateFromString:theDate];
    return result;
}

+ (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

+ (BOOL)day:(NSDateComponents*)day1 isEqual:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedSame);
}

+(GMSCoordinateBounds *)findCoordBounds:(NSArray<Location *> *) array {
    GMSCoordinateBounds *bounds;
    CLLocationCoordinate2D neBoundsCorner,swBoundsCorner;
    Location *l0 = array[0];
    //Longitude is a geographic coordinate that specifies the east-west
    __block CLLocationDegrees north=l0.latLng.lat, east=l0.latLng.lng, south=l0.latLng.lat, west=l0.latLng.lng;
    [array enumerateObjectsUsingBlock:^(Location * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.latLng.lng > west)  west = obj.latLng.lng;
        if (obj.latLng.lng < east)  east = obj.latLng.lng;
        if (obj.latLng.lat > north)  north = obj.latLng.lat;
        if (obj.latLng.lat < south)  south = obj.latLng.lat;
    }];
    neBoundsCorner = CLLocationCoordinate2DMake(north, east);
    swBoundsCorner = CLLocationCoordinate2DMake(south, west);
    bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:neBoundsCorner coordinate:swBoundsCorner];
    return bounds;
}

+(CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location {
    double latitude = [[location objectForKey:@"lat"] doubleValue];
    double longitude = [[location objectForKey:@"lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

-(MBProgressHUD *)showProgressNotificationWithText:(NSString *)text inView:(UIView *)view{
    _mHud.mode = MBProgressHUDModeIndeterminate;
    _mHud.label.text = text != nil ? text : NSLocalizedString(@"Please wait...", nil);
    [view addSubview:_mHud];
    [_mHud showAnimated:YES];
    return _mHud;
}

-(void)hideProgressNotification {
    [_mHud hideAnimated:YES];
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

+(NSArray *)mapObjectsFromArray:(NSArray *)array withBlock:(id (^)(id obj, NSUInteger idx))block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[array count]];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:block(obj, idx)];
    }];
    return result;
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

+(void)getEtaFrom:(LatLng *)p1 to:(LatLng *)p2 andBlock:(BlockArray)travel {
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(p1.lat, p1.lng) addressDictionary:nil];
    MKMapItem *mapItem1 = [[MKMapItem alloc] initWithPlacemark:placemark1];
    [mapItem1 setName:@"Name From"];
    [request setSource:mapItem1];
    MKPlacemark *placemark2 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(p2.lat, p2.lng) addressDictionary:nil];
    MKMapItem *mapItem2 = [[MKMapItem alloc] initWithPlacemark:placemark2];
    [mapItem2 setName:@"Name To"];
    [request setDestination:mapItem2];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    [request setRequestsAlternateRoutes:NO];
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (!error && [response routes] > 0) {
            MKRoute *route = [[response routes] objectAtIndex:0];
            travel(@[route]);
            //route.distance  = The distance
            //route.expectedTravelTime = The ETA
        } 
    }];
}


@end
