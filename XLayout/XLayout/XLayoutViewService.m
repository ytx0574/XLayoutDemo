//
//  XLayoutViewService.m
//  XLayout
//
//  Created by B&W on 16/4/26.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import "XLayoutViewService.h"
#import "ONOXMLDocument.h"
#import "XLayoutBase.h"
#import "UIView+XLayout.h"
#import "UIView+XLayoutPrivate.h"
#import "UIColor+XLayout.h"
#import <objc/runtime.h>

NSString *const XLAYOUT_CONTROLLER_VIEW_ID = @"XLAYOUT_CONTROLLER_VIEW_ID";
NSString *const XLAYOUT_TABLE_VIEW_CELL_ID = @"XLAYOUT_TABLE_VIEW_CELL_ID";
NSString *const XLAYOUT_COLLECTION_VIEW_CELL_ID = @"XLAYOUT_COLLECTION_VIEW_CELL_ID";
NSString *const XLAYOUT_COLLECTION_REUSABLE_VIEW_ID = @"XLAYOUT_COLLECTION_REUSABLE_VIEW_ID";

@implementation UIView (XLayoutBase)

- (NSString *)layout_id {
    return objc_getAssociatedObject(self, _cmd);
}

- (id)layout {
    return objc_getAssociatedObject(self, _cmd);
}

- (XLayoutViewService *)viewService {
    return objc_getAssociatedObject(self, _cmd);
}

@end

@interface XLayoutViewService ()

@property (nonatomic, strong) NSURL *XMLURL;
@property (nonatomic, readwrite, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableDictionary *viewMap;
@property (nonatomic, readwrite, strong) id eventHandler;

@end

@implementation XLayoutViewService

#pragma mark - Init

+ (instancetype)serviceFromXMLName:(NSString *)name eventHandler:(id)eventHandler {
    NSAssert(name, @"The XML name cannot be empty");
    XLayoutViewService *service = [[XLayoutViewService alloc] init];
    service.eventHandler = eventHandler;
    NSString *extension = name.pathExtension.length > 0 ? name.pathExtension : @"xml";
    NSURL *URL = [[NSBundle mainBundle] URLForResource:[name stringByDeletingPathExtension] withExtension:extension];
    NSAssert1(URL, @"The XML name (%@) is invalid", name);
    service.XMLURL = URL;
    return service;
}

#pragma mark - Private

- (void)createView {
    NSError *error;
    NSString *pretreatment = [NSString stringWithContentsOfURL:self.XMLURL encoding:NSUTF8StringEncoding error:&error];
    NSAssert(!error, error.description);
    
    pretreatment = [pretreatment stringByReplacingOccurrencesOfString:@">=" withString:@"&gt;="];
    pretreatment = [pretreatment stringByReplacingOccurrencesOfString:@"<=" withString:@"&lt;="];
    
    NSData *data = [NSData dataWithData:[pretreatment dataUsingEncoding:NSUTF8StringEncoding]];
    
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:data error:&error];
    
    NSAssert(!error, error.description);
    
    [self createSubViewWithParent:nil XMLElementObject:document.rootElement];
}

- (void)createSubViewWithParent:(UIView *)parentView XMLElementObject:(ONOXMLElement *)element {
    id currentView;
    
    if ([element.tag isEqualToString:@"import"]) {
        NSString *import = [element valueForAttribute:@"name"];
        if (import) {
            XLayoutViewService *service = [XLayoutViewService serviceFromXMLName:import eventHandler:self.eventHandler];
            currentView = service.contentView;
            [service.viewMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [self.viewMap setObject:obj forKey:key];
                [obj privateSetViewService:self];
            }];
        }
    }else {
        currentView = [NSClassFromString(element.tag) viewWithXMLElementObject:element];
    }
    
    id layoutId = [element valueForAttribute:@"layout_id"];
    
    if (layoutId) {
        [currentView privateSetLayout_id:layoutId];
        [self.viewMap setObject:currentView forKey:layoutId];
    }else {
        if (![element.tag isEqualToString:@"import"]) {
            [self.viewMap setObject:currentView forKey:element];
        }
    }
    
    id layout = nil;
    
    if ([[element.attributes allKeys] containsObject:@"layout_class"]) {
        NSString *className = [element.attributes objectForKey:@"layout_class"];
        NSAssert(className, @"The class name cannot be empty");
        
        layout = [[NSClassFromString(className) alloc] initWithView:currentView];
    }else {
        if (![[currentView layout] validity]) {
            layout = [[XLayoutBase alloc] initWithView:currentView];
        }
    }
    
    if (self.eventHandler) {
        [currentView setPrivateEventHandler:self.eventHandler];
    }
    if (parentView) {
        [parentView addSubview:currentView];
    }else {
        _contentView = currentView;
    }
    if (![[currentView layout] validity]) {
        [currentView privateSetLayout:layout];
    }
    [currentView privateSetViewService:self];
    [currentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [element.attributes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *initial = [[key substringToIndex:1] uppercaseString];
        NSString *remanent = [key substringFromIndex:1];
        NSString *methodName = [NSString stringWithFormat:@"set%@%@:",initial,remanent];
        
        id target = nil;
        
        if ([currentView respondsToSelector:NSSelectorFromString(methodName)]) {
            target = currentView;
        }else if ([layout respondsToSelector:NSSelectorFromString(methodName)]) {
            target = layout;
        }else {
            methodName = [key stringByAppendingString:@":"];
            if ([currentView respondsToSelector:NSSelectorFromString(methodName)]){
                target = currentView;
            }
        }
        if (target) {
            [self invocationWithTarget:target methodName:methodName argumentsObject:obj];
        }else {
            if (![key isEqualToString:@"layout_id"] && !([key isEqualToString:@"name"] && [element.tag isEqualToString:@"import"])) {
                [NSException raise:@"Parse attribute error" format:@"Cannot parse attribute %@",key];
            }
        }
    }];
    
    for (ONOXMLElement *subElement in element.children) {
        [self createSubViewWithParent:currentView XMLElementObject:subElement];
    }
}

- (void)invocationWithTarget:(id)target methodName:(NSString *)methodName argumentsObject:(id)argumentsObject {
    SEL selector = NSSelectorFromString(methodName);
    
    NSMethodSignature *signature = [[target class] instanceMethodSignatureForSelector:NSSelectorFromString(methodName)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:argumentsObject];
    
    const char *type = [signature getArgumentTypeAtIndex:2];
    
    if (strcmp(type, "c") == 0) {
        char arguments = [number charValue];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "i") == 0) {
        CGFloat arguments = [number intValue];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "s") == 0) {
        CGFloat arguments = [number shortValue];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "l") == 0) {
        long arguments = [number longValue];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "q") == 0) {
        long long arguments = [number longLongValue];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "C") == 0) {
        unsigned char arguments = [number unsignedCharValue];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "I") == 0) {
        unsigned int arguments = [number unsignedIntValue];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "S") == 0) {
        unsigned short arguments = [number unsignedShortValue];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "L") == 0) {
        unsigned long arguments = [number unsignedLongValue];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "Q") == 0) {
        unsigned long long arguments = [number unsignedLongLongValue];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "f") == 0) {
        float arguments = [number floatValue];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "d") == 0) {
        double arguments = [number doubleValue];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "B") == 0) {
        BOOL arguments = [argumentsObject boolValue];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "*") == 0) {
        const char *arguments = [argumentsObject UTF8String];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "#") == 0) {
        Class arguments = NSClassFromString(argumentsObject);
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, ":") == 0) {
        SEL arguments = NSSelectorFromString(argumentsObject);
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "f") == 0) {
        float arguments = [number floatValue];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "@") == 0) {
        id arguments;
        [self transformationParameterTypeWithArguments:argumentsObject output:&arguments];
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "{CGPoint=dd}") == 0) {
        CGPoint arguments = CGPointFromString(argumentsObject);
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "{CGSize=dd}") == 0) {
        CGSize arguments = CGSizeFromString(argumentsObject);
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "{UIEdgeInsets=dddd}") == 0) {
        UIEdgeInsets arguments = UIEdgeInsetsFromString(argumentsObject);
        [invocation setArgument:&arguments atIndex:2];
    }else if (strcmp(type, "{CGRect=dddd}") == 0) {
        CGRect arguments = CGRectFromString(argumentsObject);
        [invocation setArgument:&arguments atIndex:2];
    }
    
    [invocation setSelector:selector];
    [invocation setTarget:target];
    [invocation invoke];
}

- (void)transformationParameterTypeWithArguments:(id)arguments output:(id *)output {
    NSRange type = [arguments rangeOfString:@"^@color:" options:NSRegularExpressionSearch];
    
    id(^getValue)(NSRange r) = ^(NSRange r){
        NSUInteger location = r.location + r.length;
        NSString *value = [arguments substringFromIndex:location];
        return value;
    };
    
    if (type.location != NSNotFound && type.length != 0) {
        UIColor *arguments = [UIColor colorWithHexString:getValue(type)];
        *output = arguments;
        return;
    }
    
    type = [arguments rangeOfString:@"^@img:" options:NSRegularExpressionSearch];
    if (type.location != NSNotFound && type.length != 0) {
        UIImage *arguments = [UIImage imageNamed:getValue(type)];
        *output = arguments;
        return;
    }
    
    type = [arguments rangeOfString:@"^@quote:" options:NSRegularExpressionSearch];
    if (type.location != NSNotFound && type.length != 0) {
        SEL sel = NSSelectorFromString(getValue(type));
        if ([self respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id arguments = [self performSelector:sel];
            *output = arguments;
            return;
#pragma clang diagnostic pop
        }
    }
    
    type = [arguments rangeOfString:@"^(@font:)\\w+:\\d+$" options:NSRegularExpressionSearch];
    if (type.location != NSNotFound && type.length != 0) {
        
        NSRange r = [arguments rangeOfString:@"\\w+:\\d+$" options:NSRegularExpressionSearch];
        NSString *fontAttribute = [arguments substringWithRange:r];
        r = [fontAttribute rangeOfString:@":"];
        
        NSString *fontName = [fontAttribute substringToIndex:r.location];
        CGFloat fontSize = [[fontAttribute substringFromIndex:(r.location + r.length)] floatValue];
        
        UIFont *font = nil;
        if ([fontName isEqualToString:@"default"]) {
            font = [UIFont systemFontOfSize:fontSize];
        }else if ([fontName isEqualToString:@"bold"]) {
            font = [UIFont boldSystemFontOfSize:fontSize];
        }else {
            font = [UIFont fontWithName:fontName size:fontSize];
        }
        
        *output = font;
        return;
    }
    
    *output = arguments;
}

- (void)activateLayout {
    [self.viewMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [[obj layout] activate];
    }];
}

#pragma mark - Public

- (id(^)(NSString *layoutId))getViewById {
    return ^(NSString *layoutId){
        return [self.viewMap objectForKey:layoutId];
    };
}

#pragma mark - Getter / Setter

- (UIView *)contentView {
    if (!_contentView) {
        [self createView];
    }
    return _contentView;
}

- (NSMutableDictionary *)viewMap {
    if (!_viewMap) {
        _viewMap = [[NSMutableDictionary alloc] init];
    }
    return _viewMap;
}


@end

