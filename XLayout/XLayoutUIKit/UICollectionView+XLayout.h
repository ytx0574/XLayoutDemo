//
//  UICollectionView+XLayout.h
//  XLayout
//
//  Created by B&W on 16/4/29.
//  Copyright © 2016年 B&W. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 以下属性同UICollectionViewFlowLayout里的属性,这里定义是为了方便在xml里边直接指定
@interface UICollectionView (XLayout)

@property (nonatomic, copy) NSString *minimumLineSpacing;
@property (nonatomic, copy) NSString *minimumInteritemSpacing;
/// 这个属性由CGSizeFromString转化,格式需满足{width,height}
@property (nonatomic, copy) NSString *itemSize;
/// horizontal 或者 vertical 默认为vertical
@property (nonatomic, copy) NSString *scrollDirection;
/// 这个属性由CGSizeFromString转化,格式需满足{width,height}
@property (nonatomic, copy) NSString *headerReferenceSize;
/// 这个属性由CGSizeFromString转化,格式需满足{width,height}
@property (nonatomic, copy) NSString *footerReferenceSize;
/// 这个属性由UIEdgeInsetsFromString转化,格式需满足{top, left, bottom, right}
@property (nonatomic, copy) NSString *sectionInset;

@end
