//
//  XLayoutConstraintPrivate.h
//  XLayout
//
//  Created by B&W on 16/4/27.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/NSLayoutConstraint.h>

@class UIView;
@interface XLayoutConstraintPrivate : NSObject

@property (nonatomic, weak  ) UIView *firstView;
@property (nonatomic, assign) NSLayoutAttribute firstAttribute;
@property (nonatomic, assign) NSLayoutRelation relation;
@property (nonatomic, weak  ) UIView *secondView;
@property (nonatomic, assign) NSLayoutAttribute secondAttribute;
@property (nonatomic, assign) CGFloat multiplier;
@property (nonatomic, assign) CGFloat constant;
@property (nonatomic, assign) UILayoutPriority priority;

@property (nonatomic, strong) NSString *layoutPosition;
@property (nonatomic, assign) BOOL deleteEexistingWhenUpdating;

+ (instancetype)constraintWithView:(UIView *)view layoutAttributes:(NSString *)attributes;
- (void)updateConstraintWithLayoutAttributes:(NSString *)attributes;

- (void)activate;
- (void)deactivate;

@end
