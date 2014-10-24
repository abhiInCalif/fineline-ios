//
//  ThankYouViewController.m
//  fineline
//
//  Created by Abhinav  Khanna on 8/22/14.
//  Copyright (c) 2014 Fine Lines. All rights reserved.
//

#import "ThankYouViewController.h"
#import "Order.h"

@interface ThankYouViewController ()

@end

@implementation ThankYouViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = true;
    
    // update the order....
    Order* order = [Order sharedOrder];
    
    // loop through all items in order, and clear the count
    for (int i = 0; i < [order.items count]; i++) {
        [[order.items objectAtIndex:i] setCount:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)call:(id)sender {
    UIApplication* myApp = [UIApplication sharedApplication];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", @"6507761881"]];
    [myApp openURL:telURL];
}
@end
