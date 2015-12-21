//
//  ImagePreviewView.m
//  jikoman
//
//  Created by HIroki Taniguti on 2015/12/07.
//  Copyright © 2015年 HIroki Taniguti. All rights reserved.
//

#import "ImagePreviewView.h"

@interface ImagePreviewView ()

@property (weak, nonatomic) UIView *contentView;
@property (nonatomic) CGSize layoutSize;

@end

@implementation ImagePreviewView

- (instancetype)init{
    self = [super init];
    
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}


- (void) commonInit {
    self.contentView = [self loadAndAddContentViewFromNibNamed:NSStringFromClass([self class])];
}
    
- (UIView *)loadAndAddContentViewFromNibNamed:(NSString *)nibNamed
{
    NSLog(@"nibNamed = %@", nibNamed);
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:nibNamed owner:self options:nil] firstObject];
    view.frame = self.bounds;
    view.translatesAutoresizingMaskIntoConstraints = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:view];
    return view;
}

/**
 *  画像をタップした時に呼ばれるメソッド。
 *  タップした画像を削除する。
 *
 *  @param sender タップした画像に当て込まれたUITapGestureRecognizer
 */
- (IBAction)deleteImageAction:(UIButton *)sender {
    [self.delegate deleteImage:sender.tag -21];
     NSLog(@"%ld", sender.tag );
}

- (void)setLayoutHeight:(CGFloat)height{
    _layoutSize.height = height;
    _layoutSize.width = [_contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    _layoutSize.width = round(_layoutSize.width);
    
    [self invalidateIntrinsicContentSize];
}


- (CGSize) intrinsicContentSize{
    // DO NOT call systemLayoutSizeFittingSize here.
    return _layoutSize;
}



@end
