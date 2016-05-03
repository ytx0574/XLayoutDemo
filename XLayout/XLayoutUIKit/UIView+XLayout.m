//
//  UIView+XLayout.m
//  XLayout
//
//  Created by B&W on 16/4/26.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import "UIView+XLayout.h"
#import "UIColor+XLayoutPrivate.h"
#import "UIView+XLayoutPrivate.h"
#import <objc/runtime.h>


@implementation UIView (XLayout)

- (void)setCorner_border:(NSString *)corner_border {
    NSRange r = [corner_border rangeOfString:@"^\\{.+\\}$" options:NSRegularExpressionSearch];
    NSArray *component = nil;
    if (r.location != NSNotFound && r.length != 0) {
        r.location += 1;
        r.length -= 2;
        component = [[corner_border substringWithRange:r] componentsSeparatedByString:@","];
    }
    NSAssert((component.count > 0 && [component count] <= 3), @"Parameter format error. attribute:%@",corner_border);
    
    self.layer.cornerRadius = [[component firstObject] floatValue];
    if (component.count >= 2) {
        self.layer.borderWidth = [[component objectAtIndex:1] floatValue];
    }
    if (component.count == 3) {
        self.layer.borderColor = [[UIColor colorWithString:[component lastObject]] CGColor];
    }
}

- (NSString *)corner_border {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTap_event:(NSString *)tap_event {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
    [gesture addTarget:self.privateEventHandler action:NSSelectorFromString(tap_event)];
    [self addGestureRecognizer:gesture];
    objc_setAssociatedObject(self, @selector(tap_event), tap_event, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)tap_event {
    return objc_getAssociatedObject(self, _cmd);
}

@end


