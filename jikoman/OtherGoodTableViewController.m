//
//  OtherGoodTableViewController.m
//  jikoman
//
//  Created by HIroki Taniguti on 2015/11/20.
//  Copyright © 2015年 HIroki Taniguti. All rights reserved.
//

#import "OtherGoodTableViewController.h"

#import <Parse/Parse.h>

@interface OtherGoodTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *otherTableView;
@property (nonatomic) NSMutableArray *items;

@end

@implementation OtherGoodTableViewController

- (IBAction)unwindtoSubmit:(UIStoryboardSegue*)segue
{
    NSLog(@"OtherGoodTableView retun action");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.refreshControl addTarget:self action:@selector(updateCells) forControlEvents:UIControlEventValueChanged];
    [self loadItems];
}

- (void)loadItems {
    PFQuery *query = [PFQuery queryWithClassName:@"Ichizen"];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [objects enumerateObjectsUsingBlock:^(PFObject *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.items addObject:obj];
        }];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
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
    return self.items.count;
}

//テーブルに表示するセルを返す
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    再利用できるセルがあれば再利用する
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    PFObject *ichizen = self.items[indexPath.row];
    
//    UILabel *label1 = [cell viewWithTag:1];
//    label1.text = self.label2Array[indexPath.row];
    
    UILabel *label2 = [cell viewWithTag:2];
    label2.text = ichizen[@"text"];
    
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:3];
    PFFile *imageFile = ichizen[@"Img1"];
    if (imageFile) {
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                imgView.image = [UIImage imageWithData:data];
            } else {
                NSLog(@"%@", error);
                imgView.image = nil;
                imgView.backgroundColor = [UIColor darkGrayColor];
            }
        }];
    } else {
        imgView.image = nil;
        imgView.backgroundColor = [UIColor darkGrayColor];
    }
    
//    cell.textLabel.text = [[NSString alloc]initWithFormat:@"%ld行目のセル", indexPath.row + 1];
    
    return cell;
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = @[].mutableCopy;
    }
    return _items;
}

@end
