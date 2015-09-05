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

#import "DMImageColumnImageView.h"
#import "DMImageColumnItem.h"
#import "UIImageView+WebCache.h"

@interface DMImageColumnImageView ()

@property (nonatomic, strong) UILabel *m_titleLabel;
@property (nonatomic, strong) UITapGestureRecognizer *m_tap;

@end

@implementation DMImageColumnImageView

@synthesize titleColor = _titleColor;
@synthesize titleFont = _titleFont;

#pragma mark - Life Cycle

- (void)dealloc
{
    [self sd_cancelCurrentImageLoad];
}

+ (instancetype)imageColumnImageView
{
    return [[self alloc] init];
}

+ (instancetype)imageColumnImageViewWithItem:(DMImageColumnItem *)item
{
    return [[self alloc] initWithItem:item];
}

- (instancetype)initWithItem:(DMImageColumnItem *)item
{
    self = [self initWithFrame:CGRectZero];
    if (self)
    {
        self.m_columnItem = item;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self defaultSetting];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
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
    [self tapCreate];
    [self titleLabelCreate];
    self.showBorder = YES;
    self.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self titleLabelAdd];
    
    [self titleLabelAdjustFrame];
}

#pragma mark - Sub View
- (void)titleLabelAdd
{
    if (![self.subviews containsObject:self.m_titleLabel])
    {
        [self addSubview:self.m_titleLabel];
    }
}

- (void)titleLabelAdjustFrame
{
    if (nil != self.m_titleLabel)
    {
        CGFloat w = CGRectGetWidth(self.frame);
        CGFloat h = 30;
        CGFloat x = 0;
        CGFloat y = CGRectGetHeight(self.frame) - h;
        self.m_titleLabel.frame = (CGRect){x, y, w, h};
    }
}

- (void)titleLabelCreate
{
    if (nil == self.m_titleLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = self.titleColor;
        label.font = self.titleFont;
        label.textAlignment = self.titleAlignment;

        self.m_titleLabel = label;
    }
}

#pragma mark - Event
- (void)tapCreate
{
    if (nil == self.m_tap)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        self.m_tap = tap;
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
    }
}

- (void)tapHandler:(UITapGestureRecognizer *)tap
{
    if (UIGestureRecognizerStateEnded == tap.state)
    {
        if ([self.delegate respondsToSelector:@selector(imageColumnImageViewDidClick:)])
        {
            [self.delegate imageColumnImageViewDidClick:self];
        }
    }
}

#pragma mark - setter / getter
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsLayout];
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
    
    self.m_titleLabel.textColor = titleColor;
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
    
    self.m_titleLabel.font = titleFont;
}

- (void)setM_columnItem:(DMImageColumnItem *)m_columnItem
{
    _m_columnItem = m_columnItem;
    
    self.m_titleLabel.text = m_columnItem.title;
    if ([m_columnItem.imageParam isKindOfClass:[UIImage class]])
    {
        self.image = m_columnItem.imageParam;
    }
    else if ([m_columnItem.imageParam isKindOfClass:[NSURL class]])
    {
        [self sd_setImageWithURL:m_columnItem.imageParam placeholderImage:m_columnItem.placeholderImage];
    }
}

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment
{
    _titleAlignment = titleAlignment;
    
    self.m_titleLabel.textAlignment = titleAlignment;
}

- (void)setShowBorder:(BOOL)showBorder
{
    _showBorder = showBorder;
    
    if (showBorder)
    {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor grayColor].CGColor;
    }
    else
    {
        self.layer.borderWidth = 0;
        self.layer.borderColor = nil;
    }
}



@end
