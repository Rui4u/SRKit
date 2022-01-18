//
//  BackGroundView.h
//  SRAnimatedPageControl
//
//  Created by sharui on 2017/4/18.
//  Copyright © 2017年 sharui. All rights reserved.
//

#import <UIKit/UIKit.h>
#define sendButtonWidth 30
#define sendButtonSpace 20
#define sendButtonMargin 20
#define sendButtonTag 100000
@interface BackGroundView : UIView

- (instancetype)initWithFrame:(CGRect) frame andDataSourse:(NSArray *)dataSource;

/**
 起始底部button位置
 */
@property (nonatomic ,assign ) CGRect firstButtonRect;

/**
 点击回调
 */
@property (nonatomic ,copy ) void (^clickBGViewButtonBlock)(UIButton * sender) ;

@end
