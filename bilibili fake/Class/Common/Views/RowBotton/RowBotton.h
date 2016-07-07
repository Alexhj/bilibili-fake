//
//  RowBotton.h
//  bilibili fake
//
//  Created by cxh on 16/7/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, RowBottonStyle) {
    RowBottonDefaultStyle
};

@interface RowBotton : UIView


- (instancetype)initWithTitles:(NSMutableArray<NSString *> *)titles  Block:(void(^)(NSInteger btnTag))block;

- (void)setTitles:(NSMutableArray<NSString *> *)titles;

- (void)setFont:(UIFont*)font;

- (void)setStyle:(RowBottonStyle)style;

@end
