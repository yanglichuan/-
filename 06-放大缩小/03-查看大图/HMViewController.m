//
//  HMViewController.m
//  03-查看大图
//
//  Created by apple on 14-8-18.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HMViewController.h"

@interface HMViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

// 假设图像是从网络上获取的
@property (nonatomic, strong) UIImage *image;

@end

@implementation HMViewController
/**
 放大缩小
 
 1> 设置代理
 2> 指定最大/最小的缩放比例
 
 */

// 图像的setter
- (void)setImage:(UIImage *)image
{
    _image = image;
    
    // 设置图像视图的内容
    self.imageView.image = image;
    // 让图像视图根据图像自动调整大小
    [self.imageView sizeToFit];
    
    // 告诉scrollView内部内容的实际大小
    self.scrollView.contentSize = image.size;
}

/**
 在getter方法中
 
 * 如果是属性自身的，使用_成员变量
 * 如果是其他属性，使用self. getter方法，从而可以保证如果该对象没有被实例化，能够及时的被创建并加载
 */
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        
        [self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        
        // 设置属性
        // 设置边距
        _scrollView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
        
        // 不显示水平滚动标示
        _scrollView.showsHorizontalScrollIndicator = NO;
        // 不显示垂直滚动标示
        _scrollView.showsVerticalScrollIndicator = NO;
        
        // *** 偏移位置
        _scrollView.contentOffset = CGPointMake(0, 0);
        
        // 取消弹簧效果，内容固定，不希望出现弹簧效果时
        // 不要跟bounds属性搞混了
        _scrollView.bounces = NO;
        
        // 设置代理
        _scrollView.delegate = self;
        // 设置最大/最小缩放比例
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.minimumZoomScale = 0.2;
        
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 设置图像
    self.image = [UIImage imageNamed:@"minion"];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.center = self.view.center;
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click
{
    // 移动大图的偏移位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x += 20;
    offset.y += 20;
    
    // 注意：设置contentOffset会忽略contentSize
    self.scrollView.contentOffset = offset;
}

#pragma mark - UIScrollView的代理方法
/**
 1> 设置了代理
 2> 指定了最大、最小的缩放比例
 
 表示ScrollView是可以缩放的
 
 代理方法的"返回值"实际上就是控制器告诉滚动视图，要缩放的是UIImageView
 */
// 告诉ScrollView要缩放的视图是谁，具体的缩放实现，是由ScrollView来完成的
// 1> scrollView要知道缩放谁
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

// 2> 滚动视图即将开始缩放，通常不需要写
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    NSLog(@"%s", __func__);
}

// 3> 正在缩放，通常也不需要实现
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //    NSLog(@"%s", __func__);
    NSLog(@"%@", NSStringFromCGAffineTransform(self.imageView.transform));
}

// 4> 完成缩放，通常也不需要实现
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"%s", __func__);
}

@end
