//
//  XLayoutBase.h
//  XLayout
//
//  Created by B&W on 16/4/25.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIView;
@interface XLayoutBase : NSObject

/// 指定的初始化方法,内部使用,使用者不用管
- (instancetype)initWithView:(UIView *)view;

/// 布局的视图,使用者不用管
@property (nonatomic, readonly, weak) UIView *view;

/// 指定当更新一个约束的时候删除之前的约束,默认为NO,不删除
@property (nonatomic, assign) BOOL deleteEexistingWhenUpdating;

/** 视图顶部的约束,可以简单的设置一个值,也可以引用一个视图id,例如:layout_top="5",
    这个设置为距离父视图顶部5个Point,引用视图id,例如:layout_top="@id:top_view:5",
    这个设置为距离id为top_view视图顶部5个Point,注意,所有类似这种布局属性,如果没有指定引用的视图id,
    那么就是默认就是父视图,引用可以指定自己,表示跟自己的属性一样,这里可以再加上乘积,例如:layout_top="@id:top_view:5*5",
    表示为距离id为top_view视图顶部5*5个Point(25),同时还可以加上优先级,例如:layout_top="@id:top_view:5*5@1000",
    这个设置在之前的基础上加了一个1000的优先级,表示必须满足,当同时有两个同方向优先级为1000的约束修改时,
    这时候因为无法同时满足两个约束,就会造成异常,控制台会打印异常信息,可以找到异常的布局,修改它.
    这个布局里边的每一个参数都是可以省略的,例如:layout_top="",这样所表示的就是跟父视图顶部相等,
    常量可以有大于等于或者小于等于,例如:layout_top="@id:top_view:>=5*5@1000",默认为==(等于). */
@property (nonatomic, copy) NSString *layout_top;
/// 同layout_top,方向是底部
@property (nonatomic, copy) NSString *layout_bottom;
/// 同layout_top,方向是左边
@property (nonatomic, copy) NSString *layout_left;
/// 同layout_top,方向是右边
@property (nonatomic, copy) NSString *layout_right;
/// 同layout_top,方向是前边,类似left,可以Google他的们区别
@property (nonatomic, copy) NSString *layout_leading;
/// 同layout_top,方向是前边,类似right,可以Google他的们区别
@property (nonatomic, copy) NSString *layout_trailing;

/// 同时指定上边,左边两个方向的约束,参数需要满足{top,left}格式,参数格式同layout_top.
@property (nonatomic, copy) NSString *layout_top_left;
/// 同layout_top_left,方向是底部,右边
@property (nonatomic, copy) NSString *layout_bottom_right;
/// 同layout_top_left,方向是顶部,底部
@property (nonatomic, copy) NSString *layout_top_bottom;
/// 同layout_top_left,方向是左边,右边
@property (nonatomic, copy) NSString *layout_left_right;

/** 视图的宽度,参数同layout_top,这里可以使用倍数来指定大小,例如:layout_width="@id:top_view:*5",
    表示是id为id:top_view宽度的5倍,如果还要加上一点,你就可以加上一个常量,例如:layout_width="@id:top_view:5*5",
    就是在之前的基础上多加了5个Point. */
@property (nonatomic, copy) NSString *layout_width;
/// 同layout_width,属性为高度
@property (nonatomic, copy) NSString *layout_height;
/// 同时指定宽度,高度,格式需满足{width,height},参数格式同layout_top.
@property (nonatomic, copy) NSString *layout_size;
/// 指定视图的纵横比(高宽比例),例如:layout_aspect_ratio="0.5", 表示高是宽的一半,参数格式同layout_top.
@property (nonatomic, copy) NSString *layout_aspect_ratio;

/// 指定视图在某个视图的上边,例如:layout_width="@id:bottom_view:-5",表示在id为bottom_view顶部距离5个Point的位置,参数格式同layout_top.
@property (nonatomic, copy) NSString *layout_above;
/// 同layout_top,在某个视图的下边
@property (nonatomic, copy) NSString *layout_below;
/// 同layout_top,在某个视图的左边
@property (nonatomic, copy) NSString *layout_left_of;
/// 同layout_top,在某个视图的右边
@property (nonatomic, copy) NSString *layout_right_of;

/// 基于layout_baseline对齐,一般不用,UILabel可能会用.看自己的需求吧,参数格式同layout_top.
@property (nonatomic, copy) NSString *layout_baseline;

/// 居中在某个视图中间位置,参数格式同layout_top.
@property (nonatomic, copy) NSString *layout_center;
/// 水平方向居中在某个视图中间位置,参数格式同layout_top.
@property (nonatomic, copy) NSString *layout_centerX;
/// 垂直方向居中在某个视图中间位置,参数格式同layout_top.
@property (nonatomic, copy) NSString *layout_centerY;

/// 指定宽高跟某个视图大小相等,参数格式同layout_top.
@property (nonatomic, copy) NSString *layout_equal;
/// 指定视图在某个视图的四个边缘位置,格式需满足{top, left, bottom, right},参数格式同layout_top.
@property (nonatomic, copy) NSString *layout_edge;

/// 激活布局,当你修改了某个方向的布局时,需要调用这个方法激活.
- (void)activate;
/// 跟activate反作用.
- (void)deactivate;
/// 布局有有效性,可以通过他得到是否存在一个有效的布局.
- (BOOL)validity;

@end
