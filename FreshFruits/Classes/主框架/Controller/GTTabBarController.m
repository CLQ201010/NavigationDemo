//
//  GTTabBarController.m
//  GTTabBarDemo
//
//  Created by GTL on 13-6-5.
//  Copyright (c) 2013年 phisung. All rights reserved.
//

#import "GTTabBarController.h"
#import "GTTabBar.h"

static GTTabBarController *gtTabBarController;

@implementation UIViewController (GTTabBarControllerSupport)

- (GTTabBarController *)gtTabBarController
{
	return gtTabBarController;
}

@end

@interface GTTabBarController (private)
- (void)displayViewAtIndex:(NSUInteger)index;
@end

#pragma mark -
@implementation GTTabBarController
@synthesize delegate;
@synthesize selectedViewController;
@synthesize viewControllers;
@synthesize selectedIndex;
@synthesize tabBarHidden;
@synthesize animateDriect;
@synthesize tabBar;
@synthesize tabBarTransparent;

#pragma mark -
#pragma mark lifecycle
- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr
{
	self = [super init];
	if (self != nil)
	{
		viewControllers = [NSMutableArray arrayWithArray:vcs];
		containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, containerView.frame.size.height - kTabBarHeight)];
		transitionView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
		tabBar = [[GTTabBar alloc] initWithFrame:CGRectMake(0, containerView.frame.size.height - kTabBarHeight, kScreenWidth, kTabBarHeight) buttonImages:arr];
		tabBar.delegate = self;
        gtTabBarController = self;
        animateDriect = 0;
        tabBarHidden = NO;
	}
	return self;
}

- (void)loadView
{
	[super loadView];
	
	[containerView addSubview:transitionView];
	[containerView addSubview:tabBar];
	self.view = containerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.selectedIndex = 0;
}


#pragma mark - instant methods
- (void)setTabBarTransparent:(BOOL)yesOrNo
{
	if (yesOrNo == YES)
	{
		transitionView.frame = containerView.bounds;
	}
	else
	{
		transitionView.frame = CGRectMake(0, 0, kScreenWidth, containerView.frame.size.height - kTabBarHeight);
	}
}

- (NSUInteger)selectedIndex
{
	return selectedIndex;
}
- (UIViewController *)selectedViewController
{
    return [viewControllers objectAtIndex:selectedIndex];
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [self displayViewAtIndex:index];
    [tabBar selectTabAtIndex:index];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    if (index >= [viewControllers count])
    {
        return;
    }
    // Remove view from superview.
    [[(UIViewController *)[viewControllers objectAtIndex:index] view] removeFromSuperview];
    // Remove viewcontroller in array.
    [viewControllers removeObjectAtIndex:index];
    // Remove tab from tabbar.
    [tabBar removeTabAtIndex:index];
}

- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    [viewControllers insertObject:vc atIndex:index];
    [tabBar insertTabWithImageDic:dict atIndex:index];
}


#pragma mark - Private methods
- (void)displayViewAtIndex:(NSUInteger)index
{
    // Before change index, ask the delegate should change the index.
    if ([self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
    {
        if (![self.delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]])
        {
            return;
        }
    }
    // If target index if equal to current index, do nothing.
    if (selectedIndex == index && [[transitionView subviews] count] != 0)
    {
        return;
    }
    NSLog(@"Display View.");
    selectedIndex = index;
    
	UIViewController *selectedVC = [self.viewControllers objectAtIndex:index];
	
	selectedVC.view.frame = transitionView.frame;
	if ([selectedVC.view isDescendantOfView:transitionView])
	{
		[transitionView bringSubviewToFront:selectedVC.view];
	}
	else
	{
		[transitionView addSubview:selectedVC.view];
	}
    
    // Notify the delegate, the viewcontroller has been changed.
    if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [self.delegate tabBarController:self didSelectViewController:selectedVC];
    }
    
}

#pragma mark -
#pragma mark tabBar delegates
- (void)tabBar:(GTTabBar *)tabBar didSelectIndex:(NSInteger)index
{
	[self displayViewAtIndex:index];
}

@end

