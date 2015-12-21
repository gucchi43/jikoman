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

@property (nonatomic) NSMutableArray *imgArray;

@property (nonatomic) NSData *imgData;

@property (nonatomic) NSData *imgData1;
@property (nonatomic) NSData *imgData2;
@property (nonatomic) NSData *imgData3;
@property (nonatomic) NSData *imgData4;



- (IBAction)sendButtonTap:(id)sender;

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
};


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
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController
          didFinishPickingAssets:(NSArray *)assets{
    
    NSLog(@"%@", assets);
    PHImageManager *manager = [PHImageManager defaultManager];
    
//    空のimgArray作成
    self.imgArray = @[].mutableCopy;

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
        
        
//        parse用のimageData取得
        [manager requestImageDataForAsset:obj
                                  options:nil
                            resultHandler:^(NSData * _Nullable imageData,
                                            NSString * _Nullable dataUTI,
                                            UIImageOrientation orientation,
                                            NSDictionary * _Nullable info) {
                                
                                self.imgData = imageData;
                                NSLog(@"requestImageDataForAsset = parse用のデータ");
                                [self makeImageData];
                            }];
        
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:nil];
}



//imgArrayのimgDataをそれぞれのNSDataに振り分ける
//requestImageDataForAsset毎に呼ばれる（1~4回）
- (void)makeImageData{
    [self.imgArray addObject:self.imgData];
    NSLog(@"makeImageData　なんこ？　%ld", self.imgArray.count);
//    for文が使えたらいいなーと思っておるのですが
        if ([self.imgArray count] == 1) {
            self.imgData1 = [self.imgArray objectAtIndex:0];
            NSLog(@"imgArray 1番目取り出し成功");
        }
        else if ([self.imgArray count] == 2) {
            self.imgData2 = [self.imgArray objectAtIndex:1];
            NSLog(@"imgArray 2番目取り出し成功");
        }
        else if ([self.imgArray count] == 3) {
            self.imgData3 = [self.imgArray objectAtIndex:2];
            NSLog(@"imgArray 3番目取り出し成功");
        }
        else if ([self.imgArray count] == 4) {
            self.imgData4 = [self.imgArray objectAtIndex:3];
            NSLog(@"imgArray 4番目取り出し成功");
        }
};



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
    NSLog(@"text　Parseに投げれたぜ！");
    
//    もっといい方法はないんでしょうか？（for文？）
//    imgData1~4までがあったらそれぞれPFFileに変換して、@"Img1~4"のカラムに入れる
    if (self.imgData1) {
        PFFile *imageFile1 = [PFFile fileWithName:@"img1" data:self.imgData1];
        ichizen[@"Img1"] = imageFile1;
        NSLog(@"Img1 Paraseに投げれたぜ！");
        
        if (self.imgData2) {
            PFFile *imageFile2 = [PFFile fileWithName:@"img2" data:self.imgData2];
            ichizen[@"Img2"] = imageFile2;
            NSLog(@"Img2 Paraseに投げれたぜ！");
            
            if (self.imgData3) {
                PFFile *imageFile3 = [PFFile fileWithName:@"img3" data:self.imgData3];
                ichizen[@"Img3"] = imageFile3;
                NSLog(@"Img3 Paraseに投げれたぜ！");
                
                 if (self.imgData4) {
                    PFFile *imageFile4 = [PFFile fileWithName:@"img4" data:self.imgData4];
                    ichizen[@"Img4"] = imageFile4;
                    NSLog(@"Img4 Paraseに投げれたぜ！");
                }
        }
    }
}
    
//    バックグラウンドでsave処理（saveInBackgroundWithBlock）
     [ichizen saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            NSLog(@"投稿失敗。 %@", error);
        } else {
            NSLog(@"投稿成功");
            // まえの画面(Post一覧)に遷移
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
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
