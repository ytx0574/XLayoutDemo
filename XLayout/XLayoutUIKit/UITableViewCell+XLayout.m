//
//  UITableViewCell+XLayout.m
//  XLayout
//
//  Created by B&W on 16/4/30.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import "UITableViewCell+XLayout.h"
#import "UIView+XLayoutPrivate.h"
#import "XLayoutViewService.h"
#import <objc/runtime.h>

@implementation UITableViewCell (XLayout)

- (void)setViewService:(XLayoutViewService *)viewService {
    objc_setAssociatedObject(self, @selector(viewService), viewService, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XLayoutViewService *)viewService {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)loadViewFromXMLName:(NSString *)name {
    XLayoutViewService *service = [XLayoutViewService serviceFromXMLName:name eventHandler:self];
    [self.contentView addSubview:service.contentView];
    [self.contentView privateSetLayout_id:XLAYOUT_TABLE_VIEW_CELL_ID];
    [self setViewService:service];
    [service activateLayout];
}

- (void)setup {
    
}

@end
