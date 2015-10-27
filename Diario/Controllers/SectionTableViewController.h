//
//  SectionTableViewController.h
//  Diario
//
//  Created by Abraham Estrada on 5/6/14.
//  Copyright (c) 2014 Abraham Estrada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "UIImageView+AFNetworking.h"

#import "SectionsViewController.h"
#import "ArticleViewController.h"
#import "ArticleCell.h"
#import "ArticleImageCell.h"

@interface SectionTableViewController : UITableViewController {
    UIButton *reloadSectionButton;
}

@property (strong) NSString *url;
@property (strong) NSDictionary *section;

- (IBAction)showSections:(id)sender;
- (void) newSection:(NSString *)slug;

@end
