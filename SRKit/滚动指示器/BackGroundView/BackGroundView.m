//
//  BackGroundView.m
//  SRAnimatedPageControl
//
//  Created by sharui on 2017/4/18.
//  Copyright © 2017年 sharui. All rights reserved.
//

#import "BackGroundView.h"


@interface BackGroundView()

/**
 数据源
 */
@property (nonatomic ,strong )  NSArray * dataSource;
@end
@implementation BackGroundView


- (instancetype)initWithFrame:(CGRect) frame andDataSourse:(NSArray *)dataSource {
	self = [super initWithFrame:frame];
	
	if (self) {
		_dataSource = dataSource;
		[self privateSetUpUI];
	}
	return self;
}

- (void)privateSetUpUI {


	for (int i = 0 ; i < _dataSource.count; i ++) {
		
		CGFloat sendButtonX = sendButtonMargin + i * (sendButtonWidth + sendButtonSpace);
		CGFloat sendButtonY = (self.bounds.size.height - sendButtonWidth) / 2;
		UIButton * sendButton = [[UIButton alloc] initWithFrame:CGRectMake(sendButtonX, sendButtonY, sendButtonWidth, sendButtonWidth)];
		
		sendButton.layer.cornerRadius = sendButtonWidth / 2;
		sendButton.backgroundColor = [UIColor redColor];
		[sendButton addTarget:self action:@selector(clickBackGroundViewButton:) forControlEvents:UIControlEventTouchUpInside];
		sendButton.tag = sendButtonTag + i;
		
		[self addSubview:sendButton];
		
		if (i == 0 ) {
			_firstButtonRect = sendButton.frame; //记录起始位置
		}
		
		if (i == _dataSource.count - 1) {
			self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetMaxX(sendButton.frame) + sendButtonMargin, self.bounds.size.height);
		}
		
	}
}

- (void)clickBackGroundViewButton:(UIButton *)sender {

	self.clickBGViewButtonBlock(sender);
 //动画效果--后期加
	//圆扩散
	CAShapeLayer *circleShape = nil;
	CGFloat scale = 1.0f;
	
	CGFloat width = sender.bounds.size.width, height = sender.bounds.size.height;
	scale = 1.5f;
	circleShape = [self createCircleShapeWithPosition:CGPointMake(width/2, height/2)
											 pathRect:CGRectMake(-CGRectGetMidX(sender.bounds), -CGRectGetMidY(sender.bounds), width, height)
											   radius:sender.layer.cornerRadius];
	
	[sender.layer addSublayer:circleShape];
	
	CAAnimationGroup *groupAnimation = [self createFlashAnimationWithScale:scale duration:0.5f];
	
	/* Use KVC to remove layer to avoid memory leak */
	[groupAnimation setValue:circleShape forKey:@"circleShaperLayer"];
	
	[circleShape addAnimation:groupAnimation forKey:nil];
}

- (CAShapeLayer *)createCircleShapeWithPosition:(CGPoint)position pathRect:(CGRect)rect radius:(CGFloat)radius
{
	CAShapeLayer *circleShape = [CAShapeLayer layer];
	circleShape.path = [self createCirclePathWithRadius:rect radius:radius];
	circleShape.position = position;
	
	
	circleShape.fillColor = [UIColor clearColor].CGColor;
	circleShape.strokeColor = [UIColor greenColor].CGColor;
	
	circleShape.opacity = 0;
	circleShape.lineWidth = 1;
	
	return circleShape;
}

- (CGPathRef)createCirclePathWithRadius:(CGRect)frame radius:(CGFloat)radius
{
	return [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius].CGPath;
}

- (CAAnimationGroup *)createFlashAnimationWithScale:(CGFloat)scale duration:(CGFloat)duration
{
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
	
	CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	alphaAnimation.fromValue = @1;
	alphaAnimation.toValue = @0;
	
	CAAnimationGroup *animation = [CAAnimationGroup animation];
	animation.animations = @[scaleAnimation, alphaAnimation];

	animation.duration = duration;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	return animation;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
