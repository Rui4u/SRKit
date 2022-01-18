//
//  ImageViewController.m
//  MusicList
//
//  Created by sharui on 2018/8/6.
//  Copyright © 2018 com.sharui.demo. All rights reserved.
//

#import "ImageViewController.h"
#import "ClickImageViewController.h"
@interface ImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"123";
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    [self.view addSubview:self.imageView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIImage *image = [UIImage imageNamed:@"1525674467336.jpg"]; //换成sd
    ClickImageViewController * clipView = [[ClickImageViewController alloc]initWithImage:image];
    clipView.delegate = self;
    clipView.radius = 150;   //设置 裁剪框的半径
    clipView.scaleRation = 5;
    [self.navigationController pushViewController:clipView animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ClipViewController:(ClickImageViewController *)clipViewController FinishClipImage:(UIImage *)editImage{
    self.imageView.image = editImage;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
