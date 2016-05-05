//
//  XLayoutConstraintPrivate.m
//  XLayout
//
//  Created by B&W on 16/4/27.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import "XLayoutConstraintPrivate.h"
#import "XLayoutViewService.h"
#import "NSLayoutConstraint+XLayoutPrivate.h"

@interface XLayoutConstraintPrivate ()

@property (nonatomic, copy) NSString *layoutAttribute;
@property (nonatomic, strong) NSMutableArray *constraint;

@end

@implementation XLayoutConstraintPrivate

#pragma mark - Init

+ (instancetype)constraintWithView:(UIView *)view layoutAttributes:(NSString *)attributes {
    XLayoutConstraintPrivate *constraint = [[XLayoutConstraintPrivate alloc] init];
    constraint.firstView = view;
    constraint.layoutAttribute = attributes;
    return constraint;
}

#pragma mark - Private

- (void)updateOrNew {
    if (self.secondView && self.secondAttribute == NSLayoutAttributeNotAnAttribute) {
        self.secondAttribute = self.firstAttribute;
    }else if (self.secondAttribute != NSLayoutAttributeNotAnAttribute && !self.secondView) {
        self.secondView = self.firstView.superview;
    }else if (self.secondAttribute == NSLayoutAttributeNotAnAttribute && !self.secondView && self.multiplier != 1.0) {
        self.secondAttribute = self.firstAttribute;
        self.secondView = self.firstView.superview;
    }
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"firstItem == %@ and firstAttribute == %d and relation == %d and secondItem == %@ and secondAttribute == %d and multiplier == %f",self.firstView,self.firstAttribute,self.relation,self.secondView,self.secondAttribute,self.multiplier];
    
    NSLayoutConstraint *constraint = [[self.constraint filteredArrayUsingPredicate:pre] firstObject];
    
    if (constraint) {
        if (self.relation != constraint.relation || self.multiplier != constraint.multiplier || ![self.secondView isEqual:constraint.secondItem]) {
            [self createNewConstraint];
        }else {
            if (self.priority != constraint.priority) {
                constraint.priority = self.priority;
            }
            if (self.constant != constraint.constant) {
                constraint.constant = self.constant;
            }
            [constraint setLayoutAttribute:self.layoutAttribute];
        }
    }else {
        [self createNewConstraint];
    }
}

- (void)createNewConstraint {
    if (self.deleteEexistingWhenUpdating) {
        [self deactivate];
    }
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.firstView attribute:self.firstAttribute relatedBy:self.relation toItem:self.secondView attribute:self.secondAttribute multiplier:self.multiplier constant:self.constant];
    [constraint setPriority:self.priority];
    [constraint setLayoutPosition:self.layoutPosition];
    [constraint setLayoutAttribute:self.layoutAttribute];
    if ([self.firstView isEqual:self.firstView.viewService.contentView]) {
        [self.firstView.viewService.contentView.superview addConstraint:constraint];
    }else {
        [self.firstView.viewService.contentView addConstraint:constraint];
    }
    [self.constraint addObject:constraint];
}

- (void)updateConstraintWithLayoutAttributes:(NSString *)attributes immediately:(BOOL)immediately {
    NSAssert(attributes, @"The attributes cannot be empty");
    
    NSString *layoutId = nil;
    
    UIView *secondView = nil;
    CGFloat constant = 0.0;
    CGFloat multiplier = 1.0f;
    NSLayoutRelation relation = NSLayoutRelationEqual;
    UILayoutPriority priority = UILayoutPriorityRequired;
    
    NSRange layoutIdRange = [attributes rangeOfString:@":\\w+[:*@\\w]" options:NSRegularExpressionSearch];
    NSRange relationRange = [attributes rangeOfString:@"[><]=" options:NSRegularExpressionSearch];
    NSRange constantRange = [attributes rangeOfString:@".?-?\\d+\\.?\\d*[^\\D]?" options:NSRegularExpressionSearch];
    NSRange multiplierRange = [attributes rangeOfString:@"\\*-?\\d+.?\\d*[^\\D]?" options:NSRegularExpressionSearch];
    NSRange priorityRange = [attributes rangeOfString:@"\\@-?\\d+\\.?\\d*" options:NSRegularExpressionSearch];
    
    if (layoutIdRange.location != NSNotFound  && layoutIdRange.length != 0) {
        
        layoutId = [attributes substringWithRange:layoutIdRange];
        layoutId = [layoutId stringByReplacingOccurrencesOfString:@"[:*@]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, layoutId.length)];
    }
    
    if (relationRange.location != NSNotFound && relationRange.length != 0) {
        NSString *relationString = [attributes substringWithRange:relationRange];
        if ([relationString isEqualToString:@">="]) {
            relation = NSLayoutRelationGreaterThanOrEqual;
        }else if ([relationString isEqualToString:@"<="]) {
            relation = NSLayoutRelationLessThanOrEqual;
        }
    }
    
    if (constantRange.location != NSNotFound && constantRange.length != 0) {
        NSString *constantString = [attributes substringWithRange:constantRange];
        constantRange = [constantString rangeOfString:@"^[:=\\d-]" options:NSRegularExpressionSearch];
        if (constantRange.location != NSNotFound && constantRange.length != 0) {
            if ([constantString hasPrefix:@":"] || [constantString hasPrefix:@"="]) {
                constantRange.location += constantRange.length;
            }
            constantString = [constantString substringFromIndex:constantRange.location];
            
            constant = [constantString doubleValue];
        }
    }
    
    if (multiplierRange.location != NSNotFound && multiplierRange.length != 0) {
        multiplierRange.location += 1;
        NSString *multiplierString = [attributes substringFromIndex:multiplierRange.location];
        
        multiplier = [multiplierString doubleValue];
    }
    
    if (priorityRange.location != NSNotFound  && priorityRange.length != 0) {
        priorityRange.location += 1;
        NSString *priorityString = [attributes substringFromIndex:priorityRange.location];
        
        priority = [priorityString doubleValue];
    }
    
    if (layoutId) {
        secondView = self.firstView.viewService.getViewById(layoutId);
        NSAssert1(secondView, @"Failed to get associated view by id (%@)",layoutId);
    }
    
    self.layoutAttribute = attributes;
    
    self.secondView = secondView;
    self.constant   = constant;
    self.multiplier = multiplier;
    self.relation   = relation;
    self.priority   = priority;
    
    if (immediately) {
        [self updateOrNew];
    }
}

#pragma mark - Public

- (void)updateConstraintWithLayoutAttributes:(NSString *)attributes {
    [self updateConstraintWithLayoutAttributes:attributes immediately:YES];
}

- (void)activate {
    [self updateConstraintWithLayoutAttributes:self.layoutAttribute immediately:YES];
}

- (void)deactivate {
    [self.firstView.viewService.contentView removeConstraints:self.constraint];
}

#pragma mark - Getter / Setter

- (NSMutableArray *)constraint {
    if (!_constraint) {
        _constraint = [[NSMutableArray alloc] init];
    }
    return _constraint;
}

@end
