//
//  BaseViewController.m
// Copyright Nessos

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Macros.h"
#import "Validation.h"
#import "Reachability.h"

#import "NBPhoneNumberUtil.h"

#import "GiFHUD.h"
@interface BaseViewController ()
{
    MBProgressHUD *HUD;
    Validation *valOb;
}
@end

@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)addNavigationBarAppImageWithWhiteColor{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carky_w"]];
    CGSize imageSize = CGSizeMake(80, 14);
    CGFloat marginX = (self.navigationController.navigationBar.frame.size.width / 2) - (imageSize.width / 2);
    imageView.frame = CGRectMake(marginX, 13, imageSize.width, imageSize.height);
    [self.navigationController.navigationBar addSubview:imageView];
}


-(void)rightBarButtonItemTapped{
    
    

}
-(void)addNavigationBarAppImage{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carky"]];
    CGSize imageSize = CGSizeMake(80, 14);
    CGFloat marginX = (self.navigationController.navigationBar.frame.size.width / 2) - (imageSize.width / 2);
    imageView.frame = CGRectMake(marginX, 13, imageSize.width, imageSize.height);
    [self.navigationController.navigationBar addSubview:imageView];
}
#pragma mark - Tabbar showTabbar hideTabbar

-(void)hideTabbar
{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)showTabbar
{
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark - Navigation Controller
-(UIColor *)setLightGreenColor{
    return [UIColor colorWithRed:33.0/255.0 green:206.0/255.0 blue:153.0/255.0 alpha:1.0];
}
-(UIColor *)setLightGrayColor{
return [UIColor colorWithRed:103.0/255.0 green:103.0/255.0 blue:102.0/255.0 alpha:0.5];
}
-(void)SetNavTitle:(NSString *)title{
    self.navigationController.title = title ;
}
-(void)hideNavBar{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
-(void)showNavBar{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}
-(void)setClearNavigationBarColor{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}



#pragma mark - Hide Keyboard
-(void)addGestureToView{
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    self.tap.enabled = NO;
    [self.view addGestureRecognizer:self.tap];
}
-(void)hideKeyboard{
    [self.view endEditing:YES];
    _tap.enabled = NO;
}
#pragma mark - UIRelated
-(void)underlineLable:(UILabel *)templbl :(NSString *)setUpStr{
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    templbl.attributedText = [[NSAttributedString alloc] initWithString:setUpStr
                                                             attributes:underlineAttribute];
}
-(void)setBorderColorToOutlet:(UIControl*)outlet setColor:(UIColor *)color{
    //outlet.layer.cornerRadius=8.0f;
    outlet.layer.masksToBounds=YES;
    outlet.layer.borderColor=[color CGColor];
    outlet.layer.borderWidth= 1.5f;
}

#pragma mark - AlertView
-(void)addAlertViewWithMessageStr:(NSString *)messageStr{
    
    if (messageStr.length == 0 || messageStr == nil) {
       messageStr = NSLocalizedString(@"Something went wrong. Please try again later.", nil) ;
    }
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:ALERT_TITLE  message: messageStr preferredStyle:UIAlertControllerStyleAlert];
    [myAlertController addAction: [self dismissAlertView_OKTapped:myAlertController]];
    [self presentViewController:myAlertController animated:YES completion:nil];
}

-(UIAlertAction *)dismissAlertView_OKTapped:(UIAlertController *)myAlertController
{
    return [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
        [myAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)btnBackTapped{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSArray *)getLatLongWithAddressStr:(NSString *)addressStr{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    //center.latitude = latitude;
   // center.longitude = longitude;
    NSArray *latLongArr = [NSArray arrayWithObjects:[NSNumber numberWithDouble: latitude ],[NSNumber numberWithDouble: longitude ], nil];
    
    if (latitude ==0 && longitude == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"This address is not correct. Please try again or use Manual Search option." delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil,nil];
        [alertView show];
        
        return nil;
    }
      NSLog(@"latLongArr = %@",latLongArr);
    return latLongArr;
}
#pragma mark - NSUserDefault
-(BOOL)setNSDefaultValue:(NSObject *)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}
-(NSString *)getNSDefaultValueforKey:(NSString *)key {
    return (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:key];
}
-(BOOL)removeNSDefaultforKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Objects
-(AppDelegate *)appdelegate;{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

-(Validation *)getValidationObj {
    if (valOb == nil) {
        valOb = [[Validation alloc]init];
    }
    return valOb;
}
#pragma mark - Color
-(UIColor *)SetUIColorRed:(int)red Green:(int)green Blue:(int)blue Alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

-(void)setPlaceholderColorOFTextField:(UITextField *)textField Color:(UIColor *)color PlaceholderText:(NSString *)placeholderText
{
    if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
}
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
#pragma mark - Validation
- (BOOL)isStringEmpty:(NSString *)string
{
    if([string length] == 0) { //string is empty or nil
        return YES;
    }
    if(![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        //string is all whitespace
        return YES;
    }
    return NO;
}
-(BOOL)isValidPassword:(NSString *)checkString{
//    (?=.*?[a-z])(?=.*?[A-Z])(?=.*?[^a-zA-Z]).{8,}
    
    // *** Validation for Password ***
    // "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$" --> (Minimum 8 characters at least 1 Alphabet and 1 Number)
    // "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,16}$" --> (Minimum 8 and Maximum 16 characters at least 1 Alphabet, 1 Number and 1 Special Character)
    // "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$" --> (Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number)
    // "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}" --> (Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character)
    // "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,10}" --> (Minimum 8 and Maximum 10 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character)
    
    
    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,15}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [passwordTest evaluateWithObject:checkString];
}


-(BOOL)isValidEmail:(NSString *)checkString
{
    /*
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];*/
    
    
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
    /*
    NSString *emailRegex=@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailtest=[NSPredicate predicateWithFormat:@"Self matches %@",emailRegex];
    return [emailtest evaluateWithObject:checkString];*/
}

-(void)ShowCustomHud:(int)isnavigation_View{
 //   [self samplerLoader];
    if (HUD == nil) {
        if (isnavigation_View == 1) {
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        } else {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
        }
        [self.view addSubview:HUD];
          [[UIApplication sharedApplication].keyWindow bringSubviewToFront:HUD];
        HUD.delegate = self;
        HUD.detailsLabelText = @"Please wait...";
        HUD.square = YES;
    }
  //  [HUD show:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [GiFHUD dismiss];
        [GiFHUD showWithOverlay];
    });
    
}
-(void)hideCustomHud{
  //  [HUD hide:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [GiFHUD dismiss];
    });
}




-(void)ShowCustomHud123:(int)isnavigation_View{
    
    if (HUD == nil) {
        if (isnavigation_View == 1) {
            HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        } else {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
        }
       
        
         [[self appdelegate].window addSubview:HUD];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:HUD];
        
     
        HUD.delegate = self;
        HUD.detailsLabelText = @"Please wait...";
        HUD.square = YES;
    }
   // [HUD show:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [GiFHUD dismiss];
        [GiFHUD showWithOverlay];
    });
}
-(void)hideCustomHud123{
  //  [HUD hide:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [GiFHUD dismiss];
    });

}
-(void)navigationBarBlackColor{
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    } else {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.translucent = NO;
    }
}
-(void)navigationBarWhiteColor{

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
    }
}
-(BOOL)isInterNetAvailable{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return false;
    } else {
        return true;
    }
}
#pragma mark - phone Validation

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    NSInteger length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    
    return mobileNumber;
}
-(NSInteger)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSInteger length = [mobileNumber length];
    
    return length;
}
-(NSString*)getPhoneNumber:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    return mobileNumber;
}
-(void)boldFontForLabel:(UILabel *)label{
    UIFont *currentFont = label.font;
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize];
    label.font = newFont;
}


#pragma mark - Toast
-(void)showToastMessage:(NSString *)msg{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = msg;
    hud.detailsLabelFont =[UIFont fontWithName:@"Montserrat-light" size:15.0f];
    hud.margin = 10.f;
    //hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3.0];
    hud = nil;
}
#pragma mark - Country Code
-(NSArray *)getCountryNamesByCodeWithCountryCodeArr:(NSArray *)countryCodeArr{
    
    NSMutableArray *countryNames= [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *code in countryCodeArr) {
        
        id countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:code];
        
        id phoneNumberLocale = [NBPhoneNumberUtil sharedInstance];
        
        NSString *phoneCode= [NSString stringWithFormat:@"+%@",[phoneNumberLocale getCountryCodeForRegion:code]];
        
        if (![phoneCode isEqualToString:@"+0"]) {
            [countryNames addObject:countryName];
        }
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [countryNames sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    return (NSArray *)countryNames;
}

-(NSArray *)getCountryDataByCodeWithCountryCodeArr:(NSArray *)countryCodeArr{
    
    NSMutableArray *countries= [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *code in countryCodeArr) {
        
        id countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:code];
        
        id phoneNumberLocale = [NBPhoneNumberUtil sharedInstance];
        
        NSString *phoneCode= [NSString stringWithFormat:@"+%@",[phoneNumberLocale getCountryCodeForRegion:code]];
        
        if (![phoneCode isEqualToString:@"+0"]) {
            
            NSDictionary *country = @{
                                      @"countryCode":code,
                                      @"countryName":countryName,
                                      @"phoneCode":phoneCode
                                      };
            [countries addObject:country];
        }
    }
    
    NSSortDescriptor *countryDescriptor= [[NSSortDescriptor alloc] initWithKey:@"countryName" ascending:YES];
    NSArray*sortDescriptors = [NSArray arrayWithObject:countryDescriptor];
    countries = [[countries sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    return countries;
}
-(NSString *)getDocDicPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   return  [paths objectAtIndex:0];
}
-(NSString *)getCurrentLocalePhoneCode{
    id phoneNumberLocale = [NBPhoneNumberUtil sharedInstance];
    NSString *phoneCode= [NSString stringWithFormat:@"+%@",[phoneNumberLocale getCountryCodeForRegion:[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]]];
    return phoneCode;
}

-(NSDictionary *)getMascotImageDictionary:(NSArray *)mascotSaveDataArray key:(NSString *)mascotKey mascotKeyValue:(NSString *)mascotKeyValue {
    NSInteger indexOfMatchingDictionary = [mascotSaveDataArray indexOfObjectPassingTest:^BOOL(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        return [[obj valueForKey:mascotKey] isEqual:mascotKeyValue];
    }];
    NSDictionary *matchingDictionary = [mascotSaveDataArray objectAtIndex:indexOfMatchingDictionary];
    
    if (matchingDictionary != nil) {
        NSString *mascotActualValue = [matchingDictionary objectForKey:@"VALUE"];
        NSRange r1 = [mascotActualValue rangeOfString:@"{"];
        NSRange r2 = [mascotActualValue rangeOfString:@"}"];
        NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
        NSString *subMascotGroup = [mascotActualValue substringWithRange:rSub];
        
        
        mascotActualValue = [mascotActualValue stringByReplacingOccurrencesOfString:subMascotGroup
                                                                         withString:@"Catky"];
        mascotActualValue = [mascotActualValue stringByReplacingOccurrencesOfString:@"{"
                                                                         withString:@""];
        mascotActualValue = [mascotActualValue stringByReplacingOccurrencesOfString:@"}"
                                                                         withString:@""];
        
        
        mascotKey = @"KEY";
        mascotKeyValue = mascotActualValue;
        NSInteger indexOfMatchingDictionary = [mascotSaveDataArray indexOfObjectPassingTest:^BOOL(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            return [[obj valueForKey:mascotKey] isEqual:mascotKeyValue];
        }];
        NSDictionary *imageDictionary = [mascotSaveDataArray objectAtIndex:indexOfMatchingDictionary];
        NSLog( @"imageDictionary = %@",imageDictionary);
        return imageDictionary;
    }
    return nil;
}
-(void)saveCarDetailsInNsuserDefault:(NSDictionary*)carDic
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:carDic];
    [userDefaults setObject:dataSave forKey:@"DocumentData"];
    [userDefaults synchronize];
    

}
-(NSDictionary*)getCarDetailsInNsuserDefault
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"DocumentData"];
    NSDictionary *documentData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return documentData;
}

@end
