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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.speaker = [[AVSpeechSynthesizer alloc] init];
    [self.speaker setDelegate:self];
    self.title = self.script[@"name"];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

- (IBAction)openMenu:(id)sender {
    LPNavigationController *nav = (LPNavigationController *)self.navigationController;
    [nav toggleLinesMenu];
}

- (IBAction)speakHelloWorld:(id)sender {
    NSLog(@"Speaking words");
    AVSpeechUtterance *words = [AVSpeechUtterance speechUtteranceWithString:@"Hello World! Testing new Line Please Voice"];
    [self.speaker speakUtterance:words];
}

- (IBAction)openPlayMenu:(UIBarButtonItem *)sender {
    //KxMenu for Play/Stop button
    __block LineViewController *bSelf = self;
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    for (NSString *character in [self getCharacters]) {
        [menuItems addObject:[[REMenuItem alloc] initWithTitle:character
                                                      subtitle:nil
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
    
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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

#pragma mark - Height of Cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Line *line = (Line *) [self objectAtIndexPath:indexPath];
    
    float height = [self calculateTextViewHeight:[self formatLine:line]];
    return height + 60;
}

- (float)calculateTextViewHeight:(NSString *)text
{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:FONT_SIZE]}];
    
    return size.height;
}

#pragma mark - get characters
- (NSMutableArray *) getCharacters {
    NSMutableArray * characters = [[NSMutableArray alloc] init];
    for (Line* line in self.objects) {
        NSString *characterName = [[line[@"character"] uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![characters containsObject:characterName])
            [characters addObject:characterName];
    }
    return (NSMutableArray *)characters;
}






@end
