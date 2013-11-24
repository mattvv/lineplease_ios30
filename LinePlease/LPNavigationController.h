//
//  LPViewController.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/23/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"

@interface LPNavigationController : UINavigationController

@property (nonatomic, strong) REMenu *menu;
@property (nonatomic, strong) REMenu *linesMenu;
@property (nonatomic, strong) REMenu *characterMenu;

- (void) toggleMenu;
- (void) toggleLinesMenu;
- (void) displayCharacterMenu:(NSMutableArray *)menuItems;

@end
