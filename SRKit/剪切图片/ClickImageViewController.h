//
//  ClickImageViewController.h
//  MusicList
//
//  Created by sharui on 2018/5/23.
//  Copyright © 2018年 com.sharui.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClickImageViewController;

@protocol ClickImageViewControllerDelegate <NSObject>

-(void)ClipViewController:(ClickImageViewController *)clipViewController FinishClipImage:(UIImage *)editImage;

@end



@interface ClickImageViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, assign)CGFloat scaleRation;//图片缩放的最大倍数
@property (nonatomic, assign)CGFloat radius; //圆形裁剪框的半径


@property (nonatomic, weak)id<ClickImageViewControllerDelegate>delegate;

-(instancetype)initWithImage:(UIImage *)image;
@end
