//
//  YMWaterFallLayout.h
//  YMWaterFallLayout
//
//  Created by 卢会旭 on 2018/3/26.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMWaterFallLayout;
@protocol YMWaterFallLayoutDelegate <NSObject>

@required
//必须实现的代理
- (CGFloat)waterFallLayout:(YMWaterFallLayout *)waterFallLayout heightForItemAtIndex:(NSUInteger)index width:(CGFloat)width;
@optional
//可选实现的代理
//返回瀑布流实现的列数
- (NSInteger)columnCountOfWaterFallLayout:(YMWaterFallLayout *)waterFallLayout;
//返回行间距
- (CGFloat)rowSpaceOfWaterFallLayout:(YMWaterFallLayout *)waterFallLayout;
//返回列间距
- (CGFloat)columnSpaceOfWaterFallLayout:(YMWaterFallLayout *)waterFallLayout;
//返回边缘间距
- (UIEdgeInsets)edgeInsetOfWaterFallLayout:(YMWaterFallLayout *)waterFallLayout;
@end
@interface YMWaterFallLayout : UICollectionViewLayout

//代理
@property(nonatomic,weak)id<YMWaterFallLayoutDelegate> delegate;
@end
