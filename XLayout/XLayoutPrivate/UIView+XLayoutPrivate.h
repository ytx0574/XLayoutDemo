//
//  UIView+XLayoutPrivate.h
//  XLayout
//
//  Created by B&W on 16/5/1.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLayoutViewService;
@interface UIView (XLayoutPrivate)

+ (instancetype)viewWithXMLElementObject:(id)element;
- (void)privateSetLayout_id:(NSString *)layout_id;
- (void)privateSetLayout:(id)layout;
- (void)privateSetViewService:(XLayoutViewService *)viewService;
@property (nonatomic, weak) id privateEventHandler;

@end
