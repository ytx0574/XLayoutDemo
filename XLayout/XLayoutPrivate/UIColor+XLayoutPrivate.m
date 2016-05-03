//
//  UIColor+XLayoutPrivate.m
//  XLayout
//
//  Created by B&W on 16/4/28.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import "UIColor+XLayoutPrivate.h"

@implementation UIColor (XLayoutPrivate)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    hexString = [[hexString stringByTrimmingCharactersInSet:characterSet] uppercaseString];
    
    if ([hexString length] < 6) {
        return [UIColor clearColor];
    }
    
    if ([hexString hasPrefix:@"0X"]) {
        hexString = [hexString substringFromIndex:2];
    }else if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    if ([hexString length] != 6) {
        return [UIColor clearColor];
    }
    
    unsigned int r, g, b;
    
    NSRange range = NSMakeRange(0, 2);
    NSString *rString = [hexString substringWithRange:range];
    range.location = 2;
    NSString *gString = [hexString substringWithRange:range];
    range.location = 4;
    NSString *bString = [hexString substringWithRange:range];
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor *)colorWithString:(NSString *)string {
    return [self colorWithHexString:string];
}

@end
