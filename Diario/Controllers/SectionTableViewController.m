//
//  SectionTableViewController.m
//  Diario
//
//  Created by Abraham Estrada on 5/6/14.
//  Copyright (c) 2014 Abraham Estrada. All rights reserved.
//

#import "SectionTableViewController.h"

@implementation SectionTableViewController

@synthesize url, section;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    if (!self.refreshControl) {
        UIRefreshControl *refresh= [[UIRefreshControl alloc] init];
        refresh.tintColor = [UIColor colorWithRed:0/255.0f green:56/255.0f blue:75/255.0f alpha:1.0f];
        [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refresh;
    }

    self.section = nil;
    self.url = @"http://YOUR-API-URL.COM/api/section/frontpage";
    [self loadArticles];
}

- (void)refresh:(id)sender {
    self.section = nil;
    [self loadArticles];
}

- (void) newSection:(NSString *)slug {
    self.url = [NSString stringWithFormat:@"http://YOUR-API-URL.COM/api/section/%@", slug];
    self.navigationItem.title = @"Diario";
    self.section = nil;
    [self.tableView reloadData];
    [self loadArticles];
}

- (void)loadArticles {
    [reloadSectionButton removeFromSuperview];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:self.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.section = responseObject;

        if ([[self.section objectForKey:@"success"] intValue] == 1) {
            self.navigationItem.title = [self.section objectForKey:@"title"];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.tableView reloadData];

        } else {
            [self showError];
        }
        [self.refreshControl endRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showError];
    }];
}

- (void)showError {
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Lo sentimos, hubo un error.\nFavor de intentar de nuevo."
                                                             message:@""
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
    [errorAlertView show];
    [self.refreshControl endRefreshing];
    NSArray *articles = [self.section objectForKey:@"articles"];
    if (articles.count == 0) {
        reloadSectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reloadSectionButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchDown];
        [reloadSectionButton setImage:[UIImage imageNamed:@"Refresh"] forState:UIControlStateNormal];
        [reloadSectionButton sizeToFit];
        reloadSectionButton.center = CGPointMake(self.view.center.x, 100.0);

        [self.view addSubview:reloadSectionButton];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.section != nil) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.section != nil) {
        return [[self.section objectForKey:@"articles"] count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *articles = [self.section objectForKey:@"articles"];
    NSDictionary *article = [articles objectAtIndex:indexPath.row];

    if ([article objectForKey:@"image"]) {
        __weak ArticleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleImageCell" forIndexPath:indexPath];
        cell.title.text = [article objectForKey:@"title"];
        cell.image.image = nil;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[article objectForKey:@"image"]]];
        [cell.image setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        cell.image.image = image;
                                   } failure:nil];
        if ([article objectForKey:@"url"] == nil) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;

    } else {
        ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell" forIndexPath:indexPath];
        cell.title.text = [article objectForKey:@"title"];
        if ([article objectForKey:@"url"] == nil) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *articles = [self.section objectForKey:@"articles"];
    NSDictionary *article = [articles objectAtIndex:indexPath.row];
    if ([article objectForKey:@"url"]) {
        ArticleViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleView"];
        avc.api = [self.section objectForKey:@"api"];
        avc.url = [article objectForKey:@"url"];
        [self.navigationController pushViewController:avc animated:YES];

        //[self performSegueWithIdentifier:@"ArticleViewSegue" sender:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ArticleViewSegue"]) {
        //ArticleViewController *avc = [segue destinationViewController];

        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSLog(@"%ld", (long)indexPath.row);

    } else if ([segue.identifier isEqualToString:@"SectionsSegue"]) {
        SectionsViewController *svc = [segue destinationViewController];
        svc.section = self.navigationItem.title;
        [svc setDelegate:self];
        [self.refreshControl endRefreshing];
    }
}

- (IBAction)showSections:(id)sender {
    [self performSegueWithIdentifier:@"SectionsSegue" sender:self];
}
@end
