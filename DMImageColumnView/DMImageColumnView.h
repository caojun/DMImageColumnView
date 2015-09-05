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

#import <UIKit/UIKit.h>

@class DMImageColumnView;
@class DMImageColumnItem;

extern const CGFloat kDMImageColumnHorizontalDistance;
extern const CGFloat kDMImageColumnVerticalDistance;
extern const NSInteger kDMImageColumnCount;


#pragma mark - DMImageColumnViewDelegate
@protocol DMImageColumnViewDelegate <NSObject>

@optional
- (void)imageColumnView:(DMImageColumnView *)view didClickIndex:(NSInteger)index;

@end


#pragma mark - DMImageColumnView


@interface DMImageColumnView : UIView

/**
 *  垂直间隙，默认 10
 */
@property (nonatomic, assign) CGFloat verticalDistance;
/**
 *  水平间隙，默认 10
 */
@property (nonatomic, assign) CGFloat horizontalDistance;
/**
 *  列数量， 默认 2
 */
@property (nonatomic, assign) NSInteger columnCount;

/**
 *  是否显示图片边框, 默认 YES
 */
@property (nonatomic, assign, getter=isShowBorder) BOOL showBorder;


@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) CGFloat bottomMargin;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) NSTextAlignment titleAlignment;
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, assign, getter=isAutoAdjustFrame) BOOL autoAdjustFrame;

/**
 *  存放 DMImageColumnItem
 */
@property (nonatomic, strong) NSArray *imageParamArray;

/**
 *  代理
 */
@property (nonatomic, weak) IBOutlet id<DMImageColumnViewDelegate> delegate;

+ (instancetype)imageColumnView;
+ (instancetype)imageColumnViewWithImageParamArray:(NSArray *)imageParamArray;
- (instancetype)initWithImageParamArray:(NSArray *)imageParamArray;

@end
