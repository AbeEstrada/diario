//
//  SectionsViewController.h
//  Diario
//
//  Created by Abraham Estrada on 5/7/14.
//  Copyright (c) 2014 Abraham Estrada. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SectionTableViewController.h"

@interface SectionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIBarPositioningDelegate> {
    NSIndexPath *sectionIndexPath;
}

@property (nonatomic, assign) id delegate;
@property (strong) NSString *section;
@property (strong) NSArray *sections;
@property (strong, nonatomic) IBOutlet UITableView *sectionsTableView;

@end
