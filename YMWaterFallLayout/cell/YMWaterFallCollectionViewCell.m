//
//  YMWaterFallCollectionViewCell.m
//  YMWaterFallLayout
//
//  Created by 卢会旭 on 2018/3/26.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import "YMWaterFallCollectionViewCell.h"

@implementation YMWaterFallCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(ShopInfoModel *)model {
    _model = model;
    [self.shopImageV sd_setImageWithURL:[NSURL URLWithString:_model.img]];
    self.price.text = _model.price;
}
@end
