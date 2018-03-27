//
//  ViewController.m
//  YMWaterFallLayout
//
//  Created by 卢会旭 on 2018/3/26.
//  Copyright © 2018年 卢会旭. All rights reserved.
//

#import "ViewController.h"
#import "YMWaterFallLayout.h"
#import "YMWaterFallCollectionViewCell.h"
#import "ShopInfoModel.h"
#import "MJRefresh.h"
static NSString *shopCellIdentifier = @"YMWaterFallCell";
@interface ViewController ()<YMWaterFallLayoutDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,weak)UICollectionView *collectionView;
@end

@implementation ViewController
-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   __block NSInteger page = 0; //默认第一页
    YMWaterFallLayout *layout = [[YMWaterFallLayout alloc] init];
    layout.delegate = self;
    //初始化collectionView
    UICollectionView * _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    _collectionV.dataSource = self;
    _collectionV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionV];
    self.collectionView = _collectionV;
    //注册单元格
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YMWaterFallCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:shopCellIdentifier];
    
    //头部刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //延迟调用，模拟网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            page = 0;
            [self.dataSource removeAllObjects];
            //获取数据
            [self dataSourceWithPage:page];

            //刷新数据
            [self.collectionView reloadData];

            //停止刷新
            [self.collectionView.mj_header endRefreshing];
        });

    }];


    //第一次进入自动加载
    [self.collectionView.mj_header beginRefreshing];

    //尾部刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 if (page == 3) {
                     page = 0;
                 }else {
                    page ++;
                 }
                //获取数据
                [self dataSourceWithPage:page];

                //刷新数据
                [self.collectionView reloadData];

                //停止刷新
                [self.collectionView.mj_footer endRefreshing];
        });
    }];

}
#pragma mark---UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YMWaterFallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.item];
    return cell;
}
#pragma mark ---- YMWaterFallLayoutDelegate
- (CGFloat)waterFallLayout:(YMWaterFallLayout *)waterFallLayout heightForItemAtIndex:(NSUInteger)index width:(CGFloat)width {
    ShopInfoModel *model = self.dataSource[index];
    CGFloat height = [model.h doubleValue]/[model.w doubleValue] * width;
    return height;
}
- (void)dataSourceWithPage:(NSInteger)page {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld.plist",page] ofType:nil];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dic in arr) {
        ShopInfoModel *model = [[ShopInfoModel alloc] init];
        model.price = dic[@"price"];
        model.img = dic[@"img"];
        model.w = dic[@"w"];
        model.h = dic[@"h"];
        [self.dataSource addObject:model];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
