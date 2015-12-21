//
//  SubmitViewController.m
//  jikoman
//
//  Created by HIroki Taniguti on 2015/11/20.
//  Copyright © 2015年 HIroki Taniguti. All rights reserved.
//

#import "SubmitViewController.h"

#import <Parse/Parse.h>

#import "ImagePreviewView.h"
#import <QBImagePickerController.h>


@interface SubmitViewController () <QBImagePickerControllerDelegate,ImagePreviewViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *submitTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dockViewHeightConstraint;

@property (nonatomic)QBImagePickerController *imagePickerController;
@property (nonatomic)ImagePreviewView *imagePreviewView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end



@implementation SubmitViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imagePreviewView = [[ImagePreviewView alloc]initWithFrame:self.scrollView.bounds];
    self.imagePreviewView.delegate = self;
    self.imagePreviewView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.imagePreviewView];
    //
    // Add Constraints after addSubview.
    // This is long code. You'd better to add a category method on UIScrollView.
    //
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.imagePreviewView
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0f
                                                                 constant:0]];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.imagePreviewView
                                                                attribute:NSLayoutAttributeLeading
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeLeading
                                                               multiplier:1.0f
                                                                 constant:0]];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.imagePreviewView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0f
                                                                 constant:0]];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.imagePreviewView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f
                                                                 constant:0]];
    
//    
//
//    NSNotificationCenterにてキーボードの表示/非表示の通知を登録
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.submitTextView becomeFirstResponder];
}

- (void)viewDidLayoutSubviews{
    [self.imagePreviewView setLayoutHeight:self.scrollView.bounds.size.height];
    [self resizePreview];
}


//戻る遷移
- (IBAction)unwindtoSubmit:(UIStoryboardSegue*)segue
{
    NSLog(@"SubmitView retun action");
}


//キーボードの上のViewについて
- (void)showKeyboard:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.01 animations:^{
        self.dockViewHeightConstraint.constant = keyboardRect.size.height + 60;
        [self.view layoutIfNeeded];
    }];
}

- (void)hideKeyboard:(NSNotification *)notification {
    [UIView animateWithDuration:0.01 animations:^{
        self.dockViewHeightConstraint.constant = 60;
        [self.view layoutIfNeeded];
    }];
}



//カメラボタンのアクション
- (IBAction)changePhoto:(id)sender {
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

//
//プレビュー画像の再セット
//
- (void)reloadPreview{
    [self.imagePickerController.selectedAssets.array enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = (UIImageView *)[self.imagePreviewView viewWithTag:idx + 11];
        PHImageManager *manager = [PHImageManager defaultManager];
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        [manager requestImageForAsset:asset
                           targetSize:imageView.bounds.size
                          contentMode:PHImageContentModeAspectFit
                              options:options
                        resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                            imageView.image = result;
                        }];
    }];
}

//
//プレビュー画面のリサイズ
//
- (void)resizePreview{
    CGSize size = [self.imagePreviewView viewWithTag:1].bounds.size;
    if (self.imagePickerController.selectedAssets.count < 2) {
        self.scrollView.contentSize = self.scrollView.bounds.size;
    } else {
        size.width = size.width *self.imagePickerController.selectedAssets.count;
        self.scrollView.contentSize = size;
    }
}

#pragma mark - QBImagePickerControllerDelegate method
//とってきたデータをimageに変換する
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    NSLog(@"%@", assets);
    PHImageManager *manager = [PHImageManager defaultManager];
    
//    選択した配列でしこループ
//    第一引数に配列データ、
//    第二引数に何番目のデータなのかを表す数値データ、
//    第三引数にループを終了するか判定
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%ld回目のしこしこ", idx);
        UIView *view = [self.imagePreviewView viewWithTag:idx + 1];
        UIImageView *imageview = (UIImageView *)[self.imagePreviewView viewWithTag:idx + 11];
        
        view.hidden = NO;
        
//        取ってくる画像のオプション条件
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        
        [manager requestImageForAsset:obj
                           targetSize:[self.imagePreviewView viewWithTag:1].bounds.size
                          contentMode:PHImageContentModeAspectFit
                              options:options
                        resultHandler:^(UIImage * _Nullable result,
                                        NSDictionary * _Nullable info)
        {
//        PHAssetのデータをimegeに変換してimageviewに表示
            imageview.image = result;
        }];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)deleteImage:(NSInteger)selectedINndex{
    UIView *lastView = [self.imagePreviewView viewWithTag:self.imagePickerController.selectedAssets.count];
    UIImageView *lastImageView = (UIImageView *)[self.imagePreviewView viewWithTag:self.imagePickerController.selectedAssets.count + 10];
    [self.imagePickerController.selectedAssets removeObjectAtIndex:selectedINndex];
    lastImageView.image = nil;
    lastView.hidden = YES;
    
    [self reloadPreview];
    [self resizePreview];
}


- (QBImagePickerController *)imagePickerController{
    if (!_imagePickerController) {
        _imagePickerController = [QBImagePickerController new];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsMultipleSelection = YES;
        _imagePickerController.maximumNumberOfSelection = 4;
    }
    return _imagePickerController;
}

//ジコマンボタンのアクション（Post機能）
//
- (IBAction)sendButtonTap:(id)sender {
    NSLog(@"ジコマン押した");
    PFObject *ichizen = [PFObject objectWithClassName:@"Ichizen"];
    ichizen[@"text"] = self.submitTextView.text;
    
    if (self.imagePickerController.selectedAssets.count > 0) {
        PHImageManager *manager = [PHImageManager defaultManager];
        [self.imagePickerController.selectedAssets enumerateObjectsUsingBlock:^(PHAsset *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // parse用のimageData取得
            [manager requestImageDataForAsset:obj
                                      options:nil
                                resultHandler:^(NSData * _Nullable imageData,
                                                NSString * _Nullable dataUTI,
                                                UIImageOrientation orientation,
                                                NSDictionary * _Nullable info) {
                                    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"img%ld", idx + 1] data:imageData];
                                    ichizen[[NSString stringWithFormat:@"Img%ld", idx + 1]] = imageFile;
                                    if (idx + 1 == self.imagePickerController.selectedAssets.count) {
                                        NSLog(@"最後？");
                                        NSLog(@"text　Parseに投げれたぜ！");
                                        [ichizen saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                            if (!succeeded) {
                                                NSLog(@"投稿失敗。 %@", error);
                                            } else {
                                                NSLog(@"投稿成功");
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                            }
                                        }];
                                    }
                                }];
        }];
    } else {
        [ichizen saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!succeeded) {
                NSLog(@"投稿失敗。 %@", error);
            } else {
                NSLog(@"投稿成功");
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
