//
//  OtherGoodTableViewController.m
//  jikoman
//
//  Created by HIroki Taniguti on 2015/11/20.
//  Copyright © 2015年 HIroki Taniguti. All rights reserved.
//

#import "OtherGoodTableViewController.h"

@interface OtherGoodTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *otherTableView;
@property (strong ,nonatomic) NSArray *imgArray;
@property (strong, nonatomic) NSArray *label2Array;


@end

@implementation OtherGoodTableViewController





- (IBAction)unwindtoSubmit:(UIStoryboardSegue*)segue
{
    NSLog(@"OtherGoodTableView retun action");
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    デリゲートメソッドをこのクラスで実装する
//    self.otherTableView.delegate = self;
//    self.otherTableView.dataSource = self;
    
//    ひとまず８このデータの配列を置いとく
    
    self.imgArray = @[@"img0.JPG",@"img1.JPG",@"img2.JPG",@"img3.JPG",
                 @"img4.JPG",@"img5.JPG",@"img6.JPG",@"img7.JPG"];
    
    self.label2Array = @[@"2013/8/23/16:04",@"2013/8/23/16:15",@"2013/8/23/16:47",@"2013/8/23/17:10",
                    @"2013/8/23/1715:",@"2013/8/23/17:21",@"2013/8/23/17:33",@"2013/8/23/17:41"];
    
//    [self.tableView registerClass:[UITableViewCell class]
//           forCellReuseIdentifier:@"Cell"];
    
    [self.refreshControl addTarget:self action:@selector(updateCells) forControlEvents:UIControlEventValueChanged];
}

- (void)updateCells{
    NSLog(@"引張リング");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//セクション数を返す（大きなグループみたいな枠組み）
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//１つのセクションに返すセルの数
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.imgArray.count;
}



//テーブルに表示するセルを返す
//
//
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    再利用できるセルがあれば再利用する
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
////    再利用できないセルがなければ新規で生成する
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
//                                     reuseIdentifier:cellIdentifer];
//    }
    
    UILabel *label1 = [cell viewWithTag:1];
    label1.text = self.label2Array[indexPath.row];
    
    UILabel *label2 = [cell viewWithTag:2];
    label2.text = [NSString stringWithFormat:@"No.%d", (int)(indexPath.row + 1)];
    
    UIImage *img = [UIImage imageNamed:self.imgArray[indexPath.row]];
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:3];
    imgView.image = img;
    
//    cell.textLabel.text = [[NSString alloc]initWithFormat:@"%ld行目のセル", indexPath.row + 1];
    
    return cell;
}


@end
