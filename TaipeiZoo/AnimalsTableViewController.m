//
//  AnimalsTableViewController.m
//  TaipeiZoo
//
//  Created by Ruby on 2018/10/7.
//  Copyright © 2018年 Ruby. All rights reserved.
//

#import "AnimalsTableViewController.h"
#import "AnimalsTableViewCell.h"
#import "AnimalsMod.h"
#import "ImageDownloader.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define TAIPEI_OPEN_DATA_URL @"https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613"
#define MAX_CNT 30
#define LOAD_CNT 25

@interface AnimalsTableViewController (){
    NSInteger loadCnt; //已經取得api的次數
}
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) AnimalsMod *mod;
@property (nonatomic, strong) NSMutableArray *animalsAry;
@property (nonatomic, strong) NSNumber *totalCnt;
@end

@implementation AnimalsTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.animalsAry = [NSMutableArray new];
    self.mod = [AnimalsMod new];
    loadCnt = 1;
    //初始先取一次資料
    NSString *reqURL = [NSString stringWithFormat:@"%@&limit=%d", TAIPEI_OPEN_DATA_URL, MAX_CNT];
    
    [self.mod getAnimalsData:reqURL
                success:^(NSDictionary *resp) {
                    NSArray *ary = [resp objectForKey:@"animals"];
                    self.totalCnt = [resp objectForKey:@"totalCnt"];
                    [self.animalsAry addObjectsFromArray:ary];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                } failure:^(NSError *error){
                    
                }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"ary count: %ld", [self.animalsAry count]);
    return [self.animalsAry count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"AnimalCell";
    AnimalsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AnimalsTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    AnimalEntity *animal = [self.animalsAry objectAtIndex:indexPath.row];
    cell.cNameLabel.text = animal.cName;
    cell.locationLabel.text = animal.location;
    cell.contentLabel.text = animal.content;
    [cell.pictureImage sd_setImageWithURL:animal.pictureUrl placeholderImage:[UIImage imageNamed:@"imagePlaceholder"]];

    
    NSInteger index = indexPath.row+1;
    //提前5筆抓一次資料
    if (index%MAX_CNT==(MAX_CNT-5) && [self.animalsAry count]<=MAX_CNT*loadCnt && [self.animalsAry count]<[self.totalCnt integerValue]) {
        NSString *reqURL = [NSString stringWithFormat:@"%@&limit=%d&offset=%ld", TAIPEI_OPEN_DATA_URL, MAX_CNT, MAX_CNT*loadCnt];
        [self.mod getAnimalsData:reqURL
                           success:^(NSDictionary *resp) {
                               NSArray *ary = [resp objectForKey:@"animals"];
                               [self.animalsAry addObjectsFromArray:ary];
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self.tableView reloadData];
                               });
                           } failure:^(NSError *error){
                               
                           }];
        loadCnt++;
    }
    
    
    return cell;
}
//

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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
