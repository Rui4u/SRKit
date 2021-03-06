//
//  SRImageGridCollectionViewController.m
//  CameraDemo
//
//  Created by sharui on 16/10/11.
//  Copyright © 2016年 sharui. All rights reserved.
//

#import "SRImageGridCollectionViewController.h"
#import "SRImageGridViewLayout.h"
#import "SRAlbumPreviewViewController.h"
#import "SRImageGridCollectionViewCell.h"


@interface SRImageGridCollectionViewController ()<SRImageGridCollectionViewCellDelegate,SRAlbumPreviewViewControllerDelegate>
/**
 当前照片个数
 */
@property (nonatomic ,assign ) NSInteger currentNum;

/**
 最大照片个数
 */
@property (nonatomic ,assign ) NSInteger maxNumber;
/**
 相册模型
 */
@property (nonatomic ,strong ) SRAlbumModel  * albumModel;

/**
 选中素材数组
 */
@property (nonatomic ,strong ) NSMutableArray <PHAsset *>*selectedAssets;

@end

@implementation SRImageGridCollectionViewController
{
    /// 预览按钮
    UIBarButtonItem *_previewItem;
    /// 完成按钮
    UIBarButtonItem *_doneItem;
    /// 选择多少张图片button
    UIButton * _selectedButtonNum;
}

static NSString * const reuseIdentifier = @"SRImageGridCollectionViewControllerCell";

- (instancetype)initWithSRAlbumModel:(SRAlbumModel *)fetchResult withCurrentPicNumber:(NSInteger)currentNum andMaxNumber:(NSInteger )maxNumber
{
    
    self.currentNum = currentNum;
    self.maxNumber  = maxNumber;
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(srResaveSelectImage:) name:@"SRResaveSelectImage" object:nil];
    SRImageGridViewLayout *layout = [[SRImageGridViewLayout alloc] init];

    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        
        self.albumModel = fetchResult;
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[SRImageGridCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self customNavigationBar];
    
}

- (void)customNavigationBar {
    
    
        
        self.title = self.albumModel.title;
    // 工具条
    _previewItem = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(clickPreviewButton)];
    _previewItem.enabled = NO;
    _selectedButtonNum = [[UIButton alloc] init];
    _selectedButtonNum.frame = CGRectMake(0, 0, 20, 20);
    [_selectedButtonNum setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *counterItem = [[UIBarButtonItem alloc] initWithCustomView:_selectedButtonNum];
    
    _doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickFinishedButton)];
    _doneItem.enabled = NO;
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = @[_previewItem, spaceItem,counterItem, _doneItem];
    
    // 取消按钮
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCloseButton)];
}


/**
 预览
 */
- (void) clickPreviewButton {

    
    SRAlbumPreviewViewController *albumPreviewVC = [[SRAlbumPreviewViewController alloc] initWithFetchResult:self.albumModel withIndexPath:nil withSelectedAssets:self.selectedAssets withCurrentPicNumber:self.currentNum andMaxNumber:self.maxNumber];
    albumPreviewVC.delegate = self;
    [self.navigationController pushViewController:albumPreviewVC animated:YES];
}


/**
 完成
 */
- (void) clickFinishedButton {
    
    [self requestImages:self.selectedAssets completed:^(NSArray<UIImage *> *images) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SRImagePickerSelectImage" object:images];
        
        
    }];
    
}


/**
 取消
 */
- (void)clickCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 请求图像方法
/// 根据 PHAsset 数组，统一查询用户选中图像
///
/// @param selectedAssets 用户选中 PHAsset 数组
/// @param completed      完成回调，缩放后的图像数组在回调参数中
- (void)requestImages:(NSArray <PHAsset *> *)selectedAssets completed:(void (^)(NSArray <UIImage *> *images))completed {
    
    /// 图像请求选项
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 设置 resizeMode 可以按照指定大小缩放图像
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 设置 deliveryMode 为 HighQualityFormat 可以只回调一次缩放之后的图像，否则会调用多次
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

	NSMutableArray * imageInfoModels = [NSMutableArray new];
    // 设置加载图像尺寸(以像素为单位)
	
    NSMutableArray <UIImage *> *images = [NSMutableArray array];
    
    for (NSInteger i = 0; i < selectedAssets.count; i++) {
        [images addObject:[UIImage new]];
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    NSInteger i = 0;
    for (PHAsset *asset in selectedAssets) {
        
        dispatch_group_enter(group);
		
		
		SRImageInfoModel * imageInfoModel = [[SRImageInfoModel alloc] init];

        [[PHImageManager defaultManager]
         requestImageForAsset:asset
         targetSize:PHImageManagerMaximumSize
         contentMode:PHImageContentModeAspectFill
         options:options
         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
             [images replaceObjectAtIndex:i withObject:result];
             imageInfoModel.PHImageFileUTIKey = [info objectForKey:@"PHImageFileUTIKey"];
			 [imageInfoModels addObject:imageInfoModel];

             dispatch_group_leave(group);
         }];
        i++;
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
		for (int i = 0; i < images.count; i ++) {
			UIImage * image  = [images objectAtIndex:i];
			SRImageInfoModel * imageInfoModel = [imageInfoModels objectAtIndex:i];
            imageInfoModel.image = image;
        }
        completed(imageInfoModels.copy);
    });
}

#pragma mark <UICollectionViewDataSource>



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.albumModel.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SRImageGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectedButton.selected = [_selectedAssets containsObject:[self.albumModel assetWithIndex:indexPath.item]];
    cell.delegate = self;
    
    [self.albumModel requestThumbnailWithAssetIndex:indexPath.item Size:cell.bounds.size completion:^(SRImageInfoModel *imageInfoModel) {
        cell.imageInfoModel = imageInfoModel;
    }];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SRAlbumPreviewViewController *albumPreviewVC = [[SRAlbumPreviewViewController alloc] initWithFetchResult:self.albumModel withIndexPath:indexPath withSelectedAssets:self.selectedAssets withCurrentPicNumber:self.currentNum andMaxNumber:self.maxNumber];
    albumPreviewVC.delegate = self;
    [self.navigationController pushViewController:albumPreviewVC animated:YES];
    
}

#pragma mark - cell面包客

- (void)imageGridCell:(SRImageGridCollectionViewCell *)cell didSelected:(BOOL)isSelected {
    

    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    PHAsset *asset = [self.albumModel assetWithIndex:indexPath.item];
    
    if (isSelected ) {
        //是否最大值
        if ((self.selectedAssets.count < self.maxNumber - self.currentNum)) {
            
            [self.selectedAssets addObject:asset];
        }else  {
            cell.selectedButton.selected = NO;
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"你最多只能选择%tu张照片",self.maxNumber - self.currentNum] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
                [alertView dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertView addAction:otherAction];

            [self presentViewController:alertView animated:YES completion:nil];

            
        }
        
        
    } else {
        [self.selectedAssets removeObject:asset];
    }
//    cell.selectedButton.selected = isSelected;
    [self updateCounter];
}

/// 更新计数显示
- (void)updateCounter {
    _doneItem.enabled = self.selectedAssets.count > 0;
    _previewItem.enabled = self.selectedAssets.count > 0;
    [_selectedButtonNum setTitle:[NSString stringWithFormat:@"%tu",self.selectedAssets.count] forState:UIControlStateNormal];
    
}


- (NSMutableArray<PHAsset *> *)selectedAssets {
    if (_selectedAssets == nil) {
        _selectedAssets = [[NSMutableArray alloc] init];
    }
    return _selectedAssets;
}

#pragma mark - 调整选中数组
- (void)srResaveSelectImage:(NSMutableArray<PHAsset *> *)selectedAssets {
    
    
    self.selectedAssets = selectedAssets;
    [self.collectionView reloadData];
    [self updateCounter];
}

@end
