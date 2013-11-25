//
//  Script.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/3/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "Script.h"
#import <Parse/PFObject+Subclass.h>
#import "Line.h"

@implementation Script

+ (NSString *)parseClassName {
    return @"Script";
}

- (BOOL) delete {
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"Line"];
    [query whereKey:@"scriptId" equalTo:self.objectId];
    NSArray *lines = [query findObjects];
    
    for (Line *line in lines) {
        [line delete];
    }
    
    return [super delete];
}

@end
