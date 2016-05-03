//
//  UIButton+XLayout.m
//  XLayout
//
//  Created by B&W on 16/4/28.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import "UIButton+XLayout.h"
#import "UIView+XLayoutPrivate.h"
#import "ONOXMLDocument.h"
#import <objc/runtime.h>

@implementation UIButton (XLayout)

+ (instancetype)viewWithXMLElementObject:(ONOXMLElement *)element {
    UIButtonType buttonType = UIButtonTypeCustom;
    NSString *typeString = [element valueForAttribute:@"buttonType"];
    if ([typeString isEqualToString:@"UIButtonTypeSystem"]) {
        buttonType = UIButtonTypeSystem;
    }else if ([typeString isEqualToString:@"UIButtonTypeDetailDisclosure"]) {
        buttonType = UIButtonTypeDetailDisclosure;
    }else if ([typeString isEqualToString:@"UIButtonTypeInfoLight"]) {
        buttonType = UIButtonTypeInfoLight;
    }else if ([typeString isEqualToString:@"UIButtonTypeInfoDark"]) {
        buttonType = UIButtonTypeInfoDark;
    }else if ([typeString isEqualToString:@"UIButtonTypeContactAdd"]) {
        buttonType = UIButtonTypeContactAdd;
    }
    return [UIButton buttonWithType:buttonType];
}

+ (instancetype)xLayoutInit {
    return [UIButton buttonWithType:UIButtonTypeCustom];
}

#pragma mark - Title

- (void)setN_title:(NSString *)n_title {
    [self setTitle:n_title forState:UIControlStateNormal];
}

- (NSString *)n_title {
    return [self titleForState:UIControlStateNormal];
}

- (void)setH_title:(NSString *)h_title {
    [self setTitle:h_title forState:UIControlStateHighlighted];
}

- (NSString *)h_title {
    return [self titleForState:UIControlStateHighlighted];
}

- (void)setS_title:(NSString *)s_title {
    [self setTitle:s_title forState:UIControlStateSelected];
}

- (NSString *)s_title {
    return [self titleForState:UIControlStateSelected];
}

#pragma mark - Color

- (void)setNt_color:(UIColor *)nt_color {
    [self setTitleColor:nt_color forState:UIControlStateNormal];
}

- (UIColor *)nt_color {
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setHt_color:(UIColor *)ht_color {
    [self setTitleColor:ht_color forState:UIControlStateHighlighted];
}

- (UIColor *)ht_color {
    return [self titleColorForState:UIControlStateHighlighted];
}

- (void)setSt_color:(UIColor *)st_color {
    [self setTitleColor:st_color forState:UIControlStateSelected];
}

- (UIColor *)st_color {
    return [self titleColorForState:UIControlStateSelected];
}

#pragma mark - Image

- (void)setN_image:(UIImage *)n_image {
    [self setImage:n_image forState:UIControlStateNormal];
}

- (UIImage *)n_image {
    return [self imageForState:UIControlStateNormal];
}

- (void)setH_image:(UIImage *)h_image {
    [self setImage:h_image forState:UIControlStateHighlighted];
}

- (UIImage *)h_image {
    return [self imageForState:UIControlStateHighlighted];
}

- (void)setS_image:(UIImage *)s_image {
    [self setImage:s_image forState:UIControlStateSelected];
}

- (UIImage *)s_image {
    return [self imageForState:UIControlStateSelected];
}

#pragma mark - Background Image

- (void)setNb_image:(UIImage *)nb_image {
    [self setBackgroundImage:nb_image forState:UIControlStateNormal];
}

- (UIImage *)nb_image {
    return [self backgroundImageForState:UIControlStateNormal];
}

- (void)setHb_image:(UIImage *)hb_image {
    [self setBackgroundImage:hb_image forState:UIControlStateHighlighted];
}

- (UIImage *)hb_image {
    return [self backgroundImageForState:UIControlStateHighlighted];
}

- (void)setSb_image:(UIImage *)sb_image {
    [self setBackgroundImage:sb_image forState:UIControlStateSelected];
}

- (UIImage *)sb_image {
    return [self backgroundImageForState:UIControlStateSelected];
}

#pragma mark - Event

- (void)setOnClick:(NSString *)onClick{
    NSAssert(self.privateEventHandler, @"You set up an onclick method But the event handler is nil");
    [self addTarget:self.privateEventHandler action:NSSelectorFromString(onClick) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self, @selector(onClick), onClick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)onClick {
    return objc_getAssociatedObject(self, _cmd);
}

@end
