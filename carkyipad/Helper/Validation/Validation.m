//
//  Validation.m
//  TheRxApp
//
//  Created by Rahul Mistry on 26/12/14.
//  Copyright (c) 2014 Rajesh Deshmukh. All rights reserved.
//

#import "Validation.h"
#import "Reachability.h"
#import "Macros.h"
@implementation Validation
#pragma mark - validation
-(BOOL)checkNet
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return networkStatus;
}
-(BOOL)netWorkStatus
{
    SCNetworkReachabilityFlags flags;
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability networkStatusForFlags:flags];
    return networkStatus;
}

- (BOOL)isAlphaNumeric:(NSString *)zipCode
{
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:APHANUMERIC_CHARACTERS];
    s = [s invertedSet];
    NSRange r = [zipCode rangeOfCharacterFromSet:s];
    if (r.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}
-(BOOL)charZipCode:(NSString *)zipCode{
    NSString *CharRegEx = @"(?i)^[a-z0-9][a-z0-9\\- ]{0,10}[a-z0-9]$";
   // NSString *postcodeRegex = @"[A-Z]{1,2}[0-9R][0-9A-Z]?(\s|)([0-9][ABD-HJLNP-UW-Z]{2}";//WITH SPACES
    NSPredicate *CharTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CharRegEx];
    if ([CharTest evaluateWithObject:zipCode] == YES)
        return FALSE;
    else
        return TRUE;
}
-(BOOL)charValidation:(NSString *)NameValidate{
    NSString *CharRegEx = @"[a-zA-Z][a-zA-Z ]+";
    NSPredicate *CharTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CharRegEx];
    if ([CharTest evaluateWithObject:NameValidate] == YES)
        return TRUE;
    else
        return FALSE;
}
#pragma mark  emailvalidation
-(BOOL)emailValidation:(NSString *)emailvalid{
    NSString *emailRegex=@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailtest=[NSPredicate predicateWithFormat:@"Self matches %@",emailRegex];
    return [emailtest evaluateWithObject:emailvalid];
}
#pragma mark - MobileNumberValidate
- (BOOL)mobileNumberValidate:(NSString*)number{
    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}
-(BOOL)isDigit:(NSString*)string
{
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    return stringIsValid;
}
#pragma mark - phoneParsing
-(NSString *)phoneParsing:(NSString *)phoneNo{
    NSString *ph_no=[phoneNo stringByReplacingOccurrencesOfString:@"(" withString:@""];
    NSString *ph_no1=[ph_no stringByReplacingOccurrencesOfString:@")" withString:@""];
    NSString *ph_no2=[ph_no1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *ph_no3=[ph_no2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    return ph_no3;
}
-(NSString*)formatNumber:(NSString*)mobileNumber{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
   // mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    int length = (int ) [mobileNumber length];
    if(length > 10){
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
    }
    return mobileNumber;
}
-(NSMutableString *)phoneProcessing :(NSString *)input
{
    if (input.length != 0) {
        NSMutableString *mu= [NSMutableString stringWithString:input];
        //[mu insertString:@"(" atIndex:0];
       // [mu insertString:@")" atIndex:4];
        //[mu insertString:@"-" atIndex:3];
       // [mu insertString:@"-" atIndex:9];
         return mu;
    } else {
        return [input mutableCopy];
    }
}
-(int)getLength:(NSString*)mobileNumber{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    int length =(int) [mobileNumber length];
    return length;
}
@end
