/**
 The MIT License (MIT)
 
 Copyright (c) 2015 DreamCao
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "DMImageColumnView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "DMImageColumnImageView.h"

const CGFloat kDMImageColumnHorizontalDistance = 10.f;
const CGFloat kDMImageColumnVerticalDistance = 10.f;
const NSInteger kDMImageColumnCount = 2;

@interface DMImageColumnView () <DMImageColumnImageViewDelegate>

/**
 *  存放 DMImageColumnImageView
 */
@property (nonatomic, strong) NSMutableArray *m_imageViewArray;

@end

@implementation DMImageColumnView

@synthesize verticalDistance = _verticalDistance;
@synthesize horizontalDistance = _horizontalDistance;
@synthesize columnCount = _columnCount;
@synthesize topMargin = _topMargin;
@synthesize leftMargin = _leftMargin;
@synthesize rightMargin = _rightMargin;
@synthesize bottomMargin = _bottomMargin;
@synthesize titleFont = _titleFont;
@synthesize titleColor = _titleColor;

#pragma mark - Life Cycle

- (void)dealloc
{
    [self columnImageViewRemove];
}

+ (instancetype)imageColumnView
{
    return [[self alloc] init];
}

+ (instancetype)imageColumnViewWithImageParamArray:(NSArray *)imageParamArray
{
    return [[self alloc] initWithImageParamArray:imageParamArray];
}

- (instancetype)initWithImageParamArray:(NSArray *)imageParamArray
{
    self = [self initWithFrame:CGRectZero];
    if (self)
    {
        self.imageParamArray = imageParamArray;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultSetting];
    }
    
    return self;
}

- (void)defaultSetting
{
    _titleAlignment = NSTextAlignmentCenter;
}

#pragma mark - SubView
- (void)columnImageViewRemove
{
    [self.m_imageViewArray enumerateObjectsUsingBlock:^(DMImageColumnImageView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    [self.m_imageViewArray removeAllObjects];
}

- (void)columnImageViewCreate
{
    [self columnImageViewRemove];
    
    [self.imageParamArray enumerateObjectsUsingBlock:^(DMImageColumnItem *obj, NSUInteger idx, BOOL *stop) {
        DMImageColumnImageView *view = [DMImageColumnImageView imageColumnImageViewWithItem:obj];
        view.titleAlignment = self.titleAlignment;
        view.titleColor = self.titleColor;
        view.titleFont = self.titleFont;
        view.showBorder = self.showBorder;
        view.delegate = self;
        view.tag = idx;
        
        [self addSubview:view];
        
        [self.m_imageViewArray addObject:view];
    }];
    
    [self columnImageViewAdjustFrame];
}

- (void)imageViewAdjustFrameHandler
{
    CGRect frame = CGRectZero;
    NSInteger viewTotalCount = self.m_imageViewArray.count;
    NSInteger columnCount = self.columnCount;
    CGFloat vDistance = self.verticalDistance;
    CGFloat hDistance = self.horizontalDistance;
    CGFloat leftMargin = self.leftMargin;
    CGFloat topMargin = self.topMargin;
    CGFloat rightMargin = self.rightMargin;
    NSInteger totalline = (viewTotalCount + (columnCount - 1)) / columnCount;
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    
    CGFloat tempW = (viewWidth - leftMargin - rightMargin);
    tempW = tempW - (columnCount - 1) * hDistance;
    CGFloat itemW = tempW / columnCount;
    CGFloat itemH = itemW;
    CGFloat x = 0;
    CGFloat y = topMargin;
    
    for (NSInteger i=0; i<totalline; i++)
    {
        x = leftMargin;
        
        for (NSInteger j=0; j<columnCount; j++)
        {
            NSInteger ID = i * columnCount + j;
            if (ID < viewTotalCount)
            {
                frame = CGRectMake(x, y, itemW, itemH);
                
                DMImageColumnImageView *itemView = self.m_imageViewArray[ID];
                itemView.frame = frame;
            }
            
            x += hDistance + itemW;
        }
        
        y += itemH;
        
        if ((i+1) < totalline)
        { //不是最后一个
            y += vDistance;
        }
    }
    
    if (totalline > 0)
    {
        if (self.isAutoAdjustFrame)
        {
            y += topMargin;
            self.frame = (CGRect){CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), viewWidth, y};
        }
    }
}


- (void)columnImageViewAdjustFrame
{
#if 1
    [self imageViewAdjustFrameHandler];
#else
    dispatch_async(dispatch_get_main_queue(), ^{
        [self imageViewAdjustFrameHandler];
    });
#endif
}


#pragma mark - setter / getter
- (CGFloat)verticalDistance
{
    if (_verticalDistance < 0.001)
    {
        _verticalDistance = kDMImageColumnVerticalDistance;
    }
    
    return _verticalDistance;
}

- (void)setVerticalDistance:(CGFloat)verticalDistance
{
    _verticalDistance = verticalDistance;
    
    [self columnImageViewAdjustFrame];
}

- (CGFloat)horizontalDistance
{
    if (_horizontalDistance < 0.001)
    {
        _horizontalDistance = kDMImageColumnHorizontalDistance;
    }
    
    return _horizontalDistance;
}

-(void)setHorizontalDistance:(CGFloat)horizontalDistance
{
    _horizontalDistance = horizontalDistance;
    
    [self columnImageViewAdjustFrame];
}

- (NSInteger)columnCount
{
    if (_columnCount < 1)
    {
        _columnCount = kDMImageColumnCount;
    }
    
    return _columnCount;
}

- (void)setColumnCount:(NSInteger)columnCount
{
    _columnCount = columnCount;
    
    [self columnImageViewAdjustFrame];
}

- (void)setShowBorder:(BOOL)showBorder
{
    _showBorder = showBorder;
    
    [self.m_imageViewArray enumerateObjectsUsingBlock:^(DMImageColumnImageView *obj, NSUInteger idx, BOOL *stop) {
        obj.showBorder = showBorder;
    }];
}

- (void)setTopMargin:(CGFloat)topMargin
{
    _topMargin = topMargin;
    
    [self columnImageViewAdjustFrame];
}

- (void)setLeftMargin:(CGFloat)leftMargin
{
    _leftMargin = leftMargin;
    
    [self columnImageViewAdjustFrame];
}

- (void)setRightMargin:(CGFloat)rightMargin
{
    _rightMargin = rightMargin;
    
    [self columnImageViewAdjustFrame];
}

- (void)setBottomMargin:(CGFloat)bottomMargin
{
    _bottomMargin = bottomMargin;
    
    [self columnImageViewAdjustFrame];
}

- (UIFont *)titleFont
{
    if (nil == _titleFont)
    {
        _titleFont = [UIFont systemFontOfSize:12];
    }
    
    return _titleFont;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    
    [self.m_imageViewArray enumerateObjectsUsingBlock:^(DMImageColumnImageView *obj, NSUInteger idx, BOOL *stop) {
        obj.titleFont = titleFont;
    }];
}

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment
{
    _titleAlignment = titleAlignment;
    
    [self.m_imageViewArray enumerateObjectsUsingBlock:^(DMImageColumnImageView *obj, NSUInteger idx, BOOL *stop) {
        obj.titleAlignment = titleAlignment;
    }];
}

- (UIColor *)titleColor
{
    if (nil == _titleColor)
    {
        _titleColor = [UIColor blackColor];
    }
    
    return _titleColor;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    
    [self.m_imageViewArray enumerateObjectsUsingBlock:^(DMImageColumnImageView *obj, NSUInteger idx, BOOL *stop) {
        obj.titleColor = titleColor;
    }];
}

- (NSMutableArray *)m_imageViewArray
{
    if (nil == _m_imageViewArray)
    {
        _m_imageViewArray = [[NSMutableArray alloc] init];
    }
    
    return _m_imageViewArray;
}

- (void)setAutoAdjustFrame:(BOOL)autoAdjustFrame
{
    _autoAdjustFrame = autoAdjustFrame;
    
    [self columnImageViewAdjustFrame];
}

- (void)setImageParamArray:(NSArray *)imageParamArray
{
    _imageParamArray = imageParamArray;
    
    [self columnImageViewCreate];
}

#pragma mark - DMImageColumnImageViewDelegate
- (void)imageColumnImageViewDidClick:(DMImageColumnImageView *)view
{
    if ([self.delegate respondsToSelector:@selector(imageColumnView:didClickIndex:)])
    {
        [self.delegate imageColumnView:self didClickIndex:view.tag];
    }
}


@end
