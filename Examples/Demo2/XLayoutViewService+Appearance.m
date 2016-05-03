//
//  XLayoutViewService+Appearance.m
//  Examples
//
//  Created by B&W on 16/5/3.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import "XLayoutViewService+Appearance.h"
#import <UIKit/UIImage.h>

@implementation XLayoutViewService (Appearance)

- (UIColor *)backgroundColor {
    return [UIColor brownColor];
}

- (UIImage *)image {
    return [UIImage imageNamed:@"demo"];
}

- (UIFont *)font {
    return [UIFont boldSystemFontOfSize:30];
}

@end
