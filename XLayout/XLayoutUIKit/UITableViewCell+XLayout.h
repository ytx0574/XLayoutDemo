//
//  UITableViewCell+XLayout.h
//  XLayout
//
//  Created by B&W on 16/4/30.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XLAYOUT_TABLE_VIEW_CELL_FROM_XML_NAME(XML_NAME) \
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier { \
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]; \
    if (self) { \
        [self loadViewFromXMLName:XML_NAME]; \
        [self setup]; \
    } \
    return self; \
} \

@class XLayoutViewService;
@interface UITableViewCell (XLayout)

@property (nonatomic, strong) XLayoutViewService *viewService;
- (void)loadViewFromXMLName:(NSString *)name;

- (void)setup;

@end
