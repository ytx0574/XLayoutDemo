//
//  UICollectionReusableView+XLayout.m
//  XLayout
//
//  Created by B&W on 16/4/30.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import "UICollectionReusableView+XLayout.h"
#import "UIView+XLayoutPrivate.h"
#import "XLayoutViewService.h"
#import <objc/runtime.h>

@implementation UICollectionReusableView (XLayout)

- (void)setViewService:(XLayoutViewService *)viewService {
    objc_setAssociatedObject(self, @selector(viewService), viewService, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XLayoutViewService *)viewService {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)loadViewFromXMLName:(NSString *)name {
    XLayoutViewService *service = [XLayoutViewService serviceFromXMLName:name eventHandler:self];
    if ([self isKindOfClass:[UICollectionViewCell class]]) {
        [((UICollectionViewCell *)self).contentView addSubview:service.contentView];
        [((UICollectionViewCell *)self).contentView privateSetLayout_id:XLAYOUT_COLLECTION_VIEW_CELL_ID];
    }else {
        [self addSubview:service.contentView];
        [self privateSetLayout_id:XLAYOUT_COLLECTION_REUSABLE_VIEW_ID];
    }
    
    [self setViewService:service];
    [service activateLayout];
}

@end
