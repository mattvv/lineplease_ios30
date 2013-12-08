//
//  LineViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/4/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "LineViewController.h"
#import "Line.h"
#import "LPNavigationController.h"
#import "EditLineViewController.h"

#define FONT_SIZE 17.0f

@interface LineViewController ()

@end

@implementation LineViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.parseClassName = @"Line";
        self.textKey = @"line";
        
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 2000;
        self.speaker = [[Speaker alloc] init];
        self.speaker.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = self.script[@"name"];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    
    /* Adding the Swipe Actions */

    
}

- (IBAction)openMenu:(id)sender {
    LPNavigationController *nav = (LPNavigationController *)self.navigationController;
    [nav toggleLinesMenu];
}

- (IBAction)openPlayMenu:(UIBarButtonItem *)sender {
    //KxMenu for Play/Stop button
    __block LineViewController *bSelf = self;
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    for (NSString *character in [self getCharacters]) {
        [menuItems addObject:[[REMenuItem alloc] initWithTitle:character
                                                      subtitle:[NSString stringWithFormat:@"%@'s lines will be silent", character]
                                                         image:nil
                                              highlightedImage:nil
                                                        action:^(REMenuItem *item) {
                                                            [bSelf playCharacter:character];
                                                        }]];
    }
    
    [menuItems addObject:[[REMenuItem alloc] initWithTitle:@"All"
                                                  subtitle:@"Listen to all characters lines"
                                                     image:nil
                                          highlightedImage:nil
                                                    action:^(REMenuItem *item) {
                                                        [bSelf playCharacter:@"Play All"];
                                                    }]];
    
    LPNavigationController *nav = (LPNavigationController *) self.navigationController;
    [nav displayCharacterMenu:menuItems];
}

- (void)playCharacter:(NSString*) character {
    if ([character isEqualToString:@"Play All"]) {
        
    }
    
    [self.speaker startSpeaking:self.objects withCharacter:character];
    
    //setup the barbutton items
//    self.navigationItem.leftBarButtonItem.title = @"Pause";
//    self.navigationItem.leftBarButtonItem.action = @selector(pause:);
    self.navigationItem.rightBarButtonItem.title = @"Stop";
    self.navigationItem.rightBarButtonItem.action = @selector(stop:);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadObjects];
}
- (void) viewDidDisappear:(BOOL)animated {
    [self.speaker stopSpeaking];
    [super viewDidDisappear:animated];
}

#pragma mark - Parse
- (PFQuery *)queryForTable {
    /* check for both user and username matches*/
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"scriptId" equalTo:[self.script objectId]];
    
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"position"];
    return query;
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)line {
    static NSString *cellIdentifier = @"LineCell";
    
    MSCMoreOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MSCMoreOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self formatLine:line];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

- (NSString *) formatLine: (PFObject *) line {
    NSString *name = [line[@"character"] uppercaseString];
    return [NSString stringWithFormat:@"%@\n%@",name,line[@"line"]];
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleNone;
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Edit/Delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Script *script = (Script*)[self objectAtIndexPath:indexPath];
        [SVProgressHUD showWithStatus:@"Removing Script"];
        [script delete];
        [self loadObjects];
        [SVProgressHUD showSuccessWithStatus:@"Removed"];
    }
}

- (void)tableView:(UITableView *)tableView moreOptionButtonPressedInRowAtIndexPath:(NSIndexPath *)indexPath {
    Line *line = (Line*)[self objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"createLine" sender:line];
}

- (NSString *)tableView:(UITableView *)tableView titleForMoreOptionButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Edit";
}

- (UIColor *)tableView:(UITableView *)tableView backgroundColorForMoreOptionButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIColor colorWithRed:195/255.f green:182/255.f blue:217/255.f alpha:1.0];
}

#pragma mark - dragging
- (void)startDragging:(id)sender {
    [self.tableView setEditing:YES animated:YES];
    
    self.navigationItem.rightBarButtonItem.title = @"End";
    self.navigationItem.rightBarButtonItem.action = @selector(stopDragging:);
}

- (void)stopDragging:(id)sender {
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem.title = @"Rehearse";
    self.navigationItem.rightBarButtonItem.action = @selector(openPlayMenu:);
}

- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    //todo: update Parse with move
    [self stopDragging:self];
    
    //set the
    Line *line = (Line *)[self objectAtIndexPath:fromIndexPath];
    NSNumber *position = [NSNumber numberWithInt:toIndexPath.row];
    
    NSLog(@"Reodering Line");
    
    [PFCloud callFunctionInBackground:@"reorderLines"
                       withParameters:@{@"lineId": line.objectId,
                                        @"scriptId": self.script.objectId,
                                        @"position": position}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        [self loadObjects];
                                    } else {
                                        NSLog(@"Error! %@", [error localizedDescription]);
                                    }
                                }];
    
}


#pragma mark - Height of Cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Line *line = (Line *) [self objectAtIndexPath:indexPath];
    
    
    float height = [self calculateTextViewHeight:[self formatLine:line]];
    
    return height + 60;
}

- (float)calculateTextViewHeight:(NSString *)text
{
    NSAttributedString *newText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:FONT_SIZE]}];
    
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:newText];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(300.0, FLT_MAX)];
    return size.height;
}

#pragma mark - get characters
- (NSMutableArray *) getCharacters {
    NSMutableArray * characters = [[NSMutableArray alloc] init];
    for (Line* line in self.objects) {
        NSString *characterName = [line cleanCharacter];
        if (![characters containsObject:characterName])
            [characters addObject:characterName];
    }
    return (NSMutableArray *)characters;
}

#pragma mark - speaker delegate
- (void)clearHighlighting {
    for (int j = 0; j < [self.objects count]; j++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
}

- (void)highlightLine:(Line *)line silent:(BOOL)silent {
    //todo: highlight lines based on whats speaking!
    [self clearHighlighting];
    
    NSUInteger row = [self.objects indexOfObject:line];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    MSCMoreOptionTableViewCell *cell = (MSCMoreOptionTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (silent)
        cell.textLabel.textColor = [UIColor redColor];
    else
        cell.textLabel.textColor = [UIColor blueColor];
    //todo: highlight the row.
}

- (void)finishedSpeaking {
    //todo: finished speaking
    NSLog(@"Finished Speaking");
    [self clearHighlighting];
    self.navigationItem.rightBarButtonItem.title = @"Rehearse";
    self.navigationItem.rightBarButtonItem.action = @selector(openPlayMenu:);
    self.navigationItem.leftBarButtonItem.title = @"Menu";
    self.navigationItem.leftBarButtonItem.action = @selector(openMenu:);
}

#pragma mark - pause/stop actions
- (void)stop:(id)sender {
    [self.speaker stopSpeaking];
}

- (void)pause:(id)sender {
    [self.speaker pauseSpeaking];
    self.navigationItem.leftBarButtonItem.title = @"Resume";
    self.navigationItem.leftBarButtonItem.action = @selector(unpause:);
    
}
- (void)unpause:(id)sender {
    [self.speaker unpauseSpeaking];
    self.navigationItem.leftBarButtonItem.title = @"Pause";
    self.navigationItem.leftBarButtonItem.action = @selector(pause:);
}

#pragma mark - segue prepare
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"createLine"]) {
        EditLineViewController *edit = (EditLineViewController *) segue.destinationViewController;
        edit.script = self.script;
        edit.characters = [self getCharacters];
        
        if ([sender isKindOfClass:[Line class]]) {
            edit.line = sender;
        }
    }
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
