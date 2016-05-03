//
//  UIView+XLayout.h
//  XLayout
//
//  Created by B&W on 16/4/26.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XLayout)

/** 参数格式{cornerRadius,borderColor,borderWidth},后两项为空时省略,号,在列表对性能有要
    求时建议不要使用这个属性设置圆角及边框 */
@property (nonatomic, copy) NSString *corner_border;

/// tap事件,指定一个方法名称
@property (nonatomic, copy) NSString *tap_event;

@end
