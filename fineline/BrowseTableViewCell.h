//
//  BrowseTableViewCell.h
//  fineline
//
//  Created by Abhinav  Khanna on 8/6/14.
//  Copyright (c) 2014 Fine Lines. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIStepper *incrementCount;
@property (strong, nonatomic) IBOutlet UILabel *count;
@property (strong, nonatomic) IBOutlet UILabel *cost;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (assign, nonatomic) int rowNumber;
- (IBAction)updateCount:(id)sender;

@end
