//
//  iLIBWebViewController.m
//  iLibrarians
//
//  Created by lanny on 12/6/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBWebViewController.h"

@interface iLIBWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation iLIBWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestInfo];
    // Do any additional setup after loading the view from its nib.
}
- (void)requestInfo{
    MKNetworkEngine *engine = [[MKNetworkEngine alloc]initWithHostName:@"" customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithURLString:self.urlString params:nil httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *operation){
        [self.webView loadData:[operation responseData] MIMEType:nil textEncodingName:@"utf-8" baseURL:nil];
        
    }errorHandler:^(MKNetworkOperation *errorOp, NSError* err){
    //TO DO: show the error message
    }];
    [engine enqueueOperation:op];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if( navigationType == UIWebViewNavigationTypeLinkClicked){
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}
@end
