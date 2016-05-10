//
//  UIColor+XLayout.h
//  XLayout
//
//  Created by B&W on 16/4/28.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XLAYOUT_RGB(RED,GREEN,BLUE) [UIColor colorWithRed:(red / 255.0f) green:(green / 255.0f) blue:(blue / 255.0f) alpha:alpha]

@interface UIColor (XLayout)

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
