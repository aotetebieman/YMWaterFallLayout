//
//  YMWaterFallLayout.m
//  YMWaterFallLayout
//
//  Created by 卢会旭 on 2018/3/26.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import "YMWaterFallLayout.h"
//默认的列数
static const CGFloat     DefaultColunmCount = 3;
//默认的行间距
static const CGFloat        DefaultRowSpace = 10;
//默认的列间距
static const CGFloat        DefaultColumnSpace = 10;
//默认的边缘间距
static const UIEdgeInsets   DefaultEdgeInsets = {10, 10, 10, 10};

@interface YMWaterFallLayout() {
    struct{
        BOOL DidRespondsColumnCount : 1;
        BOOL DidRespondsColumnSpace : 1;
        BOOL DidRespondsRowSpace : 1;
        BOOL DidRespondsEdgeInsets : 1;
    }delegateFlag;
}
//储存每列高度的数组
@property(nonatomic,strong)NSMutableArray *columnHeight;
//储存所有attributes的数据
@property(nonatomic,strong)NSMutableArray *attributes;
//最大的Y坐标
@property(nonatomic,assign)CGFloat MaxY;
@end
@implementation YMWaterFallLayout
- (NSMutableArray *)columnHeight {
    if (_columnHeight == nil) {
        _columnHeight = [NSMutableArray new];
    }
    return _columnHeight;
}
-(NSMutableArray *)attributes {
    if (_attributes == nil) {
        _attributes = [NSMutableArray new];
    }
    return _attributes;
}
//准备布局
-(void)prepareLayout {
    [super prepareLayout];
    
    //初始化列最大高度的数组
    [self setUpColumnHeightArray];
    
    //初始化所有元素属性数组
    [self setUpAttributesArray];
    
    //设置代理方法标志
    [self setUpDelegateFlag];
    
    //计算最大Y值坐标
    self.MaxY = [self MaxYWithColumnHeightArrar:self.columnHeight];
}

//返回Rect范围内所有的元素属性的布局数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributes;
}

//返回indexPath位置对应的itme布局属性
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //collection的宽
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    //item的宽
    CGFloat width = (collectionViewWidth - [self edgeInsets].left - [self edgeInsets].right - ([self columnCount] - 1) * [self columnSpace])/[self columnCount];
    //计算当前item应该排在第几列
    __block NSInteger column = 0; //默认第0列
    __block CGFloat minHeight = MAXFLOAT;
    [self.columnHeight enumerateObjectsUsingBlock:^(NSNumber  *_Nonnull heightNumber, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (minHeight > [heightNumber doubleValue]) {
            minHeight = [heightNumber doubleValue];
            column = idx;
        }
    }];
    //item的X坐标
    CGFloat x = [self edgeInsets].left + column * ([self columnSpace] + width);
    //item的高
    CGFloat height = [self.delegate waterFallLayout:self heightForItemAtIndex:indexPath.item width:width];
    //item的Y坐标
    CGFloat y = minHeight + [self rowSpace];
    //更新item 的frame
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.frame = CGRectMake(x, y, width, height);
    
    //更新数组中最短列的高度
    self.columnHeight[column] = @(y + height);
    return attribute;
}

//返回collectionview的滚动视图大小
- (CGSize)collectionViewContentSize {
    
    return CGSizeMake(0, self.MaxY + [self edgeInsets].bottom);
}

//初始化列最大高度的数组
- (void)setUpColumnHeightArray {
    
    //清空列最大高度数组
    [self.columnHeight removeAllObjects];
    
    //重新初始化
    for (int i = 0; i < [self columnCount]; i++) {
        [self.columnHeight addObject:@([self edgeInsets].top)];
    }
}
//初始化所有元素属性数组
- (void)setUpAttributesArray {
    
    //清空数据
    [self.attributes removeAllObjects];
    
    //重新初始化
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        @autoreleasepool {
            // 如果item数目过大容易造成内存峰值提高
            UICollectionViewLayoutAttributes *attri = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [self.attributes addObject:attri];
        }
    }
}
- (CGFloat)MaxYWithColumnHeightArrar:(NSArray *)array {
    __block CGFloat max = 0;
    [array enumerateObjectsUsingBlock:^(NSNumber *_Nonnull number, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([number doubleValue] > max) {
            max = [number doubleValue];
        }
    }];
    return max;
}
- (void)setUpDelegateFlag {
    delegateFlag.DidRespondsColumnCount = [self.delegate respondsToSelector:@selector(columnCountOfWaterFallLayout:)];
    delegateFlag.DidRespondsRowSpace = [self.delegate respondsToSelector:@selector(rowSpaceOfWaterFallLayout:)];
    delegateFlag.DidRespondsColumnSpace = [self.delegate respondsToSelector:@selector(columnSpaceOfWaterFallLayout:)];
    delegateFlag.DidRespondsEdgeInsets = [self.delegate respondsToSelector:@selector(edgeInsetOfWaterFallLayout:)];
}
//返回列数
- (NSUInteger)columnCount {
    
    return delegateFlag.DidRespondsColumnCount?[self.delegate columnCountOfWaterFallLayout:self]:DefaultColunmCount;
}

//返回行间距
- (CGFloat)rowSpace {
    
    return delegateFlag.DidRespondsRowSpace?[self.delegate rowSpaceOfWaterFallLayout:self]:DefaultRowSpace;
}

//返回列间距
- (CGFloat)columnSpace {
    
    return delegateFlag.DidRespondsColumnSpace?[self.delegate columnSpaceOfWaterFallLayout:self]:DefaultColumnSpace;
}

//返回边缘间距
- (UIEdgeInsets)edgeInsets {
    
    return delegateFlag.DidRespondsEdgeInsets?[self.delegate edgeInsetOfWaterFallLayout:self]:DefaultEdgeInsets;
}
@end
