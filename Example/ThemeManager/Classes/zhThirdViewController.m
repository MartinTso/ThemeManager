//
//  zhThirdViewController.m
//  ThemeManager
//
//  Created by zhanghao on 2017/8/26.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zhThirdViewController.h"
#import "zhDetailViewController.h"
#import "zhNavigationController.h"
#import "zhProgressView.h"

@interface zhThirdViewController ()

@property (nonatomic, weak) zhProgressView *lastProgressView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation zhThirdViewController

- (void)detailsClicked {
    zhNavigationController *nvc = [[zhNavigationController alloc] initWithRootViewController:[zhDetailViewController new]];
    [self presentViewController:nvc animated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.zh_backgroundColorPicker = ThemeColorPickerWithKey(@"color01");
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 35);
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button zh_setImagePicker:ThemeImagePickerWithKey(@"image04") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(detailsClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:25];
    textAttrs[NSForegroundColorAttributeName] = ThemeColorPickerWithKey(@"color04");
    [self.navigationController.navigationBar zh_setTitleTextAttributes:textAttrs];
    
    self.navigationController.navigationBar.zh_overlayColorPicker = ThemeColorPickerWithKey(@"color01").animated(YES);
    
    self.navigationItem.title = @"Download the theme";

    _scrollView = [UIScrollView new];
    _scrollView.zh_backgroundColorPicker = ThemeColorPickerWithKey(@"color01");
    _scrollView.frame = self.view.frame;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    self.view = _scrollView;
    
    NSArray *colors = @[@"569EED", @"D35C34", @"A874E0"];
    [colors enumerateObjectsUsingBlock:^(NSString *hexString, NSUInteger idx, BOOL * _Nonnull stop) {
        zhProgressView *progressView = [zhProgressView new];
        progressView.size = CGSizeMake(300, 100);
        progressView.y = 70 + (progressView.size.height + 60) * idx;
        progressView.centerX = self.view.bounds.size.width / 2;
        progressView.backgroundColor = [UIColor colorWithHexString:hexString];
        progressView.layer.cornerRadius = 10;
        progressView.layer.masksToBounds = YES;
        NSString *title = [NSString stringWithFormat:@"style%lu", (long)(idx + 1)];
        progressView.textLabel.text = title;
        progressView.textLabel.font = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:47];
        progressView.tag = idx;
        [progressView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(progressViewClicked:)]];
        [_scrollView addSubview:progressView];
        
        progressView.layer.borderColor = [UIColor colorWithHexString:@"F8F8FF"].CGColor;
        NSDictionary *d = @{ThemeDay : @0.0, ThemeNight : @0.0,
                            Theme1 : @0.5, Theme2 : @2.0, Theme3 : @3.5};
        progressView.layer.zh_borderWidthPicker = ThemeNumberPickerWithDictionary(d);
    }];
}

- (void)progressViewClicked:(UITapGestureRecognizer *)g {
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(loadData:) userInfo:g.view repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode: NSRunLoopCommonModes];
}

- (void)loadData:(id)sender {
    zhProgressView *progressView = (zhProgressView *)[sender userInfo];
    NSInteger idx = progressView.tag;

    NSArray *colors = @[@"D3366F", @"6CC1A2", @"E5B648"];
    NSArray *themeStyles = @[Theme1, Theme2, Theme3];
    progressView.fillColor = [UIColor colorWithHexString:colors[idx]];
    
    if (progressView.progress < 1) {
        progressView.progress = progressView.progress + 0.015;
    } else {
        [_timer invalidate];
        _timer = nil;
        progressView.textLabel.text = [NSString stringWithFormat:@"style%@", @(idx + 1)];
        [ThemeManager updateThemeStyle:themeStyles[idx]];
    }
}

@end
