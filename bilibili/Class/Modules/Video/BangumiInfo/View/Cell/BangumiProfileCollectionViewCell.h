//
//  BangumiProfileCollectionViewCell.h
//  bilibili fake
//
//  Created by 翟泉 on 2016/9/22.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BangumiInfoEntity.h"

/**
 *  简介
 */
@interface BangumiProfileCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) BangumiInfoEntity *bangumiInfo;

+ (NSString *)Identifier;

+ (CGSize)sizeForWidth:(CGFloat)width bangumiInfo:(BangumiInfoEntity *)bangumiInfo;

@end
