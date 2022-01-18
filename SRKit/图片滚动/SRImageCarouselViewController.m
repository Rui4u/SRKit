//
//  SRImageCarouselViewController.m
//  SRKit
//
//  Created by sharui on 2022/1/18.
//

#import "SRImageCarouselViewController.h"
#import "SRImageCarouselControl.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface SRImageCarouselViewController ()
@property (nonatomic ,strong ) SRImageCarouselControl * imageCarouselControl;


@end

@implementation SRImageCarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.imageCarouselControl];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.imageCarouselControl reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (SRImageCarouselControl *)imageCarouselControl {
    
    if (!_imageCarouselControl) {
        _imageCarouselControl = [[SRImageCarouselControl alloc] initWithFrame:CGRectMake(0, 100,SCREEN_WIDTH , 200)];
        _imageCarouselControl.dataSourse = @[@1,@1,@1,@1,@1,@1,@1,@1,@1,@1];
    }

    return _imageCarouselControl;
}
@end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
