//
//  UICollectionReusableView+XLayout.h
//  XLayout
//
//  Created by B&W on 16/4/30.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XLAYOUT_COLLECTION_VIEW_CELL_FROM_XML_NAME(XML_NAME) \
- (instancetype)initWithFrame:(CGRect)frame { \
    self = [super initWithFrame:frame]; \
    if (self) { \
        [self loadViewFromXMLName:XML_NAME]; \
        [self setup]; \
    } \
    return self; \
} \

@class XLayoutViewService;
@interface UICollectionReusableView (XLayout)

@property (nonatomic, strong) XLayoutViewService *viewService;
- (void)loadViewFromXMLName:(NSString *)name;

- (void)setup;

@end
