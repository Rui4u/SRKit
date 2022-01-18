//
//  SRCoverLayer.h
//  SRAnimatedPageControl
//
//  Created by sharui on 2017/4/18.
//  Copyright © 2017年 sharui. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@class SRAnimatedPageControl;

typedef enum ScrollDirection {
	ScrollDirectionNone,
	ScrollDirectionRight,
	ScrollDirectionLeft,
} ScrollDirection;

@interface SRCoverLayer : CALayer

/**
 当前阴影rect
 */
@property(nonatomic, assign) CGRect currentRect;

/**
 形变 0 - 0.5
 */
@property(nonatomic,assign)CGFloat factor;

/**
 方向
 */
@property(nonatomic, assign) ScrollDirection scrollDirection;

/**
 记录上一个contentOffset
 */
@property (nonatomic ,assign ) CGFloat lastContentOffset;


/**
 滑动监听

 @param scrollView <#scrollView description#>
 @param pageControl <#pageControl description#>
 */
- (void)animateIndicatorWithScrollView:(UIScrollView *)scrollView withPageControl:(SRAnimatedPageControl *)pageControl;

- (void)restoreAnimation:(id)howmanydistance;

@end
