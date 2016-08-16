//
//  LQExpandAnimation.m
//  testSwift
//
//  Created by clq on 16/8/8.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "LQExpandAnimation.h"

@interface LQExpandAnimation ()

@property (nonatomic,assign) CGFloat navHeight;
@property (nonatomic,assign) CGFloat tarHeight;

@end

@implementation LQExpandAnimation


static NSTimeInterval SystemAnimationDuration = 0.24;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.animationDuration = SystemAnimationDuration;
        self.navHeight = 0;
        self.tarHeight = 0;
    }
    
    return self;
}

#pragma mark UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return self.animationDuration;
}

//动画效果有问题，移动距离计算有问题
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if ([self.fromViewAnimationsAdapter respondsToSelector:@selector(isPush)] && [self.fromViewAnimationsAdapter isPush]) {
        if (self.navOperation == UINavigationControllerOperationPush) {
            [self pushAnimation:transitionContext];
        }
        else {
            [self popAnimation:transitionContext];
        }
        
    }
    else {
        [self presentAnimation:transitionContext];
    }
}

- (void)presentAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL isPresentation = toVC.presentationController.presentingViewController == fromVC;
    UIView *backgroundView = (isPresentation ? fromVC : toVC).view;
    UIView *frontView = (isPresentation ? toVC : fromVC).view;
    
    UIView *inView = [transitionContext containerView];
    
    if (inView == nil) {
        return;
    }
    
    if ([self.fromViewAnimationsAdapter respondsToSelector:@selector(isHasNavigation)]) {
        if ([self.fromViewAnimationsAdapter isHasNavigation]) {
            _navHeight = 64;
        }
    }
    
    [backgroundView layoutIfNeeded];
    
    CGRect collapsedFrame;
    if (self.collapsedViewFrame != nil) {
        collapsedFrame = self.collapsedViewFrame();
    }
    else {
        collapsedFrame = CGRectMake(backgroundView.bounds.origin.x, CGRectGetMidY(backgroundView.bounds), backgroundView.bounds.size.width, 0);
    }
    
    if (CGRectGetMaxY(collapsedFrame) < backgroundView.bounds.origin.y) {
        collapsedFrame.origin.y = backgroundView.bounds.origin.y - collapsedFrame.size.height;
    }
    
    if (collapsedFrame.origin.y > CGRectGetMaxY(backgroundView.bounds)) {
        collapsedFrame.origin.y = CGRectGetMaxY(backgroundView.bounds);
    }
    
    if (CGRectEqualToRect(self.expandedViewFrame, CGRectZero)) {
        self.expandedViewFrame = inView.bounds;
    }
    
    // Create the sliding views and add them to the scene.
    CGRect topSlidingViewFrame = CGRectMake(backgroundView.bounds.origin.x, backgroundView.bounds.origin.y, backgroundView.bounds.size.width, collapsedFrame.origin.y + _navHeight);
    UIView *topSlidingView = [backgroundView resizableSnapshotViewFromRect:topSlidingViewFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    topSlidingView.frame = topSlidingViewFrame;
    
    CGFloat bottomSlidingViewOriginY = CGRectGetMaxY(collapsedFrame);
    CGRect bottomSlidingViewFrame = CGRectMake(backgroundView.bounds.origin.x, bottomSlidingViewOriginY, backgroundView.bounds.size.width, CGRectGetMaxY(backgroundView.bounds) - bottomSlidingViewOriginY);
    UIView *bottomSlidingView = [backgroundView resizableSnapshotViewFromRect:bottomSlidingViewFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    bottomSlidingView.frame = bottomSlidingViewFrame;
    
    CGFloat topSlidingDistance = collapsedFrame.origin.y - backgroundView.bounds.origin.y + _navHeight;
    CGFloat bottomSlidingDistance = CGRectGetMaxY(backgroundView.bounds) - CGRectGetMaxY(collapsedFrame);
    
    if (!isPresentation) {
        topSlidingView.center = CGPointMake(topSlidingView.center.x, topSlidingView.center.y - topSlidingDistance);
        bottomSlidingView.center = CGPointMake(bottomSlidingView.center.x, bottomSlidingView.center.y + bottomSlidingDistance);
    }
    
    topSlidingView.frame = [backgroundView convertRect:topSlidingView.frame toView:inView];
    bottomSlidingView.frame = [backgroundView convertRect:bottomSlidingView.frame toView:inView];
    
    if ([self.fromViewAnimationsAdapter respondsToSelector:@selector(shouldSlideApart)]) {
        if ([self.fromViewAnimationsAdapter shouldSlideApart] == YES) {
            [inView addSubview:topSlidingView];
            [inView addSubview:bottomSlidingView];
        }
    }
    else {
        [inView addSubview:topSlidingView];
        [inView addSubview:bottomSlidingView];
    }
    
    collapsedFrame = [backgroundView convertRect:collapsedFrame toView:inView];
    
    if (isPresentation) {
        frontView.frame = collapsedFrame;
        [frontView setY:frontView.frame.origin.y + _navHeight];
        if ([self.toViewAnimationsAdapter respondsToSelector:@selector(prepareExpandingView:)]) {
            [self.toViewAnimationsAdapter prepareExpandingView:frontView];
        }
    }
    else {
        if ([self.toViewAnimationsAdapter respondsToSelector:@selector(prepareCollapsingView:)]) {
            [self.toViewAnimationsAdapter prepareCollapsingView:frontView];
        }
    }
    
    // Slide the cell views offscreen and expand the presented view.
    
    if ([self.fromViewAnimationsAdapter respondsToSelector:@selector(animationsBeganInView:isPresentation:)]) {
        [self.fromViewAnimationsAdapter animationsBeganInView:inView isPresentation:isPresentation];;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        [inView addSubview:frontView];
        
        if (isPresentation) {
            topSlidingView.center = CGPointMake(topSlidingView.center.x, topSlidingView.center.y - topSlidingDistance);
            bottomSlidingView.center = CGPointMake(bottomSlidingView.center.x, bottomSlidingView.center.y + bottomSlidingDistance);
            frontView.frame = self.expandedViewFrame;
            [frontView layoutIfNeeded];
            if ([self.toViewAnimationsAdapter respondsToSelector:@selector(animationsForExpandingView:)]) {
                [self.toViewAnimationsAdapter animationsForExpandingView:frontView];
            }
            
        }
        else {
            topSlidingView.center = CGPointMake(topSlidingView.center.x, topSlidingView.center.y + topSlidingDistance);
            bottomSlidingView.center = CGPointMake(bottomSlidingView.center.x, bottomSlidingView.center.y - bottomSlidingDistance);
            frontView.frame = collapsedFrame;
            [frontView setY:frontView.frame.origin.y + _navHeight];
            if ([self.toViewAnimationsAdapter respondsToSelector:@selector(animationsForCollapsingView:)]) {
                [self.toViewAnimationsAdapter animationsForCollapsingView:frontView];
            }
        }
    } completion:^(BOOL finished) {
        [topSlidingView removeFromSuperview];
        [bottomSlidingView removeFromSuperview];
        
        if (!isPresentation) {
            [frontView removeFromSuperview];
        }
        
        [transitionContext completeTransition:YES];
        
        if ([self.fromViewAnimationsAdapter respondsToSelector:@selector(animationsEnded:)]) {
            [self.fromViewAnimationsAdapter animationsEnded:isPresentation];
        }
        
        if (isPresentation) {
            if ([self.toViewAnimationsAdapter respondsToSelector:@selector(completionForExpandingView:)]) {
                [self.toViewAnimationsAdapter completionForExpandingView:frontView];
            }
        }
        else {
            if ([self.toViewAnimationsAdapter respondsToSelector:@selector(completionForCollapsingView:)]) {
                [self.toViewAnimationsAdapter completionForCollapsingView:frontView];
            }
        }
    }];
}

- (void)popAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *backgroundView = toVC.view;
    UIView *frontView = fromVC.view;
    
    UIView *inView = [transitionContext containerView];
    
    if (inView == nil) {
        return;
    }
    
    [inView addSubview:backgroundView];
    
    [backgroundView layoutIfNeeded];
    
    CGRect collapsedFrame;
    if (self.collapsedViewFrame != nil) {
        collapsedFrame = self.collapsedViewFrame();
    }
    else {
        collapsedFrame = CGRectMake(backgroundView.bounds.origin.x, CGRectGetMidY(backgroundView.bounds), backgroundView.bounds.size.width, 0);
    }
    
    if (CGRectGetMaxY(collapsedFrame) < backgroundView.bounds.origin.y) {
        collapsedFrame.origin.y = backgroundView.bounds.origin.y - collapsedFrame.size.height;
    }
    
    if (collapsedFrame.origin.y > CGRectGetMaxY(backgroundView.bounds)) {
        collapsedFrame.origin.y = CGRectGetMaxY(backgroundView.bounds);
    }
    
    if (CGRectEqualToRect(self.expandedViewFrame, CGRectZero)) {
        self.expandedViewFrame = inView.bounds;
    }
    
    // Create the sliding views and add them to the scene.
    CGRect topSlidingViewFrame = CGRectMake(backgroundView.bounds.origin.x, backgroundView.bounds.origin.y, backgroundView.bounds.size.width, collapsedFrame.origin.y + _navHeight);
    UIView *topSlidingView = [backgroundView resizableSnapshotViewFromRect:topSlidingViewFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    topSlidingView.frame = topSlidingViewFrame;
    
    CGFloat bottomSlidingViewOriginY = CGRectGetMaxY(collapsedFrame);
    CGRect bottomSlidingViewFrame = CGRectMake(backgroundView.bounds.origin.x, bottomSlidingViewOriginY, backgroundView.bounds.size.width, CGRectGetMaxY(backgroundView.bounds) - bottomSlidingViewOriginY);
    UIView *bottomSlidingView = [backgroundView resizableSnapshotViewFromRect:bottomSlidingViewFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    bottomSlidingView.frame = bottomSlidingViewFrame;
    
    CGFloat topSlidingDistance = collapsedFrame.origin.y - backgroundView.bounds.origin.y + _navHeight;
    CGFloat bottomSlidingDistance = CGRectGetMaxY(backgroundView.bounds) - CGRectGetMaxY(collapsedFrame);
    

    topSlidingView.center = CGPointMake(topSlidingView.center.x, topSlidingView.center.y - topSlidingDistance);
    bottomSlidingView.center = CGPointMake(bottomSlidingView.center.x, bottomSlidingView.center.y + bottomSlidingDistance);

    topSlidingView.frame = [backgroundView convertRect:topSlidingView.frame toView:inView];
    bottomSlidingView.frame = [backgroundView convertRect:bottomSlidingView.frame toView:inView];
    
    if ([self.fromViewAnimationsAdapter respondsToSelector:@selector(shouldSlideApart)]) {
        if ([self.fromViewAnimationsAdapter shouldSlideApart] == YES) {
            [inView addSubview:topSlidingView];
            [inView addSubview:bottomSlidingView];
        }
    }
    else {
        [inView addSubview:topSlidingView];
        [inView addSubview:bottomSlidingView];
    }
    
    collapsedFrame = [backgroundView convertRect:collapsedFrame toView:inView];
    

    if ([self.toViewAnimationsAdapter respondsToSelector:@selector(prepareCollapsingView:)]) {
        [self.toViewAnimationsAdapter prepareCollapsingView:frontView];
    }
    
    // Slide the cell views offscreen and expand the presented view.
    
    if ([self.fromViewAnimationsAdapter respondsToSelector:@selector(animationsBeganInView:isPresentation:)]) {
        [self.fromViewAnimationsAdapter animationsBeganInView:inView isPresentation:NO];;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        [inView addSubview:frontView];
        
        topSlidingView.center = CGPointMake(topSlidingView.center.x, topSlidingView.center.y + topSlidingDistance);
        bottomSlidingView.center = CGPointMake(bottomSlidingView.center.x, bottomSlidingView.center.y - bottomSlidingDistance);
        frontView.frame = collapsedFrame;
        [frontView setY:frontView.frame.origin.y + _navHeight];
        if ([self.toViewAnimationsAdapter respondsToSelector:@selector(animationsForCollapsingView:)]) {
            [self.toViewAnimationsAdapter animationsForCollapsingView:frontView];
        }
    } completion:^(BOOL finished) {
        [topSlidingView removeFromSuperview];
        [bottomSlidingView removeFromSuperview];

        [frontView removeFromSuperview];
        
        
        [transitionContext completeTransition:YES];
        
        if ([self.fromViewAnimationsAdapter respondsToSelector:@selector(animationsEnded:)]) {
            [self.fromViewAnimationsAdapter animationsEnded:NO];
        }

        if ([self.toViewAnimationsAdapter respondsToSelector:@selector(completionForCollapsingView:)]) {
            [self.toViewAnimationsAdapter completionForCollapsingView:frontView];
        }
    }];
}

- (void)pushAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *backgroundView = fromVC.view;
    UIView *frontView = toVC.view;
    
    UIView *inView = [transitionContext containerView];
    
    if (inView == nil) {
        return;
    }
    
    [backgroundView layoutIfNeeded];
    
    CGRect collapsedFrame;
    if (self.collapsedViewFrame != nil) {
        collapsedFrame = self.collapsedViewFrame();
    }
    else {
        collapsedFrame = CGRectMake(backgroundView.bounds.origin.x, CGRectGetMidY(backgroundView.bounds), backgroundView.bounds.size.width, 0);
    }
    
    if (CGRectGetMaxY(collapsedFrame) < backgroundView.bounds.origin.y) {
        collapsedFrame.origin.y = backgroundView.bounds.origin.y - collapsedFrame.size.height;
    }
    
    if (collapsedFrame.origin.y > CGRectGetMaxY(backgroundView.bounds)) {
        collapsedFrame.origin.y = CGRectGetMaxY(backgroundView.bounds);
    }
    
    if (CGRectEqualToRect(self.expandedViewFrame, CGRectZero)) {
        self.expandedViewFrame = inView.bounds;
    }
    
    // Create the sliding views and add them to the scene.
    CGRect topSlidingViewFrame = CGRectMake(backgroundView.bounds.origin.x, backgroundView.bounds.origin.y, backgroundView.bounds.size.width, collapsedFrame.origin.y + _navHeight);
    UIView *topSlidingView = [backgroundView resizableSnapshotViewFromRect:topSlidingViewFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    topSlidingView.frame = topSlidingViewFrame;
    
    CGFloat bottomSlidingViewOriginY = CGRectGetMaxY(collapsedFrame);
    CGRect bottomSlidingViewFrame = CGRectMake(backgroundView.bounds.origin.x, bottomSlidingViewOriginY, backgroundView.bounds.size.width, CGRectGetMaxY(backgroundView.bounds) - bottomSlidingViewOriginY);
    UIView *bottomSlidingView = [backgroundView resizableSnapshotViewFromRect:bottomSlidingViewFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    bottomSlidingView.frame = bottomSlidingViewFrame;
    
    CGFloat topSlidingDistance = collapsedFrame.origin.y - backgroundView.bounds.origin.y + _navHeight;
    CGFloat bottomSlidingDistance = CGRectGetMaxY(backgroundView.bounds) - CGRectGetMaxY(collapsedFrame);
    
    topSlidingView.frame = [backgroundView convertRect:topSlidingView.frame toView:inView];
    bottomSlidingView.frame = [backgroundView convertRect:bottomSlidingView.frame toView:inView];
    
    if ([self.fromViewAnimationsAdapter respondsToSelector:@selector(shouldSlideApart)]) {
        if ([self.fromViewAnimationsAdapter shouldSlideApart] == YES) {
            [inView addSubview:topSlidingView];
            [inView addSubview:bottomSlidingView];
        }
    }
    else {
        [inView addSubview:topSlidingView];
        [inView addSubview:bottomSlidingView];
    }
    
    collapsedFrame = [backgroundView convertRect:collapsedFrame toView:inView];
    
    frontView.frame = collapsedFrame;
    [frontView setY:frontView.frame.origin.y + _navHeight];
    if ([self.toViewAnimationsAdapter respondsToSelector:@selector(prepareExpandingView:)]) {
        [self.toViewAnimationsAdapter prepareExpandingView:frontView];
    }

    
    // Slide the cell views offscreen and expand the presented view.
    
    if ([self.fromViewAnimationsAdapter respondsToSelector:@selector(animationsBeganInView:isPresentation:)]) {
        [self.fromViewAnimationsAdapter animationsBeganInView:inView isPresentation:YES];;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        [inView addSubview:frontView];
        
        topSlidingView.center = CGPointMake(topSlidingView.center.x, topSlidingView.center.y - topSlidingDistance);
        bottomSlidingView.center = CGPointMake(bottomSlidingView.center.x, bottomSlidingView.center.y + bottomSlidingDistance);
        frontView.frame = self.expandedViewFrame;
        [frontView layoutIfNeeded];
        if ([self.toViewAnimationsAdapter respondsToSelector:@selector(animationsForExpandingView:)]) {
            [self.toViewAnimationsAdapter animationsForExpandingView:frontView];
        }
    } completion:^(BOOL finished) {
        [topSlidingView removeFromSuperview];
        [bottomSlidingView removeFromSuperview];
        
        [transitionContext completeTransition:YES];
        
        if ([self.fromViewAnimationsAdapter respondsToSelector:@selector(animationsEnded:)]) {
            [self.fromViewAnimationsAdapter animationsEnded:NO];
        }
        
        if ([self.toViewAnimationsAdapter respondsToSelector:@selector(completionForExpandingView:)]) {
            [self.toViewAnimationsAdapter completionForExpandingView:frontView];
        }
    }];
}

@end

