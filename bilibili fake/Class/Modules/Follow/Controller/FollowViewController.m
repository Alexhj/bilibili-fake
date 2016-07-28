//
//  FollowViewController.m
//  bilibili fake
//
//  Created by cezr on 16/6/22.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "FollowViewController.h"
#import "ScrollTabBarController.h"

#import "TabBar.h"

@interface FollowViewController ()
<UIScrollViewDelegate>
{
    TabBar *_tabbar;
}
@end

@implementation FollowViewController

- (instancetype)init; {
    if (self = [super init]) {
        self.title = @"关注";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ColorWhite(247);
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    
    _tabbar = [[TabBar alloc] initWithTitles:@[@"测试",@"测试测试",@"测试测试测试",@"测试",@"测试测试"] style:TabBarStyleScroll];
    _tabbar.frame = CGRectMake(0, 100, SSize.width, 40);
    _tabbar.spacing = 40;
    _tabbar.edgeInsets = UIEdgeInsetsMake(0, 60, 0, 60);
    [self.view addSubview:_tabbar];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor orangeColor];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.frame = CGRectMake(0, 160, SSize.width, 400);
    [self.view addSubview:scrollView];
    
    
    for (NSInteger i=0; i<5; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(scrollView.width * i, 0, scrollView.width, scrollView.height)];
        view.backgroundColor = ColorRGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
        [scrollView addSubview:view];
    }
    scrollView.contentSize = CGSizeMake(scrollView.width * 5, 0);
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _tabbar.contentOffset = scrollView.contentOffset.x / scrollView.width;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


- (void)handlePan:(UIPanGestureRecognizer *)panGestureRecognizer {
    ScrollTabBarController *tabbar = (ScrollTabBarController *)self.tabBarController;
    [tabbar handlePanGesture:panGestureRecognizer];
}



@end
