//
//  ImagePreviewView.h
//  jikoman
//
//  Created by HIroki Taniguti on 2015/12/07.
//  Copyright © 2015年 HIroki Taniguti. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagePreviewViewDelegate <NSObject>

- (void)deleteImage:(NSInteger)selectedINndex;

@end


@interface ImagePreviewView : UIView

@property (weak, nonatomic)id <ImagePreviewViewDelegate>delegate;

- (void)setLayoutHeight:(CGFloat)height;
@end
