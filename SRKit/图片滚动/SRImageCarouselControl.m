//
//  SRImageCarouselControl.m
//  SRImageCarousel
//
//  Created by sharui on 2017/4/26.
//  Copyright © 2017年 sharui. All rights reserved.
//

#import "SRImageCarouselControl.h"
#import "UIView+Extension.h"

@interface ButtonFrameModel : NSObject

@property (nonatomic ,assign ) CGRect buttonFrame;
@end

@implementation ButtonFrameModel

@end
@interface SRImageCarouselControl ()<UIScrollViewDelegate>

@property (nonatomic ,assign ) CGFloat lastConOffsetX;

@property (nonatomic ,assign ) CGFloat targetContentOffsetX;
@property (nonatomic ,strong ) NSMutableArray <UIButton *> *contentViewButtonArray ;
@property (nonatomic ,strong ) NSMutableArray<ButtonFrameModel *> *contentViewButtonRect ;

@end
@implementation SRImageCarouselControl

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self) {
		self.bounces = NO;
		self.bouncesZoom = NO;
		self.delegate = self;
		self.decelerationRate = 0.001;
		_cusPagingEnabled = YES;
	}
	
	return self;
}
- (void)reloadData {
	
	for (UIView *view in self.subviews) {
		[view removeFromSuperview];
	}
	self.lastConOffsetX = 0;
	[self.contentViewButtonArray removeAllObjects];
	[self.contentViewButtonRect removeAllObjects];
	
	NSMutableArray * mutableArray = [NSMutableArray arrayWithCapacity:self.dataSourse.count * 4];
	
	for (int i = 0 ; i < 4; i ++) {
		[mutableArray addObjectsFromArray:self.dataSourse];
	}
	NSArray * dataSourse = mutableArray.copy;
	
	
	for (int i = 0; i < dataSourse.count; i ++) {
		UIButton * button = [[UIButton alloc] initWithFrame: CGRectMake(Margin + (ButtonWidth  + Margin)* i , 10, ButtonWidth, ButtonHeight)];
		
		if(i == 0) {
			button.frame = CGRectMake(Margin + (ButtonWidth  + Margin)* i , 10, FirstButtonWidth, FirstButtonHeight);
		}else  {
			button.frame = CGRectMake(Margin + (FirstButtonWidth - ButtonWidth) + (ButtonWidth  + Margin)* i , 10, ButtonWidth, ButtonHeight);
		}
		
		[button setBackgroundImage:[UIImage imageNamed:@"circle_round"] forState:UIControlStateNormal];
		button.userInteractionEnabled = NO;
		[button setTitle:[NSString stringWithFormat:@"%d",i ] forState:UIControlStateNormal];
		[self addSubview:button];
		[self.contentViewButtonArray addObject:button];
		ButtonFrameModel * buttonModel = [[ButtonFrameModel alloc] init];
		buttonModel.buttonFrame = button.frame;
		[self.contentViewButtonRect addObject:buttonModel];
	}
	self.contentSize = CGSizeMake(CGRectGetMaxX(self.contentViewButtonArray.lastObject.frame), 0);
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self setContentOffset:CGPointMake(- Margin +(FirstButtonWidth - ButtonWidth )+ (ButtonWidth  + Margin)* 2* self.dataSourse.count - ButtonWidth, 0) animated:YES];;
	});
}

- (void)layoutSubviews {
	
	if(abs((int)(self.contentOffset.x - self.lastConOffsetX))>30) {
		self.contentOffset = CGPointMake(self.lastConOffsetX, 0);
		return;
	}
	
	if (self.contentOffset.x > Margin + (FirstButtonWidth - ButtonWidth )+ (ButtonWidth  + Margin)* 3 * self.dataSourse.count - [UIScreen mainScreen].bounds.size.width) {
		self.contentOffset = CGPointMake(Margin + (FirstButtonWidth - ButtonWidth )+ (ButtonWidth  + Margin)* 2 * self.dataSourse.count - [UIScreen mainScreen].bounds.size.width, 0);
		
	}
	if (self.contentOffset.x < Margin + (FirstButtonWidth - ButtonWidth )+(ButtonWidth  + Margin)* 10) {
		self.contentOffset = CGPointMake(Margin +(FirstButtonWidth - ButtonWidth )+ (ButtonWidth  + Margin)* 2* self.dataSourse.count , 0);
		
	}
	
	NSLog(@"%f",self.contentOffset.x);
	NSLog(@"%d",(int)self.contentOffset.x /(int)(Margin + ButtonWidth));
	
	int index = (floor)(self.contentOffset.x /(Margin + ButtonWidth));
	
	for (int i = 0; i <self.contentViewButtonRect.count; i ++) {
		
		if (i != index && (i !=(index + 1))) {
			
			if (i <=index) {
				UIButton * btn = [self.contentViewButtonArray objectAtIndex:i];
				btn.frame = self.contentViewButtonRect[i].buttonFrame;
				btn.x = btn.x - (FirstButtonWidth - ButtonWidth);
			}else {
				
				UIButton * btn = [self.contentViewButtonArray objectAtIndex:i];
				btn.frame = self.contentViewButtonRect[i].buttonFrame;
			}
			
		}else {
			
			if (self.contentOffset.x >self.lastConOffsetX) {
    
				UIButton * btn = [self.contentViewButtonArray objectAtIndex:index];
				
				if (btn.width >= ButtonWidth) {
					btn.width = FirstButtonWidth - (self.contentOffset.x- (Margin + ButtonWidth) * index);
					btn.height = btn.width;
				}else {
					btn.width = btn.height = ButtonWidth;
				}
				
				UIButton * btn2 = [self.contentViewButtonArray objectAtIndex:index + 1];
				ButtonFrameModel* btn2Frame = [self.contentViewButtonRect objectAtIndex:index + 1];
				
				if (btn2.width <= FirstButtonWidth) {
					btn2.width = ButtonWidth + (self.contentOffset.x - (Margin + ButtonWidth) * index);
					btn2.x = CGRectGetMaxX(btn.frame) +Margin;
					btn2.height = btn2.width;
				}else {
					btn2.height = btn2.width = FirstButtonWidth;
					btn2.x = btn2Frame.buttonFrame.origin.x - (FirstButtonWidth - ButtonWidth);
				}
				
			}else {
				UIButton * btn = [self.contentViewButtonArray objectAtIndex:index];
				
				if (btn.width <= FirstButtonWidth) {
					btn.width = FirstButtonWidth - (self.contentOffset.x- (Margin + ButtonWidth) * index);
					btn.height = btn.width;
				}
				
				UIButton * btn2 = [self.contentViewButtonArray objectAtIndex:index + 1];
				
				if (btn2.width >= ButtonWidth) {
					btn2.width = ButtonWidth + (self.contentOffset.x - (Margin + ButtonWidth) * index);
					btn2.x = CGRectGetMaxX(btn.frame) +Margin;
					btn2.height = btn2.width;
				}
				
			}
		}
	}
	
	self.lastConOffsetX = self.contentOffset.x;
	[super layoutSubviews];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	
		[self autoScrollToEndPoint];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self autoScrollToEndPoint];
	
}

- (void)autoScrollToEndPoint {
	if (self.cusPagingEnabled) {
		float a = self.contentOffset.x / (Margin + ButtonWidth);
		[self setContentOffset:CGPointMake((Margin + ButtonWidth)* round(a) - LeftMargin, 0) animated:YES];
	}
}




- (NSMutableArray <UIButton *>*)contentViewButtonArray {
	if (!_contentViewButtonArray) {
		_contentViewButtonArray = [NSMutableArray arrayWithCapacity:10];
	}
	return _contentViewButtonArray;
}
- (NSMutableArray <ButtonFrameModel *>*)contentViewButtonRect {
	if (!_contentViewButtonRect) {
		_contentViewButtonRect = [NSMutableArray arrayWithCapacity:10];
	}
	return _contentViewButtonRect;
}
- (void)setCusPagingEnabled:(BOOL)cusPagingEnabled {
	_cusPagingEnabled = cusPagingEnabled;
	[self reloadData];
}
@end
