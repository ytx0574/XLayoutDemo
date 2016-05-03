//
//  XLayoutViewService.h
//  XLayout
//
//  Created by B&W on 16/4/26.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>

extern NSString *const XLAYOUT_CONTROLLER_VIEW_ID;
extern NSString *const XLAYOUT_TABLE_VIEW_CELL_ID;
extern NSString *const XLAYOUT_COLLECTION_VIEW_CELL_ID;
extern NSString *const XLAYOUT_COLLECTION_REUSABLE_VIEW_ID;

@class XLayoutBase;
@class XLayoutViewService;
@interface UIView (XLayoutBase)

/// 视图的唯一标识,引用id布局时需要用到,一个XML内的layout_id不应该是重复的,否则可能会覆盖,包括引用过来的XML.
@property (nonatomic, copy, readonly) NSString *layout_id;
/// 视图的布局类,可以通过他更改布局,修改具体的布局属性后,需要调用activate方法激活布局.
@property (nonatomic, strong, readonly) XLayoutBase *layout;
/// 视图的管理类,看下边的注释.
@property (nonatomic, weak, readonly) XLayoutViewService *viewService;

@end

/** 视图的创建者对象,如果你是以UIViewController提供的初始化方法创建的视图,你可以不用操心这个对象,
    如果你想要用他单独创建一个视图来给你使用,你必须在获取contentView对象后调用activateLayout方法激活布局,
    如果你后续想要通过layout_id的方式来获取到一个视图,那么你必须保留这个对象的引用. */
@interface XLayoutViewService : NSObject

/// XML视图.
@property (nonatomic, readonly, strong) UIView *contentView;
/// 事件处理者
@property (nonatomic, readonly, strong) id eventHandler;

/** 指定初始化方法,一个XML名称,一个事件处理者,如果你在XML里边指定了UIButton的onClick类似方法,
    刚你必须指定一个事件处理者,否则收不到回调,如果你是以UIViewController提供的初始化方法创建的视图,
    你可以不用设置这个对象,默认为你的UIViewController,如果你是集合类的视图,例如:UITableViewCell,
    如果是以指定初始化方法(XLAYOUT_TABLE_VIEW_CELL_FROM_XML_NAME)创建的,默认为Cell本身. */
+ (instancetype)serviceFromXMLName:(NSString *)name eventHandler:(id)eventHandler;

/// 激活视图布局,这里是创建视图出来后的全局激活,XLayoutBase是单个View的.
- (void)activateLayout;
/// 根据视图的layout_id获得这个视图
- (id(^)(NSString *layoutId))getViewById;

@end
