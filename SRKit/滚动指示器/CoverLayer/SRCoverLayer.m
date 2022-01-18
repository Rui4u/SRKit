//
//  SRCoverLayer.m
//  SRAnimatedPageControl
//
//  Created by sharui on 2017/4/18.
//  Copyright © 2017年 sharui. All rights reserved.
//


#import "BackGroundView.h"
#import "SRCoverLayer.h"
#import "SRAnimatedPageControl.h"

@interface SRCoverLayer ()
@end

@implementation SRCoverLayer
- (void)drawInContext:(CGContextRef)ctx {
	
	CGFloat offset =
	self.currentRect.size.width / 3.6; //设置3.6 出来的弧度最像圆形
	CGPoint rectCenter =
	CGPointMake(self.currentRect.origin.x + self.currentRect.size.width / 2,
				self.currentRect.origin.y + self.currentRect.size.height / 2);
	
	CGFloat extra = (self.currentRect.size.width * 2 / 5) * _factor;
	CGPoint pointA = CGPointMake(rectCenter.x, self.currentRect.origin.y + extra);
	CGPoint pointB = CGPointMake(
								 self.scrollDirection == ScrollDirectionLeft
								 ? rectCenter.x + self.currentRect.size.width / 2
								 : rectCenter.x + self.currentRect.size.width / 2 + extra * 2,
								 rectCenter.y);
	CGPoint pointC = CGPointMake(
								 rectCenter.x, rectCenter.y + self.currentRect.size.height / 2 - extra);
	CGPoint pointD = CGPointMake(self.scrollDirection == ScrollDirectionLeft
								 ? self.currentRect.origin.x - extra * 2
								 : self.currentRect.origin.x,
								 rectCenter.y);
	
	CGPoint c1 = CGPointMake(pointA.x + offset, pointA.y);
	CGPoint c2 = CGPointMake(pointB.x, pointB.y - offset);
	
	CGPoint c3 = CGPointMake(pointB.x, pointB.y + offset);
	CGPoint c4 = CGPointMake(pointC.x + offset, pointC.y);
	
	CGPoint c5 = CGPointMake(pointC.x - offset, pointC.y);
	CGPoint c6 = CGPointMake(pointD.x, pointD.y + offset);
	
	CGPoint c7 = CGPointMake(pointD.x, pointD.y - offset);
	CGPoint c8 = CGPointMake(pointA.x - offset, pointA.y);
	
	// 更新界面
	UIBezierPath *ovalPath = [UIBezierPath bezierPath];
	[ovalPath moveToPoint:pointA];
	[ovalPath addCurveToPoint:pointB controlPoint1:c1 controlPoint2:c2];
	[ovalPath addCurveToPoint:pointC controlPoint1:c3 controlPoint2:c4];
	[ovalPath addCurveToPoint:pointD controlPoint1:c5 controlPoint2:c6];
	[ovalPath addCurveToPoint:pointA controlPoint1:c7 controlPoint2:c8];
	[ovalPath closePath];
	
	CGContextAddPath(ctx, ovalPath.CGPath);
	CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0 alpha:.3].CGColor);
	CGContextFillPath(ctx);
}

- (void)animateIndicatorWithScrollView:(UIScrollView *)scrollView withPageControl:(SRAnimatedPageControl *)pageControl {

	CGFloat contentOffset =	scrollView.contentOffset.x;
	
	CGPoint coverLayerPoint = CGPointMake(contentOffset *(sendButtonWidth + sendButtonMargin)/scrollView.bounds.size.width + sendButtonSpace, pageControl.backGroundView.firstButtonRect.origin.y);
	self.currentRect =CGRectMake(coverLayerPoint.x, coverLayerPoint.y, sendButtonWidth, sendButtonWidth);
	
	
	if (contentOffset > self.lastContentOffset) {
		self.scrollDirection = ScrollDirectionRight;
	}else {
		self.scrollDirection = ScrollDirectionLeft;
	}
	

	CGFloat x1,x2,y1,y2,a,b;
	x1 =  scrollView.bounds.size.width;
	x2 = 1 * x1/2;
	y1 = 0;
	y2 = 0.5;
	a = (y1*x2 - y2*x1)/(x1*x1*x2- x2*x2*x1);
	b = (y1 - a*x1*x1)/x1;
	
	CGFloat x,y;
	x = (int)contentOffset % (int)scrollView.bounds.size.width;
	y = a * x * x + b * x;
	_factor = y;
	
	[self setNeedsDisplay];

}


- (void)setLastContentOffset:(CGFloat)lastContentOffset {
	_lastContentOffset = lastContentOffset;

}
- (void)restoreAnimation:(id)howmanydistance {
	}
@end
