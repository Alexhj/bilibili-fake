//
//  VideoViewController.m
//  bilibili fake
//
//  Created by 翟泉 on 2016/7/18.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "VideoViewController.h"


#import "VideoHeaderView.h"
#import "VideoIntroView.h"
#import "VideoCommentView.h"

@interface VideoViewController ()
<UIScrollViewDelegate, UIGestureRecognizerDelegate,
UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning>
{
    NSInteger _aid;
    
    VideoModel *_model;
    
    VideoHeaderView *_headerView;
    
    UIView *_tabBar;
    
    UIScrollView *_backgroundScrollView;
    
    VideoIntroView *_introView;
    VideoCommentView *_commentView;
    
    BOOL _interactive;
    UIPercentDrivenInteractiveTransition *_interactionController;
}

@end

@implementation VideoViewController

- (instancetype)initWithAid:(NSInteger)aid; {
    if (self = [super init]) {
        _aid = aid;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ColorWhite(240);
    
    self.navigationController.delegate = self;
    
    [self initSubviews];
    
    _interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
    
    
    _model = [[VideoModel alloc] init];
    
    [_model getVideoInfoWithAid:_aid success:^{
        [_headerView setupVideoInfo:_model.videoInfo];
    } failure:^(NSString *errorMsg) {
        //
    }];
    
    
    [_model getVideoURLWithCid:8791454 /*6282404*/ completionBlock:^(NSURL *videoURL) {
        
        NSLog(@"%@", videoURL.absoluteString);
        
    }];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y / 2;
    if (offset < 0) {
        offset = 0;
    }
    if (_headerView.height - offset < 44) {
        offset = _headerView.height - 44;
    }
    
//    static NSInteger lastState = 0;
//    if (_headerView.y < -offset) {
//        lastState = 0;
//        //   ++
//        NSLog(@"Up");
//        if (-offset < _headerView.y) {
//            NSLog(@"Rt");
//            return;
//        }
//    }
//    else {
//        lastState = 1;
//        // ++   --
//        NSLog(@"Down");
//        if (-offset > _headerView.y) {
//            NSLog(@"Rt");
//            return;
//        }
//    }
//    NSLog(@"%lf", offset);
    
    
    [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset = -offset;
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tabBarController.tabBar.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle; {
    return UIStatusBarStyleLightContent;
}

- (void)handlePangesture:(UIPanGestureRecognizer *)panGesture {
    CGFloat translationX = [panGesture translationInView:_backgroundScrollView].x;
    NSLog(@"%lf", translationX);
    CGFloat progress = translationX / self.view.width;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            _interactive = YES;
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:
            [_interactionController updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            _interactive = NO;
            if (progress > 0.4) {
                [_interactionController finishInteractiveTransition];
            }
            else {
                [_interactionController cancelInteractiveTransition];
            }
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:_backgroundScrollView];
    if (gestureRecognizer.view == _headerView) {
        return translation.x > 0;
    }
    else if (gestureRecognizer.view == _backgroundScrollView) {
        return _backgroundScrollView.contentOffset.x == 0 && translation.x > 0;
    }
    else {
        return NO;
    }
}


- (void)initSubviews {
    _headerView = [[VideoHeaderView alloc] init];
    [self.view addSubview:_headerView];
    
    _tabBar = [[UIView alloc] init];
    _tabBar.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_tabBar];
    
    _backgroundScrollView = [[UIScrollView alloc] init];
    _backgroundScrollView.bounces = NO;
    _backgroundScrollView.pagingEnabled = YES;
    [self.view addSubview:_backgroundScrollView];
    
    _introView = [[VideoIntroView alloc] init];
    _introView.scrollViewDelegate = self;
    [_backgroundScrollView addSubview:_introView];
    
    _commentView = [[VideoCommentView alloc] init];
    _commentView.scrollViewDelegate = self;
    [_backgroundScrollView addSubview:_commentView];
    
    
    
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.top.offset = 0;
        make.height.equalTo(_headerView.mas_width).multipliedBy(450.0/720.0);
    }];
    [_tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.top.equalTo(_headerView.mas_bottom);
        make.height.offset = 30;
    }];
    [_backgroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.right.offset = 0;
        make.top.equalTo(_tabBar.mas_bottom);
        make.bottom.offset = 0;
    }];
    [_introView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.top.offset = 0;
        make.width.equalTo(_backgroundScrollView);
        make.height.equalTo(_backgroundScrollView);
    }];
    [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_introView.mas_right);
        make.top.offset = 0;
        make.width.equalTo(_backgroundScrollView);
        make.height.equalTo(_backgroundScrollView);
    }];
    [_backgroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_commentView);
    }];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePangesture:)];
    panGesture.delegate = self;
    [_backgroundScrollView addGestureRecognizer:panGesture];
    UIPanGestureRecognizer *headerPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePangesture:)];
    headerPanGesture.delegate = self;
    [_headerView addGestureRecognizer:headerPanGesture];
}


#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop) {
        return self;
    }
    else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return _interactive ? _interactionController : NULL;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    [containerView insertSubview:toView belowSubview:fromView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.transform = CGAffineTransformTranslate(fromView.transform, containerView.width, 0);
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        BOOL isCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!isCancelled];
    }];
}

@end
