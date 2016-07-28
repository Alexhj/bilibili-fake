//
//  TabBar.m
//  bilibili fake
//
//  Created by 翟泉 on 2016/7/5.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "TabBar.h"

@interface TabBar ()
{
    NSMutableArray<UIButton *> *_items;
    UIView *_bottomLineView;
    
    NSInteger _index;
    
    NSArray<NSNumber *> *_tintColorRGB;
}

@property (assign, nonatomic, readonly) NSInteger cR;
@property (assign, nonatomic, readonly) NSInteger cG;
@property (assign, nonatomic, readonly) NSInteger cB;

@end

@implementation TabBar

@dynamic tintColorRGB;

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles; {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _items = [NSMutableArray arrayWithCapacity:titles.count];
        
        [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:obj forState:UIControlStateNormal];
            if (idx == _index) {
                [button setTitleColor:ColorRGB(self.cR,self.cG,self.cB) forState:UIControlStateNormal];
            }
            else {
                [button setTitleColor:ColorWhite(200) forState:UIControlStateNormal];
            }
            button.titleLabel.font = Font(14);
            button.tag = idx;
            [button addTarget:self action:@selector(onClickItem:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [_items addObject:button];
        }];
        
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = ColorRGB(self.cR,self.cG,self.cB);
        [self addSubview:_bottomLineView];
        
    }
    return self;
}

- (void)onClickItem:(UIButton *)button {
    _onClickItem ? _onClickItem(button.tag) : NULL;
}

- (NSInteger)currentIndex; {
    return _index;
}

- (void)setContentOffset:(CGFloat)contentOffset; {
    
    CGFloat offsetX = (self.width-_edgeInsets.left-_edgeInsets.right + self.spacing) * contentOffset;
    
    _bottomLineView.x =  _edgeInsets.left + offsetX;
    
    CGFloat itemWidth = (self.bounds.size.width - _edgeInsets.left - _edgeInsets.right + self.spacing) / _items.count;
    
    NSInteger index = (NSInteger)(offsetX / itemWidth);
    
    
    CGFloat bottomOffsetX = offsetX - index * itemWidth;
    
    
    
    if (bottomOffsetX > 0) {
        CGFloat progress = bottomOffsetX / itemWidth;
        [_items[index] setTitleColor:ColorRGB(self.cR - (self.cR-200)*progress, self.cG - (self.cG-200)*progress, self.cB - (self.cB-200)*progress) forState:UIControlStateNormal];
        [_items[index+1] setTitleColor:ColorRGB(200 + (self.cR-200)*progress, 200 + (self.cG-200)*progress, 200 + (self.cB-200)*progress) forState:UIControlStateNormal];
        
    }
    else if (bottomOffsetX < 0) {
        CGFloat progress = 1 - (bottomOffsetX) / itemWidth;
        [_items[_index] setTitleColor:ColorRGB(self.cR - (self.cR-200)*progress, self.cG - (self.cG-200)*progress, self.cB - (self.cB-200)*progress) forState:UIControlStateNormal];
        [_items[index] setTitleColor:ColorRGB(200 + (self.cR-200)*progress, 200 + (self.cG-200)*progress, 200 + (self.cB-200)*progress) forState:UIControlStateNormal];
    }
    else {
        if (_index != index) {
            [_items[_index] setTitleColor:ColorWhite(200) forState:UIControlStateNormal];
            [_items[index] setTitleColor:ColorRGB(self.cR,self.cG,self.cB) forState:UIControlStateNormal];
            _index = index;
        }
    }
    
    
}

- (void)setTitle:(NSString *)title forIndex:(NSInteger)index; {
    [_items[index] setTitle:title forState:UIControlStateNormal];
}



- (void)selectedItem:(UIButton *)itemButton; {
    [self.delegate tabBar:self didSelectIndex:itemButton.tag];
}

- (void)layoutSubviews; {
    
    CGFloat itemWidth = (self.bounds.size.width - _edgeInsets.left - _edgeInsets.right - self.spacing * (_items.count-1)) / _items.count;
    [_items enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(_edgeInsets.left + itemWidth * idx + self.spacing * idx, _edgeInsets.top, itemWidth, self.bounds.size.height-_edgeInsets.top-_edgeInsets.bottom);
    }];
    
    _bottomLineView.frame = CGRectMake(_items[_index].x, self.height-2 - _edgeInsets.bottom, _items[_index].width, 2);
    
    [super layoutSubviews];
}


- (void)setTintColorRGB:(NSArray<NSNumber *> *)tintColorRGB {
    _tintColorRGB = [tintColorRGB mutableCopy];
    [_items enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == _index) {
            [obj setTitleColor:ColorRGB(self.cR,self.cG,self.cB) forState:UIControlStateNormal];
        }
        else {
            [obj setTitleColor:ColorWhite(200) forState:UIControlStateNormal];
        }
    }];
    _bottomLineView.backgroundColor = ColorRGB(self.cR,self.cG,self.cB);
}

- (NSArray<NSNumber *> *)tintColorRGB {
    if (!_tintColorRGB) {
        _tintColorRGB = @[@253,@129,@164];
    }
    return _tintColorRGB;
}

- (NSInteger)cR {
    return [self.tintColorRGB[0] integerValue];
}
- (NSInteger)cG {
    return [self.tintColorRGB[1] integerValue];
}
- (NSInteger)cB {
    return [self.tintColorRGB[2] integerValue];
}

@end
