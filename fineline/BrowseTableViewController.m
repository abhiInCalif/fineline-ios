//
//  BrowseTableViewController.m
//  fineline
//
//  Created by Abhinav  Khanna on 8/6/14.
//  Copyright (c) 2014 Fine Lines. All rights reserved.
//

#import "BrowseTableViewController.h"
#import "Order.h"
#import "BrowseTableViewCell.h"
#import "ShoppingItem.h"
#import "FineLineAPIClient.h"

@interface BrowseTableViewController ()

@end

@implementation BrowseTableViewController

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
}

- (void)viewDidAppear:(BOOL)animated {
    Order* yourOrder = [Order sharedOrder];
    FineLineAPIClient *client = [FineLineAPIClient sharedClient];
    
    [client getCatalogue:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Success -- %@", responseObject);
        NSArray* responseDictionary = (NSArray*) responseObject;
        for (int i = 0; i < [responseDictionary count]; i = i + 1) {
            ShoppingItem* item = [ShoppingItem new];
            item.price = [NSString stringWithFormat:@"%@",[responseDictionary objectAtIndex:i][@"fields"][@"price"]];
            item.photoUrl = [responseDictionary objectAtIndex:i][@"fields"][@"photo"];
            item.name = [responseDictionary objectAtIndex:i][@"fields"][@"name"];
            item.sku = [responseDictionary objectAtIndex:i][@"fields"][@"sku"];
            item.stock = [[responseDictionary objectAtIndex:i][@"fields"][@"stock"] intValue];
            item.count = [(ShoppingItem*)[yourOrder.items objectAtIndex:i] count];
            yourOrder.items[i] = item;
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure -- %@", error);
    }];
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
    return [order.items count] + 1; // this is the catalogue currently, after this view we will update the counts for the shopping items.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BrowseCell";
    BrowseTableViewCell *cell = (BrowseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Order* order = [Order sharedOrder];
    if (indexPath.row < [order.items count]) {
        
        // set the field names
        
        // set the name UILabel
        cell.name.text = [(ShoppingItem*)[order.items objectAtIndex:indexPath.row] name];
        
        // set the cost UILabel
        cell.cost.text = [NSString stringWithFormat:@"Cost: $%@",[(ShoppingItem*)[order.items objectAtIndex:indexPath.row] price]];
        
        // set the count UILabel
        cell.count.text = [NSString stringWithFormat:@"Count: %d", [(ShoppingItem*)[order.items objectAtIndex:indexPath.row] count]];
        
        // set the rowNumber field
        cell.rowNumber = indexPath.row;
        
        // check the stock.
        if ([[order.items objectAtIndex:indexPath.row] stock] == 0) {
            // disable the count indicator
            // display the soldout image instead
            cell.image.image = [UIImage imageNamed:@"soldout.png"];
            cell.userInteractionEnabled = FALSE;
        } else {
            // set the image with the contents of the url
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                // url creation
                NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[order.items objectAtIndex:indexPath.row] photoUrl]]];
                
                // load image data from url
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                
                // convert data to image via async call.
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    cell.image.image = [UIImage imageWithData:imageData];
                });
            });
        }
        
    } else if(indexPath.row == [order.items count]) {
        
        // otherwise its just a simple button.
        UITableViewCell *altCell = [tableView dequeueReusableCellWithIdentifier:@"PurchaseCell"];
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

- (IBAction)purchase:(id)sender {
    // triggers the segue to the next view
    Order* order = [Order sharedOrder];
    
    // isolate the items that have a count, and make a copy of those into myOrder
    order.myOrder = [NSMutableArray new];
    for (int i = 0; i < [order.items count]; i++) {
        if ([(ShoppingItem*)[order.items objectAtIndex:i] count] > 0) {
            [order.myOrder addObject:[order.items objectAtIndex:i]];
        }
    }
    
    if ([order.myOrder count] > 0) {
        [self performSegueWithIdentifier:@"toOrder" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cart Error!"
                                                        message:@"You need to add an item to your cart to complete your purchase!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
@end
