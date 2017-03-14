//
//  BaseViewController.h

//
#import <UIKit/UIKit.h>
#import "IIAsyncViewController.h"
@class AppDelegate;

@class Validation;
@protocol MBProgressHUDDelegate;

@interface BaseViewController : IIAsyncViewController <MBProgressHUDDelegate>
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) IBOutlet UIImageView *urlImageView;

-(void)ShowCustomHud123:(int)isnavigation_View;
-(void)hideCustomHud123;
-(void)navigationBarWhiteColor;
-(void)showRightBarButtonItemWithWhiteColor;
-(void)addNavigationBarAppImageWithWhiteColor;

-(void)navigationBarBlackColor;
-(void)SetNavTitle:(NSString *)title ;
-(void)hideNavBar;
-(void)showNavBar;
-(void)showRevealButton;
-(void)showRightBarButtonItem;
-(void)addNavigationBarAppImage;
-(void)btnBackTapped;

-(void)hideTabbar;
-(void)showTabbar;

-(void)setClearNavigationBarColor;
-(void)addGestureToView;
-(void)hideKeyboard;

-(Validation *)getValidationObj;
-(AppDelegate *)appdelegate;

-(NSArray *)getLatLongWithAddressStr:(NSString *)addressStr;

-(void)underlineLable:(UILabel *)templbl :(NSString *)setUpStr;
-(void)setBorderColorToOutlet:(UIControl*)outlet setColor:(UIColor *)color;

-(void)addAlertViewWithMessageStr:(NSString *)messageStr;
-(UIAlertAction *)dismissAlertView_OKTapped:(UIAlertController *)myAlertController;

-(BOOL)setNSDefaultValue:(NSObject *)value forKey:(NSString *)key;
-(NSObject *)getNSDefaultValueforKey:(NSString *)key;
-(BOOL)removeNSDefaultforKey:(NSString *)key;


-(UIColor *)SetUIColorRed:(int)red Green:(int)green Blue:(int)blue Alpha:(CGFloat)alpha;
-(void)setPlaceholderColorOFTextField:(UITextField *)textField Color:(UIColor *)color PlaceholderText:(NSString *)placeholderText;
-(UIColor*)colorWithHexString:(NSString*)hex;

-(UIColor *)setYellowColor;
-(UIColor *)setLightGrayColor;
-(UIColor *)setLightGreenColor;


-(BOOL)isStringEmpty:(NSString *)string;
-(BOOL)isValidEmail:(NSString *)checkString;
-(BOOL)isValidPassword:(NSString *)checkString;

-(void)ShowCustomHud:(int)isnavigation_View;
-(void)hideCustomHud;

-(BOOL)isInterNetAvailable;

-(NSString*)formatNumber:(NSString*)mobileNumber;
-(NSInteger)getLength:(NSString*)mobileNumber;
-(NSString*)getPhoneNumber:(NSString*)mobileNumber;
-(void)boldFontForLabel:(UILabel *)label;



-(void)showToastMessage:(NSString *)msg;


-(NSArray *)getCountryNamesByCodeWithCountryCodeArr:(NSArray *)countryCodeArr;
-(NSArray *)getCountryDataByCodeWithCountryCodeArr:(NSArray *)countryCodeArr;
-(NSString *)getCurrentLocalePhoneCode;

-(NSDictionary *)getMascotImageDictionary:(NSArray *)mascotSaveDataArray key:(NSString *)mascotKey mascotKeyValue:(NSString *)mascotKeyValue;
-(NSString *)getDocDicPath;
-(void)saveCarDetailsInNsuserDefault:(NSDictionary*)carDic;
-(NSDictionary*)getCarDetailsInNsuserDefault;
@end
