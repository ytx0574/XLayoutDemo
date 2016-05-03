//
//  UICollectionView+XLayout.m
//  XLayout
//
//  Created by B&W on 16/4/29.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import "UICollectionView+XLayout.h"
#import <objc/runtime.h>
#import "UIView+XLayoutPrivate.h"

@implementation UICollectionView (XLayout)

+ (instancetype)viewWithXMLElementObject:(id)element {
    return [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
}

- (void)setPrivateEventHandler:(id)privateEventHandler {
    self.dataSource = privateEventHandler;
    self.delegate = privateEventHandler;
    objc_setAssociatedObject(self, @selector(privateEventHandler), privateEventHandler, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setMinimumLineSpacing:(NSString *)minimumLineSpacing {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.minimumLineSpacing = [minimumLineSpacing floatValue];
    objc_setAssociatedObject(self, @selector(minimumLineSpacing), minimumLineSpacing, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)minimumLineSpacing {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMinimumInteritemSpacing:(NSString *)minimumInteritemSpacing {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.minimumInteritemSpacing = [minimumInteritemSpacing floatValue];
    objc_setAssociatedObject(self, @selector(minimumInteritemSpacing), minimumInteritemSpacing, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)minimumInteritemSpacing {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setItemSize:(NSString *)itemSize {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeFromString(itemSize);
    objc_setAssociatedObject(self, @selector(itemSize), itemSize, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)itemSize {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setScrollDirection:(NSString *)scrollDirection {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    UICollectionViewScrollDirection direction = UICollectionViewScrollDirectionVertical;
    if ([scrollDirection isEqualToString:@"horizontal"]) {
        direction = UICollectionViewScrollDirectionHorizontal;
    }
    layout.scrollDirection = direction;
    objc_setAssociatedObject(self, @selector(scrollDirection), scrollDirection, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)scrollDirection {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHeaderReferenceSize:(NSString *)headerReferenceSize {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.headerReferenceSize = CGSizeFromString(headerReferenceSize);
    objc_setAssociatedObject(self, @selector(headerReferenceSize), headerReferenceSize, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)headerReferenceSize {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFooterReferenceSize:(NSString *)footerReferenceSize {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.footerReferenceSize = CGSizeFromString(footerReferenceSize);
    objc_setAssociatedObject(self, @selector(footerReferenceSize), footerReferenceSize, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)footerReferenceSize {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSectionInset:(NSString *)sectionInset {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsFromString(sectionInset);
    objc_setAssociatedObject(self, @selector(footerReferenceSize), sectionInset, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)sectionInset {
    return objc_getAssociatedObject(self, _cmd);
}



@end
