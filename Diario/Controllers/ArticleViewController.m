//
//  ArticleViewController.m
//  Diario
//
//  Created by Abraham Estrada on 5/6/14.
//  Copyright (c) 2014 Abraham Estrada. All rights reserved.
//

#import "ArticleViewController.h"

@implementation ArticleViewController

@synthesize api, url, article, articleWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    articleWebView.delegate = self;

    NSString *file = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"html" inDirectory:nil];
    NSString *html = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];

    [self.articleWebView loadHTMLString:html baseURL:nil];

    NSString *urlEncoded = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"http://YOUR-API-URL.COM%@%@", self.api, urlEncoded] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.article = responseObject;

        if ([[self.article objectForKey:@"success"] intValue] == 1) {
            NSString *file = [[NSBundle mainBundle] pathForResource:@"article" ofType:@"html" inDirectory:nil];
            NSString *html = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];

            NSString *swipe = [[NSBundle mainBundle] pathForResource:@"swipe" ofType:@"js" inDirectory:nil];
            NSString *swipejs = [NSString stringWithContentsOfFile:swipe encoding:NSUTF8StringEncoding error:nil];

            html = [html stringByReplacingOccurrencesOfString:@"{{swipejs}}" withString:swipejs];

            NSData *data = [NSJSONSerialization dataWithJSONObject:self.article options:0 error:nil];
            NSString *json = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];

            html = [html stringByReplacingOccurrencesOfString:@"{{json}}" withString:json];
            
            [self.articleWebView loadHTMLString:html baseURL:nil];

        } else {
            [self showError];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showError];
    }];
}

- (void)showError {
    self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;

    NSString *file = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"html" inDirectory:nil];
    NSString *html = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];

    [self.articleWebView loadHTMLString:html baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebView Delegate

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }

    return YES;
}
- (void) webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction) shareOptions:(id)sender {
    if (self.article) {
        NSString *title = [self.article objectForKey:@"title"];
        NSURL *source = [NSURL URLWithString:[self.article objectForKey:@"source"]];
        NSArray *activityItems = @[title, source];
        NSArray *excludeActivities = @[UIActivityTypeMessage, UIActivityTypeAssignToContact];
        TUSafariActivity *safariActivity = [[TUSafariActivity alloc] init];
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[safariActivity]];
        activityController.excludedActivityTypes = excludeActivities;
        activityController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *error) {
            [self activityCompletionHandler:activityType completed:completed];
        };

        [self presentViewController:activityController animated:YES completion:nil];
    }
}

- (void) activityCompletionHandler:(NSString *)activityType completed:(BOOL)completed {}

@end
