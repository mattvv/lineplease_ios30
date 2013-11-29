//
//  ScriptViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/3/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "ScriptViewController.h"
#import "NSDate+TimeAgo.h"
#import "LPNavigationController.h"
#import "LineViewController.h"

@interface ScriptViewController ()
@end

@implementation ScriptViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.parseClassName = @"Script";
        self.textKey = @"name";
        
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self loadObjects];
    [super viewWillAppear:animated];
}

- (IBAction)openMenu:(id)sender {
    LPNavigationController *nav = (LPNavigationController *)self.navigationController;
    [nav toggleMenu];
}

#pragma mark - Parse
- (PFQuery *)queryForTable {
    /* check for both user and username matches*/
    PFQuery *usernameMatch = [PFQuery queryWithClassName:self.parseClassName];
    [usernameMatch whereKey:@"username" equalTo:[User currentUser][@"username"]];
    
//    PFQuery *userMatch = [PFQuery queryWithClassName:self.parseClassName];
//    [userMatch whereKey:@"user" equalTo:[User currentUser]];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[usernameMatch]];
    
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    return query;
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)script {
    static NSString *cellIdentifier = @"ScriptCell";
    
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = script[@"name"];
    cell.detailTextLabel.text = [script.createdAt timeAgo];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"lines" sender:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Script *script = (Script*)[self objectAtIndexPath:indexPath];
        [SVProgressHUD showWithStatus:@"Removing Script"];
        [script delete];
        [self loadObjects];
        [SVProgressHUD showSuccessWithStatus:@"Removed"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        LineViewController *lines = (LineViewController *) segue.destinationViewController;
        lines.script = (Script *) [self objectAtIndexPath:sender];
    }
}

#pragma mark - Height of Cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] >= [self.objects count]) {
        return 0;
    }
    Script *script = (Script *)[self objectAtIndexPath:indexPath];
    
    float height = [self calculateTextViewHeight:script[@"name"]];
    return height + 60;
}

- (float)calculateTextViewHeight:(NSString *)text
{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:17.f]}];
    
    return size.height;
}


#pragma mark - Load no scripts view!
- (void)objectsDidLoad:(NSError *)error {
    if ([self.objects count] > 0) {
        self.tableView.tableFooterView = nil;
    } else {
        self.tableView.tableFooterView = self.helpView;
    }
    [super objectsDidLoad:error];
}
@end
