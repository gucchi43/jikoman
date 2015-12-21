//
//  SettingsTableViewController.m
//  jikoman
//
//  Created by HIroki Taniguti on 2015/11/20.
//  Copyright © 2015年 HIroki Taniguti. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *settingsTabelView;

@property (strong, nonatomic) NSArray * apple;
@property (strong, nonatomic) NSArray * bus;

@end

@implementation SettingsTableViewController

- (IBAction)unwindtoSubmit:(UIStoryboardSegue*)segue
{
    NSLog(@"SettingsTableView retun action");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//     デリゲートメソッドをこのクラスに実装
    self.settingsTabelView.delegate = self;
    self.settingsTabelView.dataSource = self;
    
    
//    テーブルに表示したいデータをセット
    self.apple = @[@"赤", @"果物"];
    self.bus = @[@"緑", @"乗り物"];
    
     [self.tableView registerClass:[UITableViewCell class]
            forCellReuseIdentifier:@"Cell"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/**
 テーブルに表示するデータ件数を返します。（必須）
 
 @return NSInteger : データ件数
 **/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    self.settingsTabelView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    NSInteger dataCount;
    
    switch (section) {
        case 0:
            dataCount = self.apple.count;
            break;
        case 1:
            dataCount = self.bus.count;
            break;
        default:
            break;
    }
    return dataCount;
}



/**
 テーブルに表示するセルを返します。
 
 @return UITableViewCell : テーブルセル
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
//    使い回し
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    使い回すCellがなかった場合
    if (!cell) {
        // 再利用できない場合は新規で作成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.apple[indexPath.row];
            break;
        case 1:
            cell.textLabel.text = self.bus[indexPath.row];
            break;
        default:
            break;
    }
    
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
