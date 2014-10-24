//
//  BrowseTableViewCell.m
//  fineline
//
//  Created by Abhinav  Khanna on 8/6/14.
//  Copyright (c) 2014 Fine Lines. All rights reserved.
//

#import "BrowseTableViewCell.h"
#import "Order.h"
#import "ShoppingItem.h"

@implementation BrowseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)updateCount:(id)sender {
    double value = [(UIStepper*)sender value];
    [self.count setText:[NSString stringWithFormat:@"Count: %d", (int)value]];
    
    // update the appropriate variable in the orders
    
    Order* order = [Order sharedOrder];
    NSMutableArray* items = [order items];
    ShoppingItem* item = [items objectAtIndex:self.rowNumber];
    item.count = value;
    
    // this should update the count in the globally accessible variable
}
@end
