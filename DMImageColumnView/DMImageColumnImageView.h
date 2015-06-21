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

@class DMImageColumnItem;
@class DMImageColumnImageView;

@protocol DMImageColumnImageViewDelegate <NSObject>

@optional
- (void)imageColumnImageViewDidClick:(DMImageColumnImageView *)view;

@end


IB_DESIGNABLE
@interface DMImageColumnImageView : UIImageView

@property (nonatomic, strong) DMImageColumnItem *m_columnItem;

@property (nonatomic, strong) IBInspectable UIColor *titleColor;
@property (nonatomic, strong) IBInspectable UIFont *titleFont;
@property (nonatomic, assign) IBInspectable NSTextAlignment titleAlignment;
/**
 *  是否显示图片边框, 默认 YES
 */
@property (nonatomic, assign, getter=isShowBorder) IBInspectable BOOL showBorder;

@property (nonatomic, weak) IBOutlet id<DMImageColumnImageViewDelegate> delegate;

+ (instancetype)imageColumnImageView;
+ (instancetype)imageColumnImageViewWithItem:(DMImageColumnItem *)item;
- (instancetype)initWithItem:(DMImageColumnItem *)item;

@end
