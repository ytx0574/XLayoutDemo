//
//  UIButton+XLayout.h
//  XLayout
//
//  Created by B&W on 16/4/28.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XLayout)

/// 正常状态的标题
@property (nonatomic, weak, readonly) NSString *n_title;
/// 高亮状态的标题
@property (nonatomic, weak, readonly) NSString *h_title;
/// 选中状态的标题
@property (nonatomic, weak, readonly) NSString *s_title;

/// 正常状态的标题颜色
@property (nonatomic, weak, readonly) UIColor *nt_color;
/// 高亮状态的标题颜色
@property (nonatomic, weak, readonly) UIColor *ht_color;
/// 选中状态的标题颜色
@property (nonatomic, weak, readonly) UIColor *st_color;

/// 正常状态的图片
@property (nonatomic, weak, readonly) UIImage *n_image;
/// 高亮状态的图片
@property (nonatomic, weak, readonly) UIImage *h_image;
/// 选中状态的图片
@property (nonatomic, weak, readonly) UIImage *s_image;

/// 正常状态的背景图片
@property (nonatomic, weak, readonly) UIImage *nb_image;
/// 高亮状态的背景图片
@property (nonatomic, weak, readonly) UIImage *hb_image;
/// 选中状态的背景图片
@property (nonatomic, weak, readonly) UIImage *sb_image;

/// 点击事件回调方法布局属性,直接指定一个方法名称即可
@property (nonatomic, copy, readonly) NSString *onClick;

@end
