//
//  ArticleViewController.h
//  Diario
//
//  Created by Abraham Estrada on 5/6/14.
//  Copyright (c) 2014 Abraham Estrada. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFNetworking.h"
#import "TUSafariActivity.h"

@interface ArticleViewController : UIViewController <UIWebViewDelegate>

@property (strong) NSString *api;
@property (strong) NSString *url;
@property (strong) NSDictionary *article;
@property (strong, nonatomic) IBOutlet UIWebView *articleWebView;
- (IBAction)shareOptions:(id)sender;

@end
