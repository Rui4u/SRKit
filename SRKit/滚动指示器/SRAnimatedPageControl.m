//
//  SRAnimatedPageControl.m
//  SRAnimatedPageControl
//
//  Created by sharui on 2017/4/18.
//  Copyright © 2017年 sharui. All rights reserved.
//

#import "SRAnimatedPageControl.h"
#import "BackGroundView.h"
#import "SRCoverLayer.h"
@implementation SRAnimatedPageControl

- (instancetype)initWithFrame:(CGRect)frame withDataSourse:(NSArray *)dataSourse
{
	self = [super initWithFrame:frame];
	if (self) {
		_backGroundView = [[BackGroundView alloc] initWithFrame:self.bounds andDataSourse:dataSourse];
		self.contentSize = CGSizeMake(_backGroundView.bounds.size.width, 0);
		[self addSubview:_backGroundView];
		
		_coverLayer = [[SRCoverLayer alloc] init];
		_coverLayer.frame = _backGroundView.bounds;
		[self.layer addSublayer:_coverLayer];
		
		
		__weak typeof(self) weakSelf = self;
		_backGroundView.clickBGViewButtonBlock =  ^(UIButton * sender) {
			
			NSInteger page = sender.tag - sendButtonTag;
			weakSelf.clickBGViewButtonBlock(page);
			[weakSelf.bindCollectionView setContentOffset:CGPointMake(page * self.bindCollectionView.bounds.size.width, 0) animated:YES];
			[weakSelf.coverLayer performSelector:@selector(restoreAnimation:)
													  withObject:nil
													  afterDelay:3];
		};
	
		
	}
	return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {

}

@end
