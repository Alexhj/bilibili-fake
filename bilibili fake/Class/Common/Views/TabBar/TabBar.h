//
//  TabBar.h
//  bilibili fake
//
//  Created by 翟泉 on 2016/7/5.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TabBarStyle) {
    TabBarStyleScroll
};

@interface TabBar : UIView

@property (assign, nonatomic, readonly) NSInteger currentIndex;

@property (assign, nonatomic) TabBarStyle style;

/**
 *  0.0 ~ 1.0
 */
@property (assign, nonatomic) CGFloat contentOffset;

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles;

@end
