//
//  iLIBMoreAppsViewController.m
//  iLibrarians
//
//  Created by lanny on 12/7/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBMoreAppsViewController.h"
#import "MKNetworkKit.h"
#import "iLIBAppItemCell.h"
#import "iLIBEngine.h"
#import "iLIBAppDelegate.h"
@interface iLIBMoreAppsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSDictionary *appItems;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) iLIBEngine *engine;
@end

@implementation iLIBMoreAppsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) initUserInterface{
    [self setTitle:@"更多应用"];
    [self loadLocalAppItems];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUserInterface];
    [self updateAppItem];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)loadLocalAppItems
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"localAppItems.plist"];
    self.appItems = [[NSDictionary alloc] initWithContentsOfFile:path];
}

- (void)saveLocalAppItems
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"localAppItems.plist"];
    [self.appItems writeToFile:path atomically:YES];
}



- (void)updateAppItem {
    NSUInteger currentVersion = [[self.appItems valueForKey:@"version"] integerValue];
    self.engine = ((iLIBAppDelegate*)([UIApplication sharedApplication].delegate)).iLibEngine;
    
    [self.engine requestAppItems:^(NSDictionary *result){
        NSUInteger newVersion = [[result valueForKey:@"version"] integerValue];
        if( newVersion > currentVersion){
            self.appItems = result;
            [self saveLocalAppItems];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:YES];
        }
    }onError:^(NSError *engineError) {
        NSLog(@"Request appItems error");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.appItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MoreAppItemCell";
    iLIBAppItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"iLIBAppItemCell" owner:nil options:nil];
        cell=nib[0];
        
        UIImage *backgroundImage = [UIImage imageNamed:@"app_cell_background"];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:backgroundImage]];
        
        cell.iconImageView.layer.borderColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1].CGColor;
        cell.iconImageView.layer.masksToBounds= YES;
        cell.iconImageView.layer.cornerRadius= 8.0f;
        cell.iconImageView.layer.borderWidth = 1.0f;
    }
    
    NSDictionary *appItem = [self.appItems valueForKey:@"apps"][indexPath.row];
    
    NSURL *openUrl = [NSURL URLWithString:[appItem valueForKey:@"openUrl"]];
    if ([[UIApplication sharedApplication] canOpenURL:openUrl]) {
        [cell.sideButton setTitle:@"打开" forState:UIControlStateNormal];
    } else {
        [cell.sideButton setTitle:@"下载" forState:UIControlStateNormal];
    }
    
    cell.titleLabel.text = [appItem valueForKey:@"title"];
    cell.descriptionLabel.text = [appItem valueForKey:@"description"];
    [cell.iconImageView setImageFromURL:[NSURL URLWithString:[appItem valueForKey:@"imageUrl"]] placeHolderImage:[UIImage imageNamed:@"bookImage.png"]];
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *appItem = [self.appItems valueForKey:@"apps"][indexPath.row];
    
    NSURL *openUrl = [NSURL URLWithString:[appItem valueForKey:@"openUrl"]];
    if ([[UIApplication sharedApplication] canOpenURL:openUrl]) {
        [[UIApplication sharedApplication] openURL:openUrl];
    } else {
        NSURL *appStoreUrl = [NSURL URLWithString:[appItem valueForKey:@"appStoreUrl"]];
        [[UIApplication sharedApplication] openURL:appStoreUrl];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
