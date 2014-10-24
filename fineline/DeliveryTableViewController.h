//
//  DeliveryTableViewController.h
//  fineline
//
//  Created by Abhinav  Khanna on 8/9/14.
//  Copyright (c) 2014 Fine Lines. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Braintree.h"

@interface DeliveryTableViewController : UITableViewController <BTDropInViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *roomNumber;
@property (strong, nonatomic) IBOutlet UITextField *bldgName;
@property (strong, nonatomic) IBOutlet UITextField *deliveryTime;

- (IBAction)confirmOrder:(id)sender;

@end
