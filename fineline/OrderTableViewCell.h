//
//  OrderTableViewCell.h
//  fineline
//
//  Created by Abhinav  Khanna on 8/9/14.
//  Copyright (c) 2014 Fine Lines. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *cost;
@property (strong, nonatomic) IBOutlet UILabel *count;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@end
