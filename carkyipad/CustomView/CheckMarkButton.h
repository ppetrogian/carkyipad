//
//  CheckMarkButton.h
//  QRCodeProject
//
//  Created by Curious-ios on 8/20/14.
//  Copyright (c) 2014 Avinash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckMarkButton : UIButton

@property (nonatomic) BOOL isChecked;

@property (nonatomic, strong) UIImage *checkedImage;
@property (nonatomic, strong) UIImage *unCheckedImage;
-(void) setDefaultImage:(NSString *)defaultImage SelectedImage:(NSString *)imageName;
@end
