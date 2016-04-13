//
//  FNNewsADCell.m
//  FourNews
//
//  Created by xmg on 16/3/28.
//  Copyright © 2016年 天涯海北. All rights reserved.
//

#import "FNNewsADCell.h"
#import <UIImageView+WebCache.h>
#import "FNNewsADsItem.h"
#import <MJExtension.h>

@interface FNNewsADCell() <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *ADLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *ADPage;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSArray<FNNewsADsItem *> *adItemArray;

@end

static NSString * const ADCollecID = @"newsAD";

@implementation FNNewsADCell

- (NSArray *)adItemArray
{
    if (!_adItemArray){
        self.adItemArray = [[NSArray alloc] init];
    }
    return _adItemArray;
    
}
#pragma mark - setter方法数据入口
- (void)setContItem:(FNNewsListItem *)contItem
{
    _contItem = contItem;
    if (contItem.ads == nil)return;
    NSArray *adItemArray = [FNNewsADsItem mj_objectArrayWithKeyValuesArray:contItem.ads];

    self.adItemArray = adItemArray;
    [self setADCollecView];
    
    self.ADLabel.text = self.adItemArray[0].title;
    
    self.ADLabel.textColor = [UIColor whiteColor];
    self.ADLabel.font = [UIFont systemFontOfSize:14];
    
    
    self.ADPage.numberOfPages = self.adItemArray.count;
    self.ADPage.currentPage = 0;
}
#pragma mark - 广告collectionView
- (void)setADCollecView
{
    UICollectionViewFlowLayout *layout = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = 0;
        
        layout.itemSize = CGSizeMake(FNScreenW, FNADCellHeight);
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        layout;
    });
    
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, FNScreenW, FNADCellHeight) collectionViewLayout:layout];
    
    
    collectionV.backgroundColor = [UIColor orangeColor];
    
    collectionV.pagingEnabled = YES;
    collectionV.scrollEnabled = YES;
    collectionV.dataSource = self;
    collectionV.delegate = self;
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.showsVerticalScrollIndicator = NO;
    collectionV.scrollsToTop = NO;
    
    [self.contentView addSubview:collectionV];
    
    [self.contentView sendSubviewToBack:collectionV];
//    collectionV.userInteractionEnabled = NO;
    [collectionV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ADCollecID];
    
    [collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:5000 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ADCollecID forIndexPath:indexPath];
    UIImageView *ADImageV = [[UIImageView alloc] init];
    ADImageV.userInteractionEnabled = YES;
    
    [ADImageV sd_setImageWithURL:[NSURL URLWithString:self.adItemArray[indexPath.row%self.adItemArray.count].imgsrc] placeholderImage:[UIImage imageNamed:@"newsTitleImage"]];
//    self.frame = CGRectMake(0, 0, FNScreenW, self.height);
    ADImageV.frame = cell.bounds;
    
    [cell.contentView addSubview:ADImageV];
    
    
    
    return cell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger indexPage = self.indexPath.row%self.adItemArray.count;
    
    self.ADLabel.text = self.adItemArray[indexPage].title;
    
    self.ADPage.currentPage = indexPage;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
