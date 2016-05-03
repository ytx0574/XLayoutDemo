//
//  NSLayoutConstraint+XLayoutPrivate.m
//  XLayout
//
//  Created by B&W on 16/4/28.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import "NSLayoutConstraint+XLayoutPrivate.h"
#import "XLayoutViewService.h"
#import <objc/runtime.h>

@implementation NSLayoutConstraint (XLayoutPrivate)

- (void)setLayoutPosition:(NSString *)layoutPosition {
    objc_setAssociatedObject(self, @selector(layoutPosition), layoutPosition, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)layoutPosition {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLayoutAttribute:(NSString *)layoutAttribute {
    objc_setAssociatedObject(self, @selector(layoutAttribute), layoutAttribute, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)layoutAttribute {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark -Private

+ (NSDictionary *)layoutRelationDescriptionMap {
    static dispatch_once_t once;
    static NSDictionary *map;
    dispatch_once(&once, ^{
        map = @{@(NSLayoutRelationEqual)                : @"==",
                @(NSLayoutRelationGreaterThanOrEqual)   : @">=",
                @(NSLayoutRelationLessThanOrEqual)      : @"<=",
                };
    });
    return map;
}

+ (NSDictionary *)layoutAttributeDescriptionMap {
    static dispatch_once_t once;
    static NSDictionary *map;
    dispatch_once(&once, ^{
        map = @{@(NSLayoutAttributeTop)      : @"top",
                @(NSLayoutAttributeLeft)     : @"left",
                @(NSLayoutAttributeBottom)   : @"bottom",
                @(NSLayoutAttributeRight)    : @"right",
                @(NSLayoutAttributeLeading)  : @"leading",
                @(NSLayoutAttributeTrailing) : @"trailing",
                @(NSLayoutAttributeWidth)    : @"width",
                @(NSLayoutAttributeHeight)   : @"height",
                @(NSLayoutAttributeCenterX)  : @"centerX",
                @(NSLayoutAttributeCenterY)  : @"centerY",
                @(NSLayoutAttributeBaseline) : @"baseline",
                };
    });
    return map;
}

+ (NSString *)descriptionForObject:(id)obj {
    if ([obj respondsToSelector:@selector(layout_id)] && [obj layout_id]) {
        return [NSString stringWithFormat:@"%@(%p layout_id=\"%@\")", [obj class], obj, [obj layout_id]];
    }
    return [NSString stringWithFormat:@"%@(%p)", [obj class], obj];
}

- (NSString *)description {
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendString:@"\n<"];
    [description appendFormat:@"%@", [self.class descriptionForObject:self.firstItem]];
    if (self.firstAttribute != NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@".%@", [[[self class] layoutAttributeDescriptionMap] objectForKey:@(self.firstAttribute)]];
    }
    [description appendFormat:@" %@", [[[self class] layoutRelationDescriptionMap] objectForKey:@(self.relation)]];
    if (self.secondItem) {
        [description appendFormat:@" %@", [self.class descriptionForObject:self.secondItem]];
    }
    if (self.secondAttribute != NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@".%@", [[[self class] layoutAttributeDescriptionMap] objectForKey:@(self.secondAttribute)]];
    }
    if (self.multiplier != 1.0) {
        [description appendFormat:@" * %g", self.multiplier];
    }
    if (self.secondAttribute == NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@" %@", @(self.constant)];
    } else {
        [description appendFormat:@" %@ %g", (self.constant < 0 ? @"-" : @"+"), ABS(self.constant)];
    }
    [description appendFormat:@" priority:%@", @(self.priority)];
    [description appendString:@">"];
    if (self.layoutPosition && self.layoutAttribute) {
        [description appendFormat:@"\n\n<XLayout attribute ==> %@=\"%@\")>",self.layoutPosition,self.layoutAttribute];
    }
    return description;
}

@end
