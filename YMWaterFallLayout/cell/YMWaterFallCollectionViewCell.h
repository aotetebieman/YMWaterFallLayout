//
//  YMWaterFallCollectionViewCell.h
//  YMWaterFallLayout
//
//  Created by 卢会旭 on 2018/3/26.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopInfoModel.h"
#import "UIImageView+WebCache.h"
@interface YMWaterFallCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopImageV;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property(nonatomic,copy)ShopInfoModel *model;
@end
