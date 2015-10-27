//
//  SectionsViewController.m
//  Diario
//
//  Created by Abraham Estrada on 5/7/14.
//  Copyright (c) 2014 Abraham Estrada. All rights reserved.
//

#import "SectionsViewController.h"

@implementation SectionsViewController

@synthesize delegate, sections, sectionsTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sections = @[
        @[@"Portada",       @"frontpage"],
        @[@"Local",         @"local"],
        @[@"El Paso",       @"el_paso"],
        @[@"Estado",        @"estado"],
        @[@"Nacional",      @"nacional"],
        @[@"Internacional", @"internacional"],
        //@[@"NYT Diario",    @"nyt"],
        @[@"Espectaculos",  @"espectaculos"],
        @[@"Sociales",      @"sociales"],
        @[@"Deportes",      @"deportes"],
        @[@"Reporte de Puentes", @"bridges"],
        @[@"Tipo de Cambio", @"dollar"]
        //@[@"Municipio Interactivo", @"mi"]
    ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = self.sections[indexPath.row][0];
    cell.accessoryType = UITableViewCellAccessoryNone;

    if ([self.section isEqualToString:self.sections[indexPath.row][0]]) {
        sectionIndexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *sectionCell = [tableView cellForRowAtIndexPath:sectionIndexPath];
    sectionCell.accessoryType = UITableViewCellAccessoryNone;

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    if (![self.section isEqualToString:self.sections[indexPath.row][0]]) {
        NSString *slug = self.sections[indexPath.row][1];
        [self.delegate newSection:slug];
    }

    [self.sectionsTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
