//
//  HomeViewController.m
//  bilibili fake
//
//  Created by 翟泉 on 16/6/22.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "HomeViewController.h"



// SubModules

#import "HomeHeaderView.h"

#import "HomeLiveView.h"
#import "HomeAnimationView.h"
#import "HomeChannelView.h"

#import "ScrollTabBarController.h"



@interface HomeViewController ()
<UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    HomeHeaderView *_headerView;
    
    UIScrollView *_scrollView;
    
    HomeLiveView *_liveView;
    HomeAnimationView *_animationView;
    HomeChannelView *_channelView;
}

@end

typedef NS_ENUM(APIType, HomeAPIType) {
    HomeAPIChannel,
};


@implementation HomeViewController

- (instancetype)init; {
    if (self = [super init]) {
        self.title = @"首页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadSubviews];
    
//    self addChildViewController:<#(nonnull UIViewController *)#>
    
}

- (void)viewWillAppear:(BOOL)animated; {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handlePan:(UIPanGestureRecognizer *)panGestureRecognizer {
    ScrollTabBarController *tabbar = (ScrollTabBarController *)self.tabBarController;
    [tabbar handlePanGesture:panGestureRecognizer];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView; {
    _headerView.contentOffset = scrollView.contentOffset.x / scrollView.contentSize.width;
}

#pragma mark - View


#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer; {
    if (_scrollView.contentOffset.x + _scrollView.frame.size.width < _scrollView.contentSize.width) {
        NSLog(@"111");
        return NO;
    }
    UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
    CGFloat translationX = [panGestureRecognizer translationInView:_scrollView].x;
    if (translationX >= 0) {
        NSLog(@"222");
        return NO;
    }
    return YES;
}


#pragma mark Subviews

- (void)loadSubviews {
    [self.view addSubview:UIView.new];
    
    // Header
    _headerView = [[HomeHeaderView alloc] initWithTitles:@[@"直播", @"番剧", @"分区"]];
    [self.view addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset = 20;
        make.height.equalTo(@44);
    }];
    
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor grayColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    [_scrollView addGestureRecognizer:panGestureRecognizer];
    
    
    // SubModules
    
    // 直播
    _liveView = [[HomeLiveView alloc] init];
    [_scrollView addSubview:_liveView];
    
    _animationView = [[HomeAnimationView alloc] init];
    [_scrollView addSubview:_animationView];
    
    // 分区
    _channelView = [[HomeChannelView alloc] init];
    [_scrollView addSubview:_channelView];
    
    
    
    
    // Layout
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(_headerView.mas_bottom);
        make.bottom.equalTo(@-49);
    }];
    
    [_liveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView);
        make.centerY.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
    }];
    [_animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_liveView.mas_right);
        make.centerY.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
    }];
    [_channelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_animationView.mas_right);
        make.centerY.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
        make.height.equalTo(_scrollView);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_channelView.mas_right);
    }];
    
}


@end
