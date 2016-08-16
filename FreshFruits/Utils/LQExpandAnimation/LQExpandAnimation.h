//
//  LQExpandAnimation.h
//  testSwift
//
//  Created by clq on 16/8/8.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LQExpandAnimationFromViewAnimationsAdapter <NSObject>

@optional
//tableView是否分开滑动,默认YES
@property (nonatomic,assign,readonly) BOOL shouldSlideApart;
//是否有导航栏,默认NO
@property (nonatomic,assign,readonly) BOOL isHasNavigation;
//是否是Push，默认是NO,即present
@property (nonatomic,assign,readonly) BOOL isPush;

@optional
- (void)animationsBeganInView:(UIView * __nonnull)view isPresentation:(BOOL)isPresentation;
- (void)animationsEnded:(BOOL)isPresentation;

@end

@protocol LQExpandAnimationToViewAnimationsAdapter <NSObject>

@optional

// Additional setup before the animations.
- (void)prepareExpandingView:(UIView * __nonnull)view;
- (void)prepareCollapsingView:(UIView * __nonnull)view;

// Custom changes to animate.
- (void)animationsForExpandingView:(UIView * __nonnull)view;
- (void)animationsForCollapsingView:(UIView * __nonnull)view;

// Cleanup after the animations are performed.
- (void)completionForExpandingView:(UIView * __nonnull)view;
- (void)completionForCollapsingView:(UIView * __nonnull)view;

@end

typedef CGRect (^collapsedViewFrameBlock)(void);

@interface LQExpandAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic,copy,nullable) collapsedViewFrameBlock collapsedViewFrame;
@property (nonatomic,assign) CGRect expandedViewFrame;
@property (nonatomic,assign) NSTimeInterval animationDuration;

@property (nonatomic,assign) UINavigationControllerOperation navOperation;

@property (nonatomic,weak) id<LQExpandAnimationFromViewAnimationsAdapter> fromViewAnimationsAdapter;
@property (nonatomic,weak) id<LQExpandAnimationToViewAnimationsAdapter> toViewAnimationsAdapter;

@end
