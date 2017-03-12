//  GiFHUD.h
//  Create Smart
//  Created by Exceptionaire on 22/12/2015.
//  Copyright © 2015 Imagine Craft Pty Ltd

#import <UIKit/UIKit.h>

@interface GiFHUD : UIView
+(void)clearSharedInstance;
+ (void)show;
+ (void)showWithOverlay;

+ (void)dismiss;

+ (void)setGifWithImages:(NSArray *)images;
+ (void)setGifWithImageName:(NSString *)imageName;
+ (void)setGifWithURL:(NSURL *)gifUrl;

@end
