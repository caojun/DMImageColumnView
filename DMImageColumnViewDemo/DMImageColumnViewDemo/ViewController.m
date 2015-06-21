//
//  ViewController.m
//  DMImageColumnViewDemo
//
//  Created by Dream on 15/6/21.
//  Copyright (c) 2015年 GoSing. All rights reserved.
//

#import "ViewController.h"
#import "DMImageColumnView.h"
#import "DMImageColumnItem.h"

@interface ViewController () <DMImageColumnViewDelegate>

@property (nonatomic, weak) DMImageColumnView *m_columnView;
@property (nonatomic, weak) UIScrollView *m_scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *array = [NSMutableArray array];
    
//    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    UIImage *placeholderImage = [UIImage imageNamed:@"1.jpg"];
    NSURL *image = [NSURL URLWithString:@"http://e.hiphotos.baidu.com/image/pic/item/8c1001e93901213fac9c1cdf56e736d12f2e9501.jpg"];
    NSString *title = @"女神";
    
    for (int i=0; i<25; i++)
    {
        DMImageColumnItem *item = [DMImageColumnItem imageColumnItemWithImageParam:image andTitle:title andPlaceholderImage:placeholderImage];
        [array addObject:item];
    }
    
    DMImageColumnView *columnView = [DMImageColumnView imageColumnViewWithImageParamArray:array];
    columnView.frame = [UIScreen mainScreen].bounds;
    
    columnView.leftMargin = 10;
    columnView.rightMargin = 10;
    columnView.topMargin = 20;
    columnView.delegate = self;
    columnView.titleColor = [UIColor orangeColor];
    columnView.backgroundColor = [UIColor blueColor];
    columnView.autoAdjustFrame = YES;
    self.m_columnView = columnView;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:scrollView];
    [scrollView addSubview:columnView];
    
    scrollView.contentSize = columnView.frame.size;
    
    self.m_scrollView = scrollView;
}

#pragma mark - DMImageColumnViewDelegate
- (void)imageColumnView:(DMImageColumnView *)view didClickIndex:(NSInteger)index
{
    NSLog(@"%s, index = %d", __func__, index);
    if (0 == index)
    {
        self.m_columnView.columnCount = 3;
    }
    else if (1 == index)
    {
        self.m_columnView.topMargin = 40;
    }
    else if (2 == index)
    {
        self.m_columnView.titleColor = [UIColor redColor];
    }
    else if (3 == index)
    {
        self.m_columnView.autoAdjustFrame = YES;
    }
    else if (4 == index)
    {
        self.m_columnView.columnCount = 1;
    }
    
    self.m_scrollView.contentSize = self.m_columnView.frame.size;
}

@end
