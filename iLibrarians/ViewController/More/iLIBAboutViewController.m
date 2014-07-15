//
//  iLIBAboutViewController.m
//  iLibrarians
//
//  Created by lanny on 12/6/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBAboutViewController.h"
#import "iLIBWebViewController.h"
#import <MessageUI/MessageUI.h>
@interface iLIBAboutViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation iLIBAboutViewController
@synthesize tableCellContent;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
-(void) initUserInterface{
    [self setTitle:@"关于我们"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUserInterface];
    NSArray *content = [[NSArray alloc] initWithObjects:@"关于iLibrarian",@"关于SYSU AppleClub",@"反馈意见",@"去评分",nil];
    self.tableCellContent = content;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableCellContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.textLabel setText:[self.tableCellContent objectAtIndex:indexPath.row]];
    // Configure the cell...
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 14;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    iLIBWebViewController *webView = [[iLIBWebViewController alloc] init];
    [webView setHidesBottomBarWhenPushed:YES];
    if(indexPath.row == 0){
        [webView setUrlString:@"http://www.applesysu.com/scripts/aboutisysulib"];
        [webView setTitle:@"about ilibrarians"];
        [self.navigationController pushViewController:webView animated:YES];
    }
    else if(indexPath.row ==1){
        [webView setUrlString:@"http://www.applesysu.com/scripts/aboutapplesysu"];
        [webView setTitle:@"about sysu apple club"];
        [self.navigationController pushViewController:webView animated:YES];
        
    }else if(indexPath.row == 2){
        [self sendFeedback];
    }else{
        [self rateOurApp];
    }
}

- (void)sendFeedback
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setToRecipients:[NSArray arrayWithObjects:@"applesysu2012@gmail.com", nil]];
        [mc setSubject:@"【iSYSU Library反馈意见】"];
        NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
        [dateformater setDateFormat:@"MM/dd/yyyy"];
        NSDate *date = [[NSDate alloc] init];
        NSString *messageBody = [NSString stringWithFormat:@"Model: %@ \n OS Version: %@ %@\n Date: %@ \n\n 您的反馈意见：", [[UIDevice currentDevice] name], [[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion],
                                 [dateformater stringFromDate:date]];
        [mc setMessageBody:messageBody isHTML:NO];
    
        [self presentViewController:mc animated:YES completion:nil];
    }
    else {
        [self launchMailAppOnDevice];
    }
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rateOurApp{
    //TO DO:

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

-(void)launchMailAppOnDevice

{
    
    NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
    
    NSString *body = @"&body=It is raining in sunny California!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    
}
@end
