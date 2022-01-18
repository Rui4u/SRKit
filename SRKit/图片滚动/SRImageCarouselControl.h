//
//  SRImageCarouselControl.h
//  SRImageCarousel
//
//  Created by sharui on 2017/4/26.
//  Copyright © 2017年 sharui. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Margin  10
#define ButtonWidth  50
#define ButtonHeight  50
#define FirstButtonWidth  100
#define FirstButtonHeight  100
#define LeftMargin 10
@interface SRImageCarouselControl : UIScrollView
@property (nonatomic ,strong ) NSArray * dataSourse;

@property (nonatomic ,assign ) BOOL  cusPagingEnabled;
- (void)reloadData;
@end
