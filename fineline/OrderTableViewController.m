//
//  OrderTableViewController.m
//  fineline
//
//  Created by Abhinav  Khanna on 8/9/14.
//  Copyright (c) 2014 Fine Lines. All rights reserved.
//

#import "OrderTableViewController.h"
#import "Order.h"
#import "ShoppingItem.h"
#import "OrderTableViewCell.h"

@interface OrderTableViewController ()

@end

@implementation OrderTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    Order* order = [Order sharedOrder];
    return [order.myOrder count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrderCell";
    OrderTableViewCell *cell = (OrderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Order* order = [Order sharedOrder];
    if (indexPath.row < [order.myOrder count]) {
        
        // set the field names
        
        // set the name UILabel
        cell.name.text = [(ShoppingItem*)[order.myOrder objectAtIndex:indexPath.row] name];
        
        // set the cost UILabel
        cell.cost.text = [NSString stringWithFormat:@"Cost: $%@",[(ShoppingItem*)[order.myOrder objectAtIndex:indexPath.row] price]];
        
        // set the count UILabel
        cell.count.text = [NSString stringWithFormat:@"Count: %d",[(ShoppingItem*)[order.myOrder objectAtIndex:indexPath.row] count]];
        
        // set the image with the contents of the url
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            // url creation
            NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[order.myOrder objectAtIndex:indexPath.row] photoUrl]]];
            
            // load image data from url
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            
            // convert data to image via async call.
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                cell.image.image = [UIImage imageWithData:imageData];
            });
        });
    } else if(indexPath.row == [order.myOrder count]) {
        
        // otherwise its just a simple button.
        UITableViewCell *altCell = [tableView dequeueReusableCellWithIdentifier:@"NextCell"];
        return altCell;
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)next:(id)sender {
    // on click of next button perform the segueue to the delivery view
    [self performSegueWithIdentifier:@"toDelivery" sender:self];
}
@end
