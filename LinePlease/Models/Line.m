//
//  Line.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/3/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "Line.h"
#import <Parse/PFObject+Subclass.h>

@implementation Line

+ (NSString *)parseClassName {
    return @"Line";
}

- (NSString *)cleanCharacter {
    return [[self[@"character"] uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
@end
