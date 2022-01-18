//
//  ViewController.m
//  SRAnimatedPageControl
//
//  Created by sharui on 2017/4/18.
//  Copyright © 2017年 sharui. All rights reserved.
//

#import "SRAnimatedPageViewController.h"
#import "SRAnimatedPageControl.h"
#import "CollectionViewCell.h"
#define collectionViewWidth 375
#define collectionViewHeight 375
@interface SRAnimatedPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong ) UICollectionView *collectionView;

/**
 自定义指示器
 */
@property (nonatomic ,strong ) SRAnimatedPageControl * animatedPageControl;

@property (nonatomic ,strong ) NSArray * dataSourse;
@end

@implementation SRAnimatedPageViewController

static  NSString  * const collectionViewCellID = @"collectionViewCellID";


- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view addSubview:self.collectionView];
    self.view.backgroundColor = [UIColor whiteColor];
	SRAnimatedPageControl * animatedPageControl = [[SRAnimatedPageControl alloc] initWithFrame:CGRectMake(0, 100, 375, 50) withDataSourse:self.dataSourse];
	
	self.animatedPageControl = animatedPageControl;
	animatedPageControl.backgroundColor = [UIColor yellowColor];
	[self.view addSubview:animatedPageControl];
	animatedPageControl.bindCollectionView = self.collectionView;
	
	//点击回调
	animatedPageControl.clickBGViewButtonBlock = ^(NSInteger index) {
		NSLog(@"current:%tu",index);
	};
	
	//初始化
	[self scrollViewDidScroll:self.collectionView];
}

#pragma mark-- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
	 numberOfItemsInSection:(NSInteger)section {
	return self.dataSourse.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	

 	CollectionViewCell *democell = [collectionView
									  dequeueReusableCellWithReuseIdentifier:collectionViewCellID
									  forIndexPath:indexPath];
	democell.labelText.text = [NSString stringWithFormat:@"%tu",indexPath.item];
	
	return democell;
}

#pragma mark-- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

	[self.animatedPageControl.coverLayer animateIndicatorWithScrollView:scrollView withPageControl:self.animatedPageControl];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	self.animatedPageControl.coverLayer.lastContentOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	self.animatedPageControl.coverLayer.lastContentOffset = scrollView.contentOffset.x;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
	
	if (!_collectionView) {
		
		UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		layout.itemSize = CGSizeMake(collectionViewWidth,collectionViewHeight);
		layout.minimumLineSpacing = 0;
		layout.minimumInteritemSpacing = 0;
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, collectionViewWidth, collectionViewHeight) collectionViewLayout:layout];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		_collectionView.pagingEnabled = YES;
		[self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];

	}
	return _collectionView;

}
- (NSArray *)dataSourse {
	if (!_dataSourse) {
		_dataSourse = @[@123,@123,@123,@123,@123,@123,@123,@123,@123,@123,@123,@123,@123,@123,@123,@123,@123,@123,@123,@123,@123];
	}
	return _dataSourse;
}
@end
