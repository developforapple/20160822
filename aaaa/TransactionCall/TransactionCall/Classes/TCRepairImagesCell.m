//
//  TCRepairImagesCell.m
//  TransactionCall
//
//  Created by wwwbbat on 16/8/11.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "TCRepairImagesCell.h"
#import "SPMacro.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface TCRepairImagesCell () <UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@end

@implementation TCRepairImagesCell

- (void)setImages:(NSArray *)images
{
    _images = images;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCRepairImageCell" forIndexPath:indexPath];
    
    UIImageView *imageView = [cell viewWithTag:10086];
    imageView.image = self.images[indexPath.item];
    
    return cell;
}

#pragma mark - Empty
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                           NSForegroundColorAttributeName:RGBColor(153, 153, 153, 1)};
    return [[NSAttributedString alloc] initWithString:@"还没有添加图片" attributes:attr];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.images.count==0;
}

@end
