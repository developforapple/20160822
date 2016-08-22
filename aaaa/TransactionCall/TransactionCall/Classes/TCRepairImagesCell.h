//
//  TCRepairImagesCell.h
//  TransactionCall
//
//  Created by wwwbbat on 16/8/11.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCRepairImagesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (strong, nonatomic) NSArray *images;

@end
