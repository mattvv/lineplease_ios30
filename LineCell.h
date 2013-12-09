//
//  LineCell.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 12/8/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "MSCMoreOptionTableViewCell.h"
#import "LineCellDelegate.h"

@interface LineCell : MSCMoreOptionTableViewCell<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<LineCellDelegate> playDelegate;

@end
