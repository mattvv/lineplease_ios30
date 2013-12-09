//
//  LineCellDelegate.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 12/8/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LineCell.h"

@protocol LineCellDelegate
@required
- (void) playCellPressed:(UITableViewCell *)cell;
@end