
#pragma mark - Floating Point Comparision

/**
 Error tolerance for folating point comparision
 */
//#define EPSILON 1.0e-7


/**
 Compare two floating point numbers for equality.
 */

#ifndef DEBUG

#define NSLog(...) /* suppress NSLog when in release mode */

#endif

#define ALERT_TITLE @"Carky"

#define AcceptTermCondition @"Please tick the checkbox if you agree terms and conditions."



#define ALERT_ERROR @"Server not responding please try again."
#define internetConnection @"Oops! Please check your internet connection and try again."
#define serverErrorMSG @"Something went wrong. Please try again later."


//Validation MSG

#define FnameZeroLength @"Name should not be empty."//
#define LnameZeroLength @"Surname should not be empty."//
#define AddressZeroLength @"Address should not be empty."//
#define emailIdZeroLength @"Email should not be empty."//
#define validemailId @"Please enter valid email."//
#define passwordLengthSizeMin @"Password must be at least 8 characters."//
#define passwordLengthSizeMax @"Password should not be greater than 15 characters."//
#define check_New_Confirm_Password @"Password and confirm password does not match."//
#define PhoneNoZeroLength @"Please enter phone number"//
#define confirmPassword @"Please enter Confirm Password."//
#define ConfirmPasswordZeroLength @"Please enter confirm password."//
#define  PhoneNoLengthSize @"Phone number is not valid."//
#define passwordZeroLength @"Please enter password."//

#define CameraValidation @"Camera is not available for this device."
#define FnameLengthSize @"Please enter name with minimum 3 and maximum 25 characters."
#define LnameLengthSize @"Please enter surname with minimum 3 and maximum 25 characters."

#define  AddressLengthSize @"Please enter address with minimum 5 and maximum 150 characters."

#define CurrentpasswordZeroLength @"Please enter current password."


#define ConfirmpasswordLengthSizeMin @"Please enter confirm password with minimum 8"
#define ConfirmpasswordLengthSizeMax @"Please enter confirm password with maximum 15 characters."
#define setPasswordSuccessfully @"Password has been chnaged successfully."
#define authorizationDenied  @"Authorization has been denied"


#define countryZeroLength @"Please select your Country."
#define oldPassword @"Please enter Old Password."
#define newPassword @"Please enter New Password."


//#define check_Old_New_Password @"Passwords did not match."


#define setProfileUpdatedSuccessfully @"Your profile has been updated successfully."

#define verificationLength @"Please enter Verification Code."

#define ReferalCodeZeroLength @"No referal code available."
#define OTPCodeZeroLength @"Please enter valid OTP."
#define ENTERValidOTPCode @"Please verify your OTP."


//add car in signup process
#define carmakeZeroLength @"Please select the car make."
#define carmoduleZeroLength @"Please select the car model."
#define caryearZeroLength @"Please select the car year."
#define cartransmissionZeroLength @"Please select the car transmission."
#define carfuelZeroLength @"Please select the car fuel."
#define carregNoZeroLength @"Please enter the car registration number."
#define carkmLength @"Please select the car kilometer."
#define caraddressZeroLength @"Please select the car address."

//insurance flow
#define registrationZeroLength @"Please enter expiration date."
#define registrationLengthSize @"Expiration date must be 6 characters."

#define insuranceZeroLength @"Please enter insurance expiration date."
#define insuranceLengthSize @"Insurance expiration date must be 6 characters."

#define MotZeroLength @"Please enter MOT expiration date."
#define MotLengthSize @"Insurance MOT date must be 6 characters."

//Taxi contact us screen
#define subjectZeroLength @"Please enter subject."
#define messageZeroLength @"Please enter message."

//Taxi promotion screen
#define promoCodeZeroLength @"Please enter promo code."

// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.


#define ALERT_TITLE @"Carky"

//Local Host Server WEBAPI_BASEURL
#define BASEURL @"http://carky-app.azurewebsites.net"

//Local Server WEBAPI_BASEURL

//live Server WEBAPI_BASEURL
//#define WEBAPI_BASEURL @""

//color codes
#define Orange @"EO5E1A"
#define Skyblue @"3798c7"
#define BlackGray @"4a4949"
#define lightGray @"f0f0f0"
#define CopyrightStrip @"f9f9f9"


// for NSUserDefault
#define USERID @"USERID"
#define StayLoginStatus @"StayLoginStatus"
#define DEVICE_UUID @"DEVICE_UUID"


#define PHONENUMBER @"PHONENUMBER"
#define DEVICETOKEN @"DEVICETOKEN"


// for Validations
#define ACCEPTABLE_CHARACTERS_NAME @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz. "
#define APHANUMERIC_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 "


#define ACCEPTABLE_EMAIL @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 _.-@"
#define ACCEPTABLE_PASSWORD @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.-@!@#$%^&*():;""{}[]?/,~`"

#define ACCEPTABLE_CHARACTERS_ADDRESS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define IS_IPHONE (!IS_IPAD)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
#define IOS_OLDER_THAN_6 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] < 6.0 )
#define IOS_NEWER_OR_EQUAL_TO_6 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 6.0 )
#define IOS_OlDER_THAN_7 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] <7.0 )
#define IOS_NEWER_OR_EQUAL_TO_7 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 7.0 )
#define IS_IOS8_AND_UP ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define IS_IOS8_AND_OlDER ([[UIDevice currentDevice].systemVersion floatValue] <= 8.0)
#define IS_IOS9_AND_UP ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)

