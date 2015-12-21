//
//  OtherGoodTableViewController.m
//  jikoman
//
//  Created by HIroki Taniguti on 2015/11/20.
//  Copyright © 2015年 HIroki Taniguti. All rights reserved.
//

#import "OtherGoodTableViewController.h"

@interface OtherGoodTableViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *otherTableView;




@end

@implementation OtherGoodTableViewController

NSArray *imgArray;
NSArray *label2Array;



- (IBAction)unwindtoSubmit:(UIStoryboardSegue*)segue
{
    NSLog(@"OtherGoodTableView retun action");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    デリゲートメソッドをこのクラスで実装する
//    self.otherTableView.delegate = self;
//    self.otherTableView.dataSource = self;
    
    imgArray = @[@"img0.JPG",@"img1.JPG",@"img2.JPG",@"img3.JPG",
                 @"img4.JPG",@"img5.JPG",@"img6.JPG",@"img7.JPG"];
    
    label2Array = @[@"2013/8/23/16:04",@"2013/8/23/16:15",@"2013/8/23/16:47",@"2013/8/23/17:10",
                    @"2013/8/23/1715:",@"2013/8/23/17:21",@"2013/8/23/17:33",@"2013/8/23/17:41"];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"Cell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

////セクション数を返す（大きなグループみたいな枠組み）
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}


//１つのセクションに返すセルの数
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    

    return 5;
}




//テーブルに表示するセルを返す
//
//
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifer = @"Cell";
    
//    再利用できるセルがあれば再利用する
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
////    再利用できないセルがなければ新規で生成する
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
//                                     reuseIdentifier:cellIdentifer];
//    }
    
    UILabel *label1 = [cell viewWithTag:1];
    label1.text = label2Array[indexPath.row];
    
    UILabel *label2 = [cell viewWithTag:2];
    label2.text = [NSString stringWithFormat:@"No.%d", (int)(indexPath.row + 1)];
    
    UIImage *img = [UIImage imageNamed:imgArray[indexPath.row]];
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:3];
    imgView.image = img;
    
//    cell.textLabel.text = [[NSString alloc]initWithFormat:@"%ld行目のセル", indexPath.row + 1];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
