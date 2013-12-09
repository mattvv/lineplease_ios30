//
//  LPViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/23/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "LPNavigationController.h"
#import "ScriptViewController.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "AddScriptViewController.h"
#import "LineViewController.h"
#import "TestFlight.h"
#import <TestFlight+OpenFeedback.h>

@interface LPNavigationController () {
    BOOL showingMenu;
}
@end

@implementation LPNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    REMenuItem *addScriptItem = [[REMenuItem alloc] initWithTitle:@"Create Script"
                                                    subtitle:@"Create a new script"
                                                       image:[UIImage imageNamed:@"menu_add_script"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          if ([self.visibleViewController isKindOfClass:[ScriptViewController class]]) {
                                                              [self.visibleViewController performSegueWithIdentifier:@"AddScript" sender:self];
                                                          } else if (![self.visibleViewController isKindOfClass:[AddScriptViewController class]]) {
                                                              [self popViewControllerAnimated:NO];
                                                              [self.visibleViewController performSegueWithIdentifier:@"AddScript" sender:self];
                                                          }
                                                          showingMenu = NO;
                                                      }];
    
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"Scripts"
                                                    subtitle:@"View your Scripts"
                                                       image:[UIImage imageNamed:@"menu_scripts"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          if (![self.visibleViewController isKindOfClass:[ScriptViewController class]]) {
                                                              [self popToRootViewControllerAnimated:NO];
                                                          }
                                                          showingMenu = NO;
                                                      }];
    REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"Profile"
                                                    subtitle:@"Edit your profile"
                                                       image:[UIImage imageNamed:@"menu_profile"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          if ([self.visibleViewController isKindOfClass:[ScriptViewController class]]) {
                                                              [self.visibleViewController performSegueWithIdentifier:@"Profile" sender:self];
                                                          } else if (![self.visibleViewController isKindOfClass:[ProfileViewController class]]) {
                                                              [self popViewControllerAnimated:NO];
                                                              [self.visibleViewController performSegueWithIdentifier:@"Profile" sender:self];
                                                          }
                                                          showingMenu = NO;
                                                      }];
    
    REMenuItem *settingsItem = [[REMenuItem alloc] initWithTitle:@"Settings"
                                                       subtitle:@"Adjust playback speed, pause time"
                                                          image:[UIImage imageNamed:@"menu_settings"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             showingMenu = NO;
                                                             if ([self.visibleViewController isKindOfClass:[ScriptViewController class]]) {
                                                                 [self.visibleViewController performSegueWithIdentifier:@"Settings" sender:self];
                                                             } else if (![self.visibleViewController isKindOfClass:[SettingsViewController class]]) {
                                                                 [self popViewControllerAnimated:NO];
                                                                 [self.visibleViewController performSegueWithIdentifier:@"Settings" sender:self];
                                                             }
                                                         }];
    
    REMenuItem *feedbackItem = [[REMenuItem alloc] initWithTitle:@"Feedback"
                                                        subtitle:@"Found a bug? Send us feedback!"
                                                           image:nil
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                            [TestFlight openFeedbackView];
                                                          }];
    self.menu = [[REMenu alloc] initWithItems:@[addScriptItem, homeItem, settingsItem, profileItem, feedbackItem]];
    [self themeMenu:self.menu];
    
    REMenuItem *scriptsItem = [[REMenuItem alloc] initWithTitle:@"Back to Scripts"
                                                    subtitle:@"Back to your listing of scripts"
                                                       image:[UIImage imageNamed:@"menu_scripts"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [self popViewControllerAnimated:YES];
                                                      }];
    
    REMenuItem *addlineItem = [[REMenuItem alloc] initWithTitle:@"Add Line"
                                                       subtitle:@"Create a new Line"
                                                          image:[UIImage imageNamed:@"menu_add_line"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [self.visibleViewController performSegueWithIdentifier:@"createLine" sender:self];
                                                         }];
    
    REMenuItem *reorderLines = [[REMenuItem alloc] initWithTitle:@"Re-order Lines"
                                                       subtitle:@"Change the order of your lines"
                                                           image:[UIImage imageNamed:@"menu_reorder"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             LineViewController *lvc = (LineViewController *) self.visibleViewController;
                                                             [lvc startDragging:self];
                                                         }];
    
    self.linesMenu = [[REMenu alloc] initWithItems:@[scriptsItem,addlineItem, reorderLines]];
    [self themeMenu:self.linesMenu];

}

- (void) toggleMenu {
    if (!showingMenu) {
        [self.menu showFromNavigationController:self];
        showingMenu = YES;
        return;
    }
    
    [self.menu closeWithCompletion:^{
        showingMenu = NO;
    }];
}

- (void) toggleLinesMenu {
    if (self.characterMenu) {
        [self.characterMenu close];
    }
    
    if (!showingMenu) {
        [self.linesMenu showFromNavigationController:self];
        showingMenu = YES;
        return;
    }
    
    [self.linesMenu closeWithCompletion:^{
        showingMenu = NO;
    }];
}

- (IBAction)logout:(id)sender {
    [User logOut];
    [self popToRootViewControllerAnimated:YES];
}

- (void) themeMenu:(REMenu *)menu {
    //theme menu
    menu.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
    
    menu.liveBlur = YES;
    menu.liveBlurBackgroundStyle = UIBarStyleDefault;
    menu.liveBlurTintColor = [UIColor whiteColor];
    
    menu.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    menu.textShadowColor = [UIColor clearColor];
    menu.textColor = [UIColor blackColor];
    menu.separatorColor = [UIColor lightGrayColor];
    menu.separatorHeight = 0.5f;
    
    menu.subtitleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    menu.subtitleTextShadowColor = [UIColor clearColor];
    menu.borderColor = [UIColor lightGrayColor];
    menu.borderWidth = 0.5f;
    
    menu.highlightedBackgroundColor = [UIColor lightGrayColor];
    menu.highlightedTextShadowColor = [UIColor clearColor];
    menu.subtitleHighlightedTextShadowColor = [UIColor clearColor];
    
    menu.itemHeight = 70.0f;
}

- (void) displayCharacterMenu:(NSMutableArray *)menuItems {
    if (self.characterMenu) {
        [self.characterMenu close];
    }
    [self.linesMenu closeWithCompletion:^{
        showingMenu = NO;
    }];
    self.characterMenu = nil; //de-allocate the previous menu.
    self.characterMenu = [[REMenu alloc] initWithItems:menuItems];
    [self themeMenu:self.characterMenu];
    [self.characterMenu showFromNavigationController:self];
}
@end
