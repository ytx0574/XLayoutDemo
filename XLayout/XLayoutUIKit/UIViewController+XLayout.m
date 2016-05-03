//
//  UIViewController+XLayout.m
//  XLayout
//
//  Created by B&W on 16/4/27.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import "UIViewController+XLayout.h"
#import "UIView+XLayoutPrivate.h"
#import "XLayoutViewService.h"
#import <objc/runtime.h>

@implementation UIViewController (XLayout)

- (void)setViewService:(XLayoutViewService *)viewService {
    objc_setAssociatedObject(self, @selector(viewService), viewService, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XLayoutViewService *)viewService {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)loadViewFromXMLName:(NSString *)name {
    XLayoutViewService *service = [XLayoutViewService serviceFromXMLName:name eventHandler:self];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:service.contentView];
    [self.view privateSetLayout_id:XLAYOUT_CONTROLLER_VIEW_ID];
    [self.view privateSetViewService:service];
    [self setViewService:service];
    [service activateLayout];
}

@end
