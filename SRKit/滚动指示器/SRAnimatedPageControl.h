//
//  SRAnimatedPageControl.h
//  SRAnimatedPageControl
//
//  Created by sharui on 2017/4/18.
//  Copyright © 2017年 sharui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRCoverLayer.h"
#import "BackGroundView.h"
@interface SRAnimatedPageControl : UIScrollView

/**
 蒙层
 */
@property (nonatomic ) SRCoverLayer * coverLayer;

/**
 背景button
 */
@property (nonatomic ,strong ) BackGroundView * backGroundView;


/**
 绑定的collectionView
 */
@property (nonatomic ,assign ) UICollectionView * bindCollectionView;
/**
 初始化方法

 @param frame <#frame description#>
 @param dataSourse 数据源
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame withDataSourse:(NSArray *)dataSourse;


/**
 回调到控制器
 */
@property (nonatomic ,copy ) void (^clickBGViewButtonBlock)(NSInteger index) ;

@end
