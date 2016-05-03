//
//  UIViewController+XLayout.h
//  XLayout
//
//  Created by B&W on 16/4/27.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLayoutViewService;
@interface UIViewController (XLayout)

@property (nonatomic, strong) XLayoutViewService *viewService;
- (void)loadViewFromXMLName:(NSString *)name;

@end
