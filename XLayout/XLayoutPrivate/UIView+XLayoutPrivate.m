//
//  UIView+XLayoutPrivate.m
//  XLayout
//
//  Created by B&W on 16/5/1.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import "UIView+XLayoutPrivate.h"
#import <objc/runtime.h>

@implementation UIView (XLayoutPrivate)

+ (instancetype)viewWithXMLElementObject:(id)element {
    return [[self alloc] init];
}

- (void)privateSetLayout_id:(NSString *)layout_id {
    objc_setAssociatedObject(self, NSSelectorFromString(@"layout_id"), layout_id, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)privateSetLayout:(id)layout {
    objc_setAssociatedObject(self, NSSelectorFromString(@"layout"), layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)privateSetViewService:(XLayoutViewService *)viewService {
    objc_setAssociatedObject(self, NSSelectorFromString(@"viewService"), viewService, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setPrivateEventHandler:(id)privateEventHandler {
    objc_setAssociatedObject(self, @selector(privateEventHandler), privateEventHandler, OBJC_ASSOCIATION_ASSIGN);
}

- (XLayoutViewService *)privateEventHandler {
    return objc_getAssociatedObject(self, _cmd);
}

@end
