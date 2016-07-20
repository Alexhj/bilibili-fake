//
//  VideoAndStatInfoCollectionViewCell.h
//  bilibili fake
//
//  Created by 翟泉 on 2016/7/19.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoInfoEntity.h"

/**
 *  简介-视频信息、统计信息
 */
@interface VideoAndStatInfoCollectionViewCell : UICollectionViewCell

+ (CGSize)sizeForVideoInfo:(VideoInfoEntity *)videoInfo;

@end
